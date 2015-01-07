//
//  CHTwitterAccountStore.m
//  CatHunt
//
//  Created by shoby on 2015/01/07.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import "CHTwitterAccountStore.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface CHTwitterAccountStore ()
@property (strong, nonatomic) ACAccountStore *accountStore;
@end

@implementation CHTwitterAccountStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

- (void)fetchAccountsWithSuccess:(void (^)(NSArray *))successBlock failureBlock:(void (^)(NSError *))failureBlock
{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Twitterアカウントが設定されていません",
                                   NSLocalizedRecoverySuggestionErrorKey: @"「設定」アプリの「Twitter」からアカウントを設定してください"};
        NSError *error = [NSError errorWithDomain:@"CHTwitterAccountStore"
                                             code:1
                                         userInfo:userInfo];
        
        if (failureBlock) {
            failureBlock(error);
        }
        return;
    }
    
    ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
        if (error) {
            NSLog(@"account access error:%@", error);
            
            if (failureBlock) {
                failureBlock(error);
            }
            return;
        }
        
        NSArray *accounts = [self.accountStore accountsWithAccountType:twitterAccountType];
        
        if (successBlock) {
            successBlock(accounts);
        }
    }];
}

@end
