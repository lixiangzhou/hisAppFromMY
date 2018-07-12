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
static NSString * const kLoginPwd = @"loginPwd";
static NSString * const kTradePwd = @"tradePwd";
//统一密文处理
static NSString * const kCiphertext = @"ciphertext";
//H5页面的BaseURL
static NSString *const hostH5 = @"hostH5";
///手机号
static NSString *const kMobile = @"kMobile";


@interface KeyChainManage ()

@property (nonatomic, strong) HSJKeyChainStore *keychain;

@end

@implementation KeyChainManage
@synthesize mobile = _mobile;

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

- (NSString *)h5host
{
    NSString *h5Host = [self.keychain itemForkey:hostH5];
    if (!h5Host.length) {
        h5Host = @"https://m.hoomxb.com";
    }
    return h5Host;
}

- (void)setH5host:(NSString *)h5host
{
    [self.keychain setItem:hostH5 ForKey:h5host];
}
- (void)setMobile:(NSString *)mobile {
    _mobile = mobile;
    [self.keychain setItemForKey:mobile ForKey:kMobile];
}
- (NSString *)mobile {
    NSString *mobile = [self.keychain itemForkey:kMobile];
    return mobile?:@"";
}
- (void)signOut
{
    KeyChainManage *manager = KeyChain;
    self.isLogin = NO;
    [HXBRequestUserInfoViewModel signOut];
    [manager.keychain removeItemForKey:kLoginPwd];
    [manager.keychain removeItemForKey:kTradePwd];
    [manager.keychain removeItemForKey:kToken];
    [manager.keychain removeItemForKey:kCiphertext];
}

- (void)setToken:(NSString *)token
{
    if(!token) {
        [self.keychain removeItemForKey:kToken];
        return;
    }
    [self.keychain setItem:token ForKey:kToken];
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
     [self.keychain setItem:@(isLogin).description ForKey:kIsLogin];
}

//- (void)setValueWith
@end

