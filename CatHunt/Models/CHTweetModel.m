//
//  CHTweetModel.m
//  CatHunt
//
//  Created by shoby on 2015/01/07.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import "CHTweetModel.h"
#import "CHEntitiesModel.h"
#import "CHMediaModel.h"
#import "CHSizesModel.h"
#import "CHSizeModel.h"

@interface CHTweetModel ()<MTLJSONSerializing>

@end

@implementation CHTweetModel

- (NSURL *)imageURL
{
    CHMediaModel *media = self.entities.mediaArray.firstObject;
    return media.mediaURL;
}

- (NSInteger)imageWidth
{
    CHMediaModel *media = self.entities.mediaArray.firstObject;
    return media.sizes.large.width;
}

- (NSInteger)imageHeight
{
    CHMediaModel *media = self.entities.mediaArray.firstObject;
    return media.sizes.large.height;
}

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
