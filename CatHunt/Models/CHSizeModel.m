//
//  CHSizeModel.m
//  CatHunt
//
//  Created by shoby on 2015/01/07.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import "CHSizeModel.h"

@interface CHSizeModel ()<MTLJSONSerializing>

@end

@implementation CHSizeModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"width": @"w",
             @"height": @"h",
             @"resize": @"resize"};
}

@end
