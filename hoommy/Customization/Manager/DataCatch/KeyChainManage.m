//
//  KeyChainManage.m
//  HongXiaoBao
//
//  Created by 牛严 on 16/6/16.
//  Copyright © 2016年 hongxb. All rights reserved.
//

#import "KeyChainManage.h"
#import "HSJKeyChainStore.h"

#import <Security/Security.h>

static NSString * const kToken = @"token";
static NSString * const kService = @"www.hoomxb.com";
static NSString *const kIsLogin = @"kIsLogin";

@interface KeyChainManage ()

@property (nonatomic, strong) HSJKeyChainStore *keychain;

@end

@implementation KeyChainManage

+ (instancetype)sharedInstance
{
    static KeyChainManage *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.keychain = [[HSJKeyChainStore alloc] initWithService:kService];
    });
    
    return sharedInstance;
}

- (void)setToken:(NSString *)token
{
    if(!token) {
        [self.keychain removeItemForKey:kToken];
        return;
    }
    [self.keychain setItemForKey:token ForKey:kToken];
}

- (NSString *)token
{
    NSString *token = [self.keychain itemForkey:kToken];
    return token?:@"";
}

-(BOOL)isLogin
{
    return [[self.keychain itemForkey:kIsLogin] integerValue];
}

- (void)setIsLogin:(BOOL)isLogin {
     [self.keychain setItemForKey:@(isLogin).description ForKey:kIsLogin];
}

//- (void)setValueWith
@end

