//
//  CHMediaModel.h
//  CatHunt
//
//  Created by shoby on 2015/01/07.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import <Mantle/Mantle.h>

@class CHSizesModel;

@interface CHMediaModel : MTLModel
@property (copy, nonatomic, readonly) NSURL *mediaURL;
@property (copy, nonatomic, readonly) NSString *type;
@property (strong, nonatomic, readonly) CHSizesModel *sizes;
@end
