//
//  CHTweetModel.h
//  CatHunt
//
//  Created by shoby on 2015/01/07.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import <Mantle/Mantle.h>

@class CHEntitiesModel;

@interface CHTweetModel : MTLModel
@property (assign, nonatomic, readonly) NSInteger ID;
@property (copy, nonatomic, readonly) NSString *text;
@property (strong, nonatomic, readonly) CHEntitiesModel *entities;
@end
