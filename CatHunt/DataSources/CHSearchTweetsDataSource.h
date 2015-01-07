//
//  CHSearchTweetsDataSource.h
//  CatHunt
//
//  Created by shoby on 2015/01/08.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHTweetModel;

@interface CHSearchTweetsDataSource : NSObject
@property (nonatomic, readonly) NSUInteger count;

- (instancetype)initWithQuery:(NSString *)query;

- (CHTweetModel *)tweetAtIndex:(NSUInteger)index;

- (void)reloadWithSuccess:(void (^)(void))successBlock
                  failure:(void (^)(NSError *error))failureBlock;
- (void)loadNextWithSuccess:(void (^)(void))successBlock
                    failure:(void (^)(NSError *))failureBlock;

@end
