//
//  ResultTableViewCell.h
//  Party
//
//  Created by Erica Caber on 6/23/14.
//  Copyright (c) 2014 Erica Caber. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Participants;

@interface ResultTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *winnerView;


-(void)setResultDetails:(Participants*)info;
@end
