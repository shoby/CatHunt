//
//  CHTwitterAPIClient.h
//  CatHunt
//
//  Created by shoby on 2015/01/07.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHTwitterAPIClient : NSObject

- (void)searchTweetsWithQuery:(NSString *)query
                      options:(NSDictionary *)options
                      success:(void (^)(NSArray *tweets))successBlock
                      failure:(void (^)(NSError *error))failureBlock;

@end
