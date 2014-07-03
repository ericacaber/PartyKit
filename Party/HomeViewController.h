//
//  HomeViewController.h
//  Party
//
//  Created by Erica Caber on 6/23/14.
//  Copyright (c) 2014 Erica Caber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

+(HomeViewController*)sharedController;

- (NSManagedObjectContext *)managedObjectContext;
- (IBAction)birthdaayStartAction:(id)sender;
- (IBAction)momentsAction:(id)sender;
@end
