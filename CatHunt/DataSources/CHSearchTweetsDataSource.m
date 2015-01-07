//
//  CHSearchTweetsDataSource.m
//  CatHunt
//
//  Created by shoby on 2015/01/08.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import "CHSearchTweetsDataSource.h"
#import "CHTwitterAPIClient.h"
#import "NSMutableDictionary+CHTwitterAPIParameters.h"
#import "CHTweetModel.h"

static const NSUInteger CHSearchTweetsDataSourceDefaultFetchCount = 20;

@interface CHSearchTweetsDataSource ()
@property (copy, nonatomic) NSString *query;
@property (strong, nonatomic) NSMutableArray *tweets;

@property (strong, nonatomic) CHTwitterAPIClient *apiClient;

@property (nonatomic, readonly) NSDictionary *defaultOptions;
@property (nonatomic, readonly) NSDictionary *loadNextOptions;
@end

@implementation CHSearchTweetsDataSource

- (NSUInteger)count
{
    return self.tweets.count;
}

- (instancetype)initWithQuery:(NSString *)query
{
    self = [super init];
    if (self) {
        self.query = query;
        self.tweets = [NSMutableArray array];
        self.apiClient = [[CHTwitterAPIClient alloc] init];
    }
    return self;
}

- (CHTweetModel *)tweetAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return nil;
    }
    
    return self.tweets[index];
}

- (void)reloadWithSuccess:(void (^)(void))successBlock
                  failure:(void (^)(NSError *))failureBlock
{
    [self reset];
    
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setCount:CHSearchTweetsDataSourceDefaultFetchCount];
    
    [self loadWithOptions:options success:successBlock failure:failureBlock];
}

- (void)loadNextWithSuccess:(void (^)(void))successBlock
                    failure:(void (^)(NSError *))failureBlock
{
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setCount:CHSearchTweetsDataSourceDefaultFetchCount];
    [options setMaxID:[self.tweets.lastObject ID]];
    
    [self loadWithOptions:options success:successBlock failure:failureBlock];
}

- (void)loadWithOptions:(NSDictionary *)options
                success:(void (^)(void))successBlock
                failure:(void (^)(NSError *))failureBlock
{
    [self.apiClient searchTweetsWithQuery:self.query options:options success:^(NSArray *tweets) {
        [self.tweets addObjectsFromArray:tweets];
        
        if (successBlock) {
            successBlock();
        }
    } failure:failureBlock];
}

- (void)reset
{
    self.tweets = [NSMutableArray array];
}

@end