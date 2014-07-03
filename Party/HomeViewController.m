//
//  HomeViewController.m
//  Party
//
//  Created by Erica Caber on 6/23/14.
//  Copyright (c) 2014 Erica Caber. All rights reserved.
//

#import "HomeViewController.h"
#import "BirthdaaaaaayViewController.h"
#import "CameraViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

+ (HomeViewController *)sharedController
{
    static HomeViewController *defaultDare = nil;
    if(!defaultDare)
        defaultDare = [[super allocWithZone:nil] init];
    
    return defaultDare;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedController];
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)birthdaayStartAction:(id)sender {
    
    BirthdaaaaaayViewController *vc = [[BirthdaaaaaayViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)momentsAction:(id)sender {
    
    CameraViewController *vc = [[CameraViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
