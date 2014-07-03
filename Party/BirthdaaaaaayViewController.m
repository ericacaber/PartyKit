//
//  BirthdaaaaaayViewController.m
//  Party
//
//  Created by Erica Caber on 6/19/14.
//  Copyright (c) 2014 Erica Caber. All rights reserved.
//

#import "BirthdaaaaaayViewController.h"
#import "Participants.h"
#import "ResultsTableViewController.h"
#import "HomeViewController.h"
#import "NSArray+Sorting.h"

@interface BirthdaaaaaayViewController () {
    NSTimeInterval time;
    BOOL running;
    NSTimeInterval finalTime;
}

@end

@implementation BirthdaaaaaayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self clearInfo];
    self.stopButton.hidden = YES;
    self.saveButton.hidden = YES;
    self.startButton.hidden = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [_nameTextfield resignFirstResponder];
}

- (IBAction)saveAction:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Happy Birthday"
                                                    message:@"Is there other Player?"
                                                   delegate:self
                                          cancelButtonTitle:@"NO"
                                          otherButtonTitles:@"YES", nil];
    alert.tag = 1;
    [alert show];
    
}

-(void)save {
    
    if ([[self.nameTextfield text] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Happy Birthday"
                                                        message:@"Please Input Name"
                                                       delegate:self
                                              cancelButtonTitle:@"CLOSE"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        
        NSManagedObjectContext *context = [[HomeViewController sharedController] managedObjectContext];
        NSError *error = nil;
        
        NSManagedObject *participant = [NSEntityDescription insertNewObjectForEntityForName:@"Participants" inManagedObjectContext:context];
        
        [participant setValue:[self.nameTextfield text] forKey:@"name"];
        [participant setValue:[self.timeLabel text] forKeyPath:@"time"];
        
        if (![context save:&error]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Happy Birthday"
                                                            message:[error localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:@"CLOSE"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        
        [self clearInfo];
 
    }
    
    
}

- (IBAction)startAction:(id)sender {
    
    self.stopButton.hidden = NO;
    self.startButton.hidden = YES;
    time = [NSDate timeIntervalSinceReferenceDate];
    running = YES;
    [self updateTime];
}

-(void)updateTime {
    
    if (!running) {
        return;
    }
    
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsedTime = currentTime - time;
    
    int mins = (int) (elapsedTime / 60.0);
    elapsedTime -= mins * 60;
    int secs = (int)(elapsedTime);
    elapsedTime -= secs;
    
    int fraction = elapsedTime * 10.0;
    finalTime = elapsedTime;
    self.timeLabel.text = [NSString stringWithFormat:@"%02u:%02u.%u", mins, secs, fraction];
    
    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.01f];
}


- (IBAction)stopAction:(id)sender {
    
    running = NO;
    self.stopButton.hidden = YES;
    self.saveButton.hidden = NO;
    
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            [self save];
            [self showConfirmAlert];
        } else {
            [self save];
            _startButton.hidden = NO;
        }
    } else if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            [self showResults];
        }
    }
    
    
}

-(void)clearInfo {
    
    _nameTextfield.text = @"";
    _timeLabel.text = @"0:00";
}

-(void)showResults {
    
    NSManagedObjectContext *context = [[HomeViewController sharedController] managedObjectContext];
    NSError *error = nil;
    
    NSMutableArray *overall = [NSMutableArray array];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Participants"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (Participants *info in fetchedObjects) {
        [overall addObject:info];
    }
    
    ResultsTableViewController *vc = [[ResultsTableViewController alloc] initWithResultsArray:overall];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)showConfirmAlert {
    
    UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:@"Happy Birthday"
                                                           message:@"Do you want to view the results?"
                                                          delegate:self
                                                 cancelButtonTitle:@"NO"
                                                 otherButtonTitles:@"YES", nil];
    confirmAlert.tag = 2;
    [confirmAlert show];
}


@end
