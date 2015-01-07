//
//  CHTwitterAccountStore.h
//  CatHunt
//
//  Created by shoby on 2015/01/07.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHTwitterAccountStore : NSObject

- (void)fetchAccountsWithSuccess:(void (^)(NSArray *accounts))successBlock
                    failureBlock:(void (^)(NSError *error))failureBlock;

@end
