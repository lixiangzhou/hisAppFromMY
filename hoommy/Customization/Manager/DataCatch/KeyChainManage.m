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

#define kGesturePwd [NSString stringWithFormat:@"kGesturePwd%@", KeyChain.mobile ?: @""]
// 是否忽略手势密码
#define kHXBGesturePwdSkipeKey [NSString stringWithFormat:@"kHXBGesturePwdSkipeKey%@", KeyChain.mobile ?: @""]
// 是否出现过忽略手势密码弹窗
#define kHXBGesturePwdSkipeAppeardKey [NSString stringWithFormat:@"kHXBGesturePwdSkipeAppeardKey%@", KeyChain.mobile ?: @""]

static NSString * const kSiginPwd = @"HXBSinInCount";
static NSString * const kToken = @"token";
static NSString * const kService = @"www.hoommy.com";
static NSString *const kIsLogin = @"kIsLogin";
static NSString * const kLoginPwd = @"loginPwd";
static NSString * const kTradePwd = @"tradePwd";
static NSString * const kGesturePwdCount = @"gesturePwdCount";
///手机号
static NSString *const kMobile = @"kMobile";
//统一密文处理
static NSString * const kCiphertext = @"ciphertext";
//H5页面的BaseURL
static NSString *const hostH5 = @"hostH5";

//缓存首页获取的计划列表中的第一条记录的planid
static NSString *const kFirstPlanId = @"kFirstPlanId";

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

- (void)removeGesture
{
    if (kGesturePwd.length > 0) {
        [self.keychain removeItemForKey:kGesturePwd];
    }
    [self.keychain removeItemForKey:kGesturePwdCount];
}

- (void)signOut
{
    KeyChainManage *manager = KeyChain;
    self.isLogin = NO;
    [manager.keychain removeItemForKey:kLoginPwd];
    [manager.keychain removeItemForKey:kTradePwd];
    [manager.keychain removeItemForKey:kToken];
    [manager.keychain removeItemForKey:kCiphertext];
    [KeyChain removeGesture];
}
- (NSString *)ciphertext
{
    NSString *ciphertext = [self.keychain itemForkey:kCiphertext];
    return ciphertext?:@"";
}
- (void)setLoginPwd:(NSString *)loginPwd
{
    [self.keychain setItem:loginPwd ForKey:kLoginPwd];
}
- (NSString *)loginPwd
{
    NSString *loginPwd = [self.keychain itemForkey:kLoginPwd];
    return loginPwd?:@"";
}
- (void)setCiphertext:(NSString *)ciphertext
{
    [self.keychain setItem:ciphertext ForKey:kCiphertext];
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
    [self.keychain setItem:h5host ForKey:hostH5];
}


- (NSString *)mobile {
    NSString *mobile = [self.keychain itemForkey:kMobile];
    return mobile?:@"";
}

- (void)setSiginCount:(NSString *)siginCount {
    [self.keychain setItem:siginCount ForKey:kSiginPwd];
}

- (NSString *)siginCount {
    return [self.keychain itemForkey:kSiginPwd] ? : @"0";
}

- (void)setFirstPlanIdInPlanList:(NSString *)firstPlanIdInPlanList {
    [[IDPCache sharedCache] setObj:firstPlanIdInPlanList forKey:kFirstPlanId];
}

- (NSString *)firstPlanIdInPlanList {
    NSString *planId = [[IDPCache sharedCache] objectForKey:kFirstPlanId];
    return planId ?: @"";
}

- (void)setMobile:(NSString *)mobile {
    [self.keychain setItem:mobile ForKey:kMobile];
}

- (void)setToken:(NSString *)token
{
    if(!token) {
        [[IDPCache sharedCache] removeObjcetForKey:kToken];
        return;
    }
    [[IDPCache sharedCache] setObj:token forKey:kToken];
}

- (NSString *)token
{
    NSString *token = [[IDPCache sharedCache] objectForKey:kToken];
    return token?:@"";
}

- (void)setGesturePwd:(NSString *)gesturePwd
{
    [self.keychain setItem:gesturePwd ForKey:kGesturePwd];
}

- (void)setGesturePwdCount:(NSInteger)gesturePwdCount
{
    [self.keychain setItem:[NSString stringWithFormat:@"%zd", gesturePwdCount] ForKey:kGesturePwdCount];
}

- (NSString *)gesturePwd
{
    NSString *gesturePwd = [self.keychain itemForkey:kGesturePwd];
    return gesturePwd?:@"";
}

- (NSInteger)gesturePwdCount
{
    NSString *number = [self.keychain itemForkey:kGesturePwdCount];
    if (number) {
        NSInteger gesturePwdCount = [number integerValue];
        return gesturePwdCount;
    } else {    
        return NSNotFound;
    }
}

- (NSString *)skipGesture {
    return [self.keychain itemForkey:kHXBGesturePwdSkipeKey];
}

- (void)setSkipGesture:(NSString *)skipGesture {
    [self.keychain setItem:skipGesture ForKey:kHXBGesturePwdSkipeKey];
}

- (void)setSkipGestureAlertAppeared:(BOOL)skipGestureAlertAppeared {
    [self.keychain setItem:@(skipGestureAlertAppeared).description ForKey:kHXBGesturePwdSkipeAppeardKey];
}

- (BOOL)skipGestureAlertAppeared {
    return [self.keychain itemForkey:kHXBGesturePwdSkipeAppeardKey];
}

-(BOOL)isLogin
{
    NSNumber *loginState = [[IDPCache sharedCache] objectForKey:kIsLogin];
    return loginState.boolValue;
}

- (void)setIsLogin:(BOOL)isLogin {
    [[IDPCache sharedCache] setObj:@(isLogin) forKey:kIsLogin];
}


@end

