//
//  CameraConfiguration.h
//  Party
//
//  Created by Erica Caber on 7/2/14.
//  Copyright (c) 2014 Erica Caber. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreMedia/CoreMedia.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreVideo/CoreVideo.h>

@interface CameraConfiguration : NSObject
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) UIImage *stillImage;

-(void)addCameraLayer;
-(void)addVideoInput;
- (void)addImageOutput;
- (void)captureImage:(UIView*)border;
@end
