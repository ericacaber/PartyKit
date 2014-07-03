//
//  CameraConfiguration.m
//  Party
//
//  Created by Erica Caber on 7/2/14.
//  Copyright (c) 2014 Erica Caber. All rights reserved.
//

#import "CameraConfiguration.h"

@implementation CameraConfiguration

-(id)init {
    
    self = [super init];
    if (self) {
        self.captureSession = [[AVCaptureSession alloc]init];
    }
    return self;
}

-(void)addCameraLayer{
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

-(void)addVideoInput {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        NSError *error;
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        
        if (!error) {
            [[self captureSession] addInput:deviceInput];
        }
    }
}

-(void)addImageOutput {
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    self.stillImageOutput.outputSettings = outputSettings;
    
    AVCaptureConnection *connection = nil;
    for (AVCaptureConnection *conn in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [conn inputPorts]) {
            if ([port.mediaType isEqualToString:AVMediaTypeVideo]) {
                connection = conn;
                break;
            }
        }
        if (connection) {
            break;
        }
    }
    
    [self.captureSession addOutput:self.stillImageOutput];
}

-(void)renderView:(UIView*)view inContext:(CGContextRef)context {
    
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, [view center].x, [view center].y);
    
    CGContextConcatCTM(context, [view transform]);
	
    CGContextTranslateCTM(context,
                          -[view bounds].size.width * [[view layer] anchorPoint].x,
                          -[view bounds].size.height * [[view layer] anchorPoint].y);
    
    [[view layer] renderInContext:context];
	
    CGContextRestoreGState(context);
    
}

-(void)captureImage:(UIView*)border {
    AVCaptureConnection *connection = nil;
    for (AVCaptureConnection *conn in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [conn inputPorts]) {
            if ([port.mediaType isEqualToString:AVMediaTypeVideo]) {
                connection = conn;
                break;
            }
        }
        if (connection) {
            break;
        }
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection
                                                       completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                           NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                           
                                                           UIImage *image = [[UIImage alloc] initWithData:imageData];
                                                           
                                                           CGSize imageSize = [[UIScreen mainScreen] bounds].size;
                                                           UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
                                                           
                                                           CGContextRef context = UIGraphicsGetCurrentContext();
                                                           
                                                           UIGraphicsPushContext(context);
                                                           [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                                                           UIGraphicsPopContext();
                                                           
                                                           [self renderView:border inContext:context];
                                                           
                                                           UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
                                                           self.stillImage = screenshot;
                                                           
                                                           UIGraphicsEndImageContext();
                                                           
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"imageCapturedSuccessfully" object:nil];
                                                           
                                                           
                                                       }];
}

@end
