//
//  HSJSignInViewModel.m
//  hoommy
//
//  Created by HXB-C on 2018/7/11.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJSignInViewModel.h"

@implementation HSJSignInViewModel

/**
 校验手机号是否注册
 
 @param mobile 手机号
 @param resultBlock 返回
 */
- (void)checkExistMobile:(NSString *)mobile resultBlock:(void (^)(BOOL, NYBaseRequest *request))resultBlock
{
    NYBaseRequest *checkMobileAPI = [[NYBaseRequest alloc]init];
    checkMobileAPI.requestMethod = NYRequestMethodPost;
    checkMobileAPI.requestUrl = kHXBUser_CheckExistMobileURL;
    checkMobileAPI.requestArgument = @{
                                       @"mobile":mobile
                                       };
    self.phoneNumber = mobile;
    [checkMobileAPI loadData:^(NYBaseRequest *request, id responseObject) {
        if (resultBlock) {
            resultBlock(YES,request);
        }
    } failure:^(NYBaseRequest *request, NSError *error) {
        if (resultBlock) {
            resultBlock(NO,request);
        }
    }];
}

/**
 登录请求
 @param resultBlock 是否成功，是否需要弹图验
 */
- (void)loginRequetWithMobile:(NSString *)mobile password:(NSString *)password resultBlock:(void (^)(BOOL))resultBlock
{
    NYBaseRequest *loginAPI = [[NYBaseRequest alloc]initWithDelegate:self];
    loginAPI.requestMethod = NYRequestMethodPost;
    loginAPI.requestUrl = kHXBUser_LoginURL;
    loginAPI.requestArgument = @{
                                 @"mobile" : mobile,///         是    string    用户名
                                 @"password" : password,///     是    string    密码
                                 @"captcha" : @"",///       否    string    图验(只有在登录错误超过3次才需要输入图验)
                                 };
    
    [loginAPI loadData:^(NYBaseRequest *request, id responseObject) {
        if (resultBlock) {
            KeyChain.isLogin = YES;
            resultBlock(YES);
        }
    } failure:^(NYBaseRequest *request, NSError *error) {
         resultBlock(NO);
    }];
}


@end
