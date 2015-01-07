//
//  NSMutableDictionary+CHTwitterAPIParameters.m
//  CatHunt
//
//  Created by shoby on 2015/01/07.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import "NSMutableDictionary+CHTwitterAPIParameters.h"

@implementation NSMutableDictionary (CHTwitterAPIParameters)

- (void)setCount:(NSUInteger)count
{
    [self setObject:[NSString stringWithFormat:@"%ld", count] forKey:@"count"];
}

- (void)setMaxID:(NSUInteger)maxID
{
    [self setObject:[NSString stringWithFormat:@"%ld", maxID] forKey:@"max_id"];
}

- (void)setSinceID:(NSUInteger)sinceID
{
    [self setObject:[NSString stringWithFormat:@"%ld", sinceID] forKey:@"since_id"];
}

@end
