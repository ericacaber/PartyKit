//
//  ResultTableViewCell.m
//  Party
//
//  Created by Erica Caber on 6/23/14.
//  Copyright (c) 2014 Erica Caber. All rights reserved.
//

#import "ResultTableViewCell.h"
#import "Participants.h"

@implementation ResultTableViewCell

- (void)awakeFromNib
{
    //Text Kit
    self.nameTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [self.nameTitleLabel sizeToFit];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [self.nameLabel sizeToFit];
    
    self.timeTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    [self.timeTitleLabel sizeToFit];
    self.timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    [self.timeLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setResultDetails:(Participants*)info {
    _nameLabel.text = info.name;
    _timeLabel.text = info.time;
}

@end
