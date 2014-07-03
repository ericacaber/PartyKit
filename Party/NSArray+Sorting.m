//
//  NSArray+Sorting.m
//  Party
//
//  Created by Erica Caber on 6/26/14.
//  Copyright (c) 2014 Erica Caber. All rights reserved.
//

#import "NSArray+Sorting.h"

@implementation NSArray (Sorting)

-(NSArray*)sort {
    
    NSArray *array = self;
    
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO comparator:^(NSString * string1, NSString * string2){
        return [string1 compare:string2
                        options:NSNumericSearch];
    }];
    
    [array sortedArrayUsingDescriptors:@[sortDesc]];
    
    return array;
}

@end
