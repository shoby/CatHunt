//
//  CHTweetModel.m
//  CatHunt
//
//  Created by shoby on 2015/01/07.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import "CHTweetModel.h"
#import "CHEntitiesModel.h"

@interface CHTweetModel ()<MTLJSONSerializing>

@end

@implementation CHTweetModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"ID": @"id",
             @"text": @"text",
             @"entities": @"entities"};
}

+ (NSValueTransformer *)entitiesJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:CHEntitiesModel.class];
}

@end
