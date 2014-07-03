//
//  ResultsTableViewController.h
//  Party
//
//  Created by Erica Caber on 6/23/14.
//  Copyright (c) 2014 Erica Caber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;

-(id)initWithResultsArray:(NSArray*)results;

@end
