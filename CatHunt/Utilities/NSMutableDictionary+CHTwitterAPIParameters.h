//
//  NSMutableDictionary+CHTwitterAPIParameters.h
//  CatHunt
//
//  Created by shoby on 2015/01/07.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (CHTwitterAPIParameters)
- (void)setCount:(NSUInteger)count;
- (void)setMaxID:(NSUInteger)maxID;
- (void)setSinceID:(NSUInteger)sinceID;
@end
