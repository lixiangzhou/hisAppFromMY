//
//  HSJSignInViewModel.m
//  hoommy
//
//  Created by HXB-C on 2018/7/11.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJSignInViewModel.h"
#import "HSJSignInModel.h"
#import "HXBRootVCManager.h"

@implementation HSJSignInViewModel


- (BOOL)erroStateCodeDeal:(NYBaseRequest *)request response:(NSDictionary *)responseObject {
    
    if ([request.requestUrl isEqualToString:kHXBUser_LoginURL] && [responseObject[kResponseStatus]  isEqual: @102]) {
        return NO;
    }
    return [super erroStateCodeDeal:request response:responseObject];
}
/**
 校验手机号是否注册
 
 @param mobile 手机号
 @param resultBlock 返回
 */
- (void)checkExistMobile:(NSString *)mobile resultBlock:(NetWorkResponseBlock)resultBlock
{
    self.phoneNumber = mobile;
    [self loadData:^(NYBaseRequest *request) {
        request.requestMethod = NYRequestMethodPost;
        request.requestUrl = kHXBUser_CheckMobileExistURL;
        request.requestArgument = @{
                                 @"mobile":mobile
                                 };
        request.modelType = NSClassFromString(@"HSJSignInModel");
        request.showHud = YES;
    } responseResult:^(HSJSignInModel * responseData, NSError *erro) {
        if (!erro) {
            resultBlock(responseData,erro);
        }
    }];
    
}

/**
 登录请求
 @param resultBlock 是否成功，是否需要弹图验
 */
- (void)loginRequetWithMobile: (NSString *)mobile password: (NSString *)password
               andWithSmscode:(NSString *)smscode andWithCaptcha:(NSString *)captcha resultBlock:(void(^)(BOOL isSuccess ,BOOL isNeedCaptcha))resultBlock
{

    [self loadData:^(NYBaseRequest *request) {
        request.requestMethod = NYRequestMethodPost;
        request.requestUrl = kHXBUser_LoginURL;
        request.requestArgument = @{
                                     @"mobile" : mobile,///         是    string    用户名
                                     @"password" : password?:@"",///     是    string    密码
                                     @"smscode" : smscode?:@"",
                                     @"captcha" : captcha?:@"",///       否    string    图验(只有在登录错误超过3次才需要输入图验)
                                     };
        request.showHud = YES;
    } responseResult:^(id responseData, NSError *erro) {
        if (!erro) {
            NSString *oldMobile = KeyChain.mobile;
            BOOL needChange = oldMobile && ![mobile isEqualToString:oldMobile];
            if (needChange) {
                [KeyChain removeGesture];
                // 移除原来的值
                KeyChain.skipGesture = kHXBGesturePwdSkipeNONE;
                KeyChain.skipGestureAlertAppeared = NO;
                [HXBRootVCManager manager].gesturePwdVC = nil;
            }
            KeyChain.gesturePwdCount = 5;
            
            KeyChain.isLogin = YES;
            KeyChain.mobile = mobile;
            
            if (needChange) {
                // 设置新的值
                KeyChain.skipGesture = kHXBGesturePwdSkipeNONE;
                KeyChain.skipGestureAlertAppeared = NO;
            }
            resultBlock(YES,NO);
        } else {
            NSDictionary *response = erro.userInfo;
            BOOL isNeedCaptcha = [response[kResponseStatus]  isEqual: @102];
            resultBlock(NO,isNeedCaptcha);
        }
    }];
}

- (void)getVerifyCodeRequesWithSignInWithAction:(NSString *)action
                                    andWithType:(NSString *)type
                                  andWithMobile:(NSString *)mobile
                               andCallbackBlock: (void(^)(BOOL isSuccess,NSError *error))callbackBlock {
    kWeakSelf
    [self verifyCodeRequestWithResultBlock:^(NYBaseRequest *request) {
        request.requestArgument = @{
                                    @"action":action,
                                    @"type":type,
                                    @"mobile" : mobile
                                    };
        request.hudDelegate = weakSelf;
        request.showHud = YES;
    } resultBlock:^(id responseObject, NSError *error) {
        if (error) {
            callbackBlock(NO,error);
        }
        else {
            callbackBlock(YES,nil);
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
