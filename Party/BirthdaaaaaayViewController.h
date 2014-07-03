//
//  BirthdaaaaaayViewController.h
//  Party
//
//  Created by Erica Caber on 6/19/14.
//  Copyright (c) 2014 Erica Caber. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ConfirmationAlertOtherPlayer = 1,
    ConfirmationAlertViewResults,
}ConfirmationAlertType;

@interface BirthdaaaaaayViewController : UIViewController <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTextfield;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)saveAction:(id)sender;
- (IBAction)startAction:(id)sender;
- (IBAction)stopAction:(id)sender;

@end
