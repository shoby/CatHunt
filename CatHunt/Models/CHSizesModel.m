//
//  CHSizesModel.m
//  CatHunt
//
//  Created by shoby on 2015/01/07.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import "CHSizesModel.h"
#import "CHSizeModel.h"

@interface CHSizesModel ()<MTLJSONSerializing>

@end

@implementation CHSizesModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"large": @"large"};
}

+ (NSValueTransformer *)largeJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:CHSizeModel.class];
}

@end
