//
//  CHEntitiesModel.m
//  CatHunt
//
//  Created by shoby on 2015/01/07.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import "CHEntitiesModel.h"
#import "CHMediaModel.h"

@interface CHEntitiesModel ()<MTLJSONSerializing>

@end

@implementation CHEntitiesModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"mediaArray": @"media"};
}

+ (NSValueTransformer *)mediaArrayJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:CHMediaModel.class];
}

@end
