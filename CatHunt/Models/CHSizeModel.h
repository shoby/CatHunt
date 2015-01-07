//
//  CHSizeModel.h
//  CatHunt
//
//  Created by shoby on 2015/01/07.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CHSizeModel : MTLModel
@property (assign, nonatomic, readonly) NSInteger width;
@property (assign, nonatomic, readonly) NSInteger height;
@property (copy, nonatomic, readonly) NSString *resize;
@end
