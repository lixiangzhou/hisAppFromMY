//
//  HSJSignupViewModel.m
//  hoommy
//
//  Created by HXB-C on 2018/7/13.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJSignupViewModel.h"

@implementation HSJSignupViewModel

- (BOOL)erroStateCodeDeal:(NYBaseRequest *)request response:(NSDictionary *)responseObject {
    if ([request.requestUrl isEqualToString:kHXBUser_smscodeURL] && [responseObject[kResponseStatus]  isEqual: @102]) {
        return NO;
    }
    return [super erroStateCodeDeal:request response:responseObject];
}

- (void)getVerifyCodeRequesWithSignupWithAction:(NSString *)action
                                    andWithType:(NSString *)type
                                    andWithMobile:(NSString *)mobile
                                 andWithCaptcha:(NSString *)captcha
                               andCallbackBlock: (void(^)(BOOL isSuccess,BOOL isNeedCaptcha))callbackBlock {
    kWeakSelf
    [self verifyCodeRequestWithResultBlock:^(NYBaseRequest *request) {
        request.requestArgument = @{
                                    @"action":action,
                                    @"type":type,
                                    @"mobile" : mobile,
                                    @"captcha" : captcha?:@""
                                    };
        request.hudDelegate = weakSelf;
        request.showHud = YES;
    } resultBlock:^(id responseObject, NSError *error) {
        if (error) {
            NSDictionary *response = error.userInfo;
            BOOL isNeedCaptcha = [response[kResponseStatus]  isEqual: @102];
            callbackBlock(NO,isNeedCaptcha);
        }
        else {
            callbackBlock(YES,NO);
        }
    }];
}

- (void)signUPRequetWithMobile: (NSString *)mobile smscode: (NSString *)smscode password: (NSString *)password resultBlock:(NetWorkResponseBlock)resultBlock
{
    [self loadData:^(NYBaseRequest *request) {
        request.requestMethod = NYRequestMethodPost;
        request.requestUrl = kHXBUser_SignUPURL;
        request.requestArgument = @{
                                    @"mobile"    : mobile ?: @"",///           是    string    手机号
                                      @"smscode" : smscode ?: @"",///          是    string    短信验证码
                                      @"password" : password ?: @"",///       是    string    密码
                                      @"utmSource" : @"",///推广渠道
                                      @"marketSource" : @"ios"///市场来源
                                      };
        request.showHud = YES;
    } responseResult:^(id responseData, NSError *erro) {
        if (resultBlock) {
            if (responseData) {
                [KeyChain removeGesture];
                
                KeyChain.mobile = mobile;
                KeyChain.isLogin = YES;
                KeyChain.ciphertext = @"0";
                KeyChain.skipGesture = kHXBGesturePwdSkipeNONE;
                KeyChain.skipGestureAlertAppeared = NO;
            }
            resultBlock(responseData,erro);
        }
    }];
}

- (void)captchaRequestWithResultBlock:(void(^)(UIImage *captchaimage))callbackBlock {
    
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBUser_CaptchaURL;
        request.requestMethod = NYRequestMethodGet;
        request.isReturnJsonData = NO;
    } responseResult:^(id responseData, NSError *erro) {
        UIImage *captchaimage = [UIImage imageWithData:responseData];
        callbackBlock(captchaimage);
    }];
}

- (void)checkCaptchaRequestWithCaptcha:(NSString *)captcha resultBlock:(void (^)(BOOL, BOOL))resultBlock
{
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBUser_checkCaptchaURL;
        request.requestMethod = NYRequestMethodPost;
        request.requestArgument = @{
                                    @"captcha" : captcha///图验Code
                                    };
    } responseResult:^(id responseData, NSError *erro) {
        if (!erro) {
            resultBlock(YES, NO);
        } else {
            resultBlock(NO, YES);
        }
    }];
}


@end
