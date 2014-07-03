//
//  CameraViewController.h
//  Party
//
//  Created by Erica Caber on 6/27/14.
//  Copyright (c) 2014 Erica Caber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *borderView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIView *toolsView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *pickerPane;
@property (weak, nonatomic) IBOutlet UIButton *pickerButton;
@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;


- (IBAction)cameraAction:(id)sender;
- (IBAction)makeBoldAction:(id)sender;
- (IBAction)makeItalicAction:(id)sender;
- (IBAction)makeUnderlineAction:(id)sender;
- (IBAction)showPickerAction:(id)sender;
- (IBAction)doneAction:(id)sender;
- (IBAction)donePickerAction:(id)sender;
- (IBAction)cancelPickerAction:(id)sender;

@end
