//
//  CHTwitterAPIClient.m
//  CatHunt
//
//  Created by shoby on 2015/01/07.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import "CHTwitterAPIClient.h"
#import "CHTwitterAccountStore.h"
#import <Social/Social.h>
#import <Mantle/Mantle.h>
#import "CHTweetModel.h"

static NSString *const TwitterAPIBaseURLString = @"https://api.twitter.com/1.1/";

@interface CHTwitterAPIClient ()
@property (strong, nonatomic) CHTwitterAccountStore *accountStore;
@property (nonatomic, readonly) NSURL *baseURL;
@property (nonatomic, readonly) NSDictionary *defaultParameters;
@end

@implementation CHTwitterAPIClient

- (NSURL *)baseURL
{
    return [NSURL URLWithString:TwitterAPIBaseURLString];
}

- (NSDictionary *)defaultParameters
{
    return @{@"include_entities": @"true"};
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.accountStore = [[CHTwitterAccountStore alloc] init];
    }
    return self;
}

- (void)searchTweetsWithQuery:(NSString *)query
                      options:(NSDictionary *)options
                      success:(void (^)(NSArray *))successBlock
                      failure:(void (^)(NSError *))failureBlock
{
    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"search/tweets.json"];
    
    NSString *percentEncodedQuery = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [@{@"q": percentEncodedQuery} mutableCopy];
    
    if (options) {
        [parameters addEntriesFromDictionary:options];
    }
    
    [self fetchWithURL:url parameters:parameters success:successBlock failure:failureBlock];
}

- (void)fetchWithURL:(NSURL *)url
          parameters:(NSDictionary *)parameters
             success:(void (^)(NSArray *))successBlock
             failure:(void (^)(NSError *))failureBlock
{
    [self.accountStore fetchAccountsWithSuccess:^(NSArray *accounts) {
        NSMutableDictionary *mutableParameters = [parameters mutableCopy];
        [mutableParameters addEntriesFromDictionary:self.defaultParameters];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodGET
                                                          URL:url
                                                   parameters:mutableParameters];
        [request setAccount:accounts.firstObject];
        
        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if (error) {
                NSLog(@"fetch error:%@", error);
                
                if (failureBlock) {
                    failureBlock(error);
                }
                return;
            }
            
            NSError *parseError = nil;
            NSArray *tweets = [self parseTweetsWithResponseData:responseData error:&parseError];
            
            if (parseError) {
                NSLog(@"parse error:%@", parseError);
                
                if (failureBlock) {
                    failureBlock(parseError);
                }
                return;
            }
            
            successBlock(tweets);
        }];
    } failureBlock:^(NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (NSArray *)parseTweetsWithResponseData:(NSData *)data error:(NSError **)error
{
    if (!data) {
        return @[];
    }
    
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
    
    if (*error) {
        return nil;
    }
    
    id statusesJSON = [json objectForKey:@"statuses"];
    
    NSMutableArray *tweets = [NSMutableArray array];
    
    NSError *mappingError = nil;
    for (NSDictionary *jsonDictionary in statusesJSON) {
        id tweet = [MTLJSONAdapter modelOfClass:CHTweetModel.class fromJSONDictionary:jsonDictionary error:&mappingError];
        
        if (mappingError) {
            NSLog(@"mapping error:%@", mappingError);
        }
        
        [tweets addObject:tweet];
    }
    
    return tweets;
}

@end
