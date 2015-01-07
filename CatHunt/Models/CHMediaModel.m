//
//  CHMediaModel.m
//  CatHunt
//
//  Created by shoby on 2015/01/07.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import "CHMediaModel.h"
#import "CHSizesModel.h"

@interface CHMediaModel ()<MTLJSONSerializing>

@end

@implementation CHMediaModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"mediaURL": @"media_url",
             @"type": @"type",
             @"sizes": @"sizes"};
}

+ (NSValueTransformer *)mediaURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)sizesJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:CHSizesModel.class];
}

@end
