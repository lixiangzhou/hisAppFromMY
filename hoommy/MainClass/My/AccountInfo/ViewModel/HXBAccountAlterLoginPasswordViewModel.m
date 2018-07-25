//
//  HXBAccountAlterLoginPasswordViewModel.m
//  hoomxb
//
//  Created by caihongji on 2018/3/1.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HXBAccountAlterLoginPasswordViewModel.h"
#import "HXBOpenDepositAccountAgent.h"

@implementation HXBAccountAlterLoginPasswordViewModel

- (void)mobifyPassword_LoginRequest_requestWithOldPwd: (NSString *)oldPassword
                                            andNewPwd: (NSString *)newPassword
                                      andSuccessBlock: (void(^)())successDateBlock
                                      andFailureBlock: (void(^)(NSError *error))failureBlock
{
    ///请求信息配置
    NYBaseRequest *mobifyPassword_LoginRequest = [[NYBaseRequest alloc] initWithDelegate:self];
    mobifyPassword_LoginRequest.requestUrl = kHXBSetUPAccount_MobifyPassword_LoginRequestURL;
    mobifyPassword_LoginRequest.requestMethod = NYRequestMethodPost;
    mobifyPassword_LoginRequest.requestArgument = @{
                                                    @"oldpwd" : oldPassword,//旧的按钮
                                                    @"newpwd" : newPassword
                                                    };
    mobifyPassword_LoginRequest.showHud = YES;
    [mobifyPassword_LoginRequest loadData:^(NYBaseRequest *request, id responseObject) {
        if (successDateBlock) successDateBlock();
    } failure:^(NYBaseRequest *request, NSError *error) {
        if (failureBlock) failureBlock(error);
    }];
    
    
    
    
}

- (void)getVerifyCodeRequesWithMobile: (NSString *)mobile
                            andAction: (HXBSignUPAndLoginRequest_sendSmscodeType)action
                           andCaptcha: (NSString *)captcha
                              andType: (NSString *)type
                     andCallbackBlock: (void(^)(BOOL isSuccess,NSError *error))callbackBlock {
    
    kWeakSelf
    [HXBOpenDepositAccountAgent verifyCodeRequestWithResultBlock:^(NYBaseRequest *request) {
        NSString *actionStr = [HXBSignUPAndLoginRequest_EnumManager getKeyWithHXBSignUPAndLoginRequest_sendSmscodeType:action];
        request.requestArgument = @{
                                    @"mobile":mobile ?: @"",///     是    string    用户名
                                    @"action":actionStr ?: @"",///     是    string    signup(参照通用短信发送类型)
                                    @"captcha":captcha ?: @"",///    是    string    校验图片二维码
                                    @"type":type ?: @""
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

@end
