//
//  ResultsTableViewController.m
//  Party
//
//  Created by Erica Caber on 6/23/14.
//  Copyright (c) 2014 Erica Caber. All rights reserved.
//

#import "ResultsTableViewController.h"
#import "ResultTableViewCell.h"
#import "HomeViewController.h"
#import "NSArray+Sorting.h"
#import "Participants.h"

@interface ResultsTableViewController ()
@property (nonatomic, retain)NSArray* results;
@property (nonatomic, retain)NSString *topPlayersTime;
@end

@implementation ResultsTableViewController

-(id)initWithResultsArray:(NSArray*)results {
    
    self = [super init];
    if (self) {
        self.results = [NSArray array];
        _results = [results sortedArrayUsingDescriptors:[self sort]];
    }
    
    return self;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    Participants *topPlayer = [_results objectAtIndex:0];
    self.topPlayersTime = topPlayer.time;
}

-(NSArray*)sort {
    
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO comparator:^(NSString * string1, NSString * string2){
        return [string1 compare:string2
                        options:NSNumericSearch];
    }];
    
    return @[sortDesc];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(deleteData)];
    [self.navigationItem setRightBarButtonItem:doneButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)preferredContentSizeChanged {
    [self.tableView reloadData];
}

-(void)deleteData {
    
    NSManagedObjectContext *context = [[HomeViewController sharedController] managedObjectContext];
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Participants"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        [context deleteObject:info];
    }
    [self saveContext];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [[HomeViewController sharedController] managedObjectContext];
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_results count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"ResultTableViewCell";
    
    ResultTableViewCell *cell = (ResultTableViewCell*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
    cell = [array objectAtIndex:0];
    
    Participants * result = [_results objectAtIndex:[indexPath row]];
    [cell setResultDetails:result];
    
    if ([self.topPlayersTime isEqualToString:result.time]) {
        cell.winnerView.hidden = NO;
    }
    
    return cell;
}

@end
