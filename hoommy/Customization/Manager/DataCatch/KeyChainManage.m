//
//  KeyChainManage.m
//  HongXiaoBao
//
//  Created by 牛严 on 16/6/16.
//  Copyright © 2016年 hongxb. All rights reserved.
//

#import "KeyChainManage.h"

#import <UICKeyChainStore.h>
#import <Security/Security.h>

static NSString * const kToken = @"token";
static NSString * const kService = @"www.hoomxb.com";

@interface KeyChainManage ()

@property (nonatomic, strong) UICKeyChainStore *keychain;

@end

@implementation KeyChainManage

+ (instancetype)sharedInstance
{
    static KeyChainManage *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.keychain = [UICKeyChainStore keyChainStoreWithService:kService];
    });
    
    return sharedInstance;
}

- (void)setToken:(NSString *)token
{
    if(!token) {
        [self.keychain removeItemForKey:kToken];
        return;
    }
    self.keychain[kToken] = token;
    
}

- (NSString *)token
{
    NSString *token = self.keychain[kToken];
    return token?:@"";
}

//- (void)setValueWith
@end

