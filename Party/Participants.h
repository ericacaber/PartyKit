//
//  Participants.h
//  Party
//
//  Created by Erica Caber on 6/26/14.
//  Copyright (c) 2014 Erica Caber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Participants : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSNumber * isSameRank1;

@end
