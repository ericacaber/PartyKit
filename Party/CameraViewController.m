//
//  CameraViewController.m
//  Party
//
//  Created by Erica Caber on 6/27/14.
//  Copyright (c) 2014 Erica Caber. All rights reserved.
//

#import "CameraViewController.h"


#import "CameraConfiguration.h"

typedef enum {
    colorBlack = 0,
    colorRed,
    colorWhite,
    colorBlue,
    colorYellow,
}colorNumber;

@interface CameraViewController (){
    NSArray *colorArray;
    NSString *colorString;
    NSInteger colorNumberEqui;
}

@property (nonatomic, strong) CameraConfiguration *cameraConfig;
@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    colorArray = @[@"Black",@"Red",@"White",@"Blue",@"Yellow"];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:@"UIKeyboardWillHideNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveToCameraRoll)
                                                 name:@"imageCapturedSuccessfully" object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    // Camera Configuration
    
    CGRect rect = self.view.bounds;
    self.cameraConfig = [[CameraConfiguration alloc] init];
    [_cameraConfig addVideoInput];
    [_cameraConfig addCameraLayer];
    
    _cameraConfig.previewLayer.bounds = rect;
    _cameraConfig.previewLayer.position = CGPointMake(CGRectGetMidX(rect),CGRectGetMidY(rect));
    [self.view.layer addSublayer:_cameraConfig.previewLayer];
    
    [self.cameraConfig addImageOutput];
    
    [_cameraConfig.captureSession startRunning];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(5, 10, 30, 30)];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    [self.view addSubview:self.borderView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -Camera

-(void)backAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)cameraAction:(id)sender {
    self.cameraButton.hidden = YES;
    [self.cameraConfig captureImage:self.borderView];
}

-(void)saveToCameraRoll {
    UIImageWriteToSavedPhotosAlbum([self.cameraConfig stillImage], nil, nil, nil);
    self.cameraButton.hidden = NO;
}

#pragma mark Text Action

- (IBAction)makeBoldAction:(id)sender {
    
    [self addRemoveFontTrait:@"Bold" value:UIFontDescriptorTraitBold];
}


- (IBAction)makeItalicAction:(id)sender {
    
    [self addRemoveFontTrait:@"Italic" value:UIFontDescriptorTraitItalic];
    
}

- (IBAction)makeUnderlineAction:(id)sender {
    
    NSRange textRange = NSMakeRange(0, [_textView.text length]);
    
    NSDictionary *currentAttributes = [_textView.textStorage attributesAtIndex:textRange.location
                                                                effectiveRange:nil];
    
    UIFont *currentFont = [currentAttributes objectForKey:NSFontAttributeName];
    UIColor *currentColor = [currentAttributes objectForKey:NSForegroundColorAttributeName];
    
    NSMutableParagraphStyle *newParagaraphStyle = [[NSMutableParagraphStyle alloc] init];
    [newParagaraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *attributeDic;
    
    if ([currentAttributes objectForKey:NSUnderlineStyleAttributeName] == nil ||
        [[currentAttributes objectForKey:NSUnderlineStyleAttributeName] intValue] == 0) {
        
        attributeDic = @{ NSFontAttributeName: currentFont,
                          NSParagraphStyleAttributeName: newParagaraphStyle,
                          NSUnderlineStyleAttributeName: [NSNumber numberWithInt:1],
                          NSForegroundColorAttributeName : currentColor };
    }
    else{
        attributeDic = @{ NSFontAttributeName: currentFont,
                          NSParagraphStyleAttributeName: newParagaraphStyle,
                          NSUnderlineStyleAttributeName: [NSNumber numberWithInt:0],
                          NSForegroundColorAttributeName : currentColor};
    }
    
    [_textView.textStorage beginEditing];
    [_textView.textStorage setAttributes:attributeDic range:textRange];
    [_textView.textStorage endEditing];
}

- (IBAction)doneAction:(id)sender {
    [self dismissKeyboard];
    _toolsView.hidden = YES;
    _cameraButton.hidden = NO;
}

#pragma mark Text Methods

-(void)addRemoveFontTrait:(NSString*)name value:(uint32_t)traitValue {
    
    NSRange textRange = NSMakeRange(0, [_textView.text length]);
    
    NSDictionary *currentAttributes = [_textView.textStorage attributesAtIndex:textRange.location
                                                                    effectiveRange:nil];
    
    UIFont *currentFont = [currentAttributes objectForKey:NSFontAttributeName];
    UIColor *currentColor = [currentAttributes objectForKey:NSForegroundColorAttributeName];
    UIFontDescriptor *fontDescriptor = [currentFont fontDescriptor];
    
    NSString *fontNameAttribute = [[fontDescriptor fontAttributes] objectForKey:UIFontDescriptorNameAttribute];
    UIFontDescriptor *changedFontDescriptor;
    
    if ([fontNameAttribute rangeOfString:name].location == NSNotFound) {
        uint32_t existingTraitsWithNewTrait = [fontDescriptor symbolicTraits] | traitValue;
        changedFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:existingTraitsWithNewTrait];
    }
    else{
        uint32_t existingTraitsWithoutTrait = [fontDescriptor symbolicTraits] & ~traitValue;
        changedFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:existingTraitsWithoutTrait];
    }
    
    UIFont *updatedFont = [UIFont fontWithDescriptor:changedFontDescriptor size:0.0];
    
    NSMutableParagraphStyle *newParagaraphStyle = [[NSMutableParagraphStyle alloc] init];
    [newParagaraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *dict = @{NSFontAttributeName: updatedFont,
                           NSParagraphStyleAttributeName: newParagaraphStyle,
                           NSForegroundColorAttributeName : currentColor};
    
    [_textView.textStorage beginEditing];
    [_textView.textStorage setAttributes:dict range:textRange];
    [_textView.textStorage endEditing];
}

-(void)changeColorFont:(NSInteger)colorNumber{
    
    UIColor *color;
    switch (colorNumber) {
        case colorBlack:
            color = [UIColor blackColor];
            break;
        case colorRed:
            color = [UIColor redColor];
            break;
        case colorWhite:
            color = [UIColor whiteColor];
            break;
        case colorBlue:
            color = [UIColor blueColor];
            break;
        case colorYellow:
            color = [UIColor yellowColor];
            break;
        default:
            break;
    }
    
    NSRange textRange = NSMakeRange(0, [_textView.text length]);
    NSDictionary *currentAttributes = [_textView.textStorage attributesAtIndex:textRange.location
                                                                effectiveRange:nil];
    UIFont *currentFont = [currentAttributes objectForKey:NSFontAttributeName];
    
    NSMutableParagraphStyle *newParagaraphStyle = [[NSMutableParagraphStyle alloc] init];
    [newParagaraphStyle setAlignment:NSTextAlignmentCenter];
    NSDictionary *attDic;
    
    attDic = @{ NSFontAttributeName: currentFont,
                NSParagraphStyleAttributeName: newParagaraphStyle,
                NSForegroundColorAttributeName : color };
    
    [_textView.textStorage beginEditing];
    [_textView.textStorage setAttributes:attDic range:textRange];
    [_textView.textStorage endEditing];
    
}

#pragma mark Picker Action

- (IBAction)showPickerAction:(id)sender {
    [self dismissKeyboard];
    _pickerPane.hidden = NO;
    _toolsView.hidden = YES;
    
}

- (IBAction)donePickerAction:(id)sender {
    [_pickerButton setTitle:colorString forState:UIControlStateNormal];
    _pickerPane.hidden = YES;
    _toolsView.hidden = NO;
    [self changeColorFont:colorNumberEqui];
}


- (IBAction)cancelPickerAction:(id)sender {
    _pickerPane.hidden = YES;
    _toolsView.hidden = NO;
}

#pragma mark Picker Delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [colorArray count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [colorArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    colorString = [NSString stringWithFormat:@"%@", [colorArray objectAtIndex:row]];
    colorNumberEqui = row;
}

#pragma mark Keyboard

-(void)keyboardWillShow:(NSNotification*)notification {
    
    self.toolsView.hidden = NO;
    self.cameraButton.hidden = YES;
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect toolViewRect = self.toolsView.frame;
    toolViewRect.origin.y -= keyboardSize.height;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.toolsView.frame = toolViewRect;
    }];
}

-(void)keyboardWillHide:(NSNotification*)notification {
    self.toolsView.hidden = NO;
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect toolViewRect = self.toolsView.frame;
    toolViewRect.origin.y += keyboardSize.height;
    
    [UIView animateWithDuration:0.01f animations:^{
        self.toolsView.frame = toolViewRect;
    }];
}

-(void)dismissKeyboard {
    [_textView resignFirstResponder];
}
@end
