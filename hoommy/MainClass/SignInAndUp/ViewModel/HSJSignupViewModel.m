//
//  HSJSignupViewModel.m
//  hoommy
//
//  Created by HXB-C on 2018/7/13.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJSignupViewModel.h"

@implementation HSJSignupViewModel

- (void)getVerifyCodeRequesWithSignupWithAction:(NSString *)action
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

- (void)signUPRequetWithMobile: (NSString *)mobile smscode: (NSString *)smscode password: (NSString *)password resultBlock:(NetWorkResponseBlock)resultBlock
{
    [self loadData:^(NYBaseRequest *request) {
        request.requestMethod = NYRequestMethodPost;
        request.requestUrl = kHXBUser_SignUPURL;
        request.requestArgument = @{
                                      @"mobile"    : mobile,///           是    string    手机号
                                      @"smscode" : smscode,///          是    string    短信验证码
                                      @"password" : password,///       是    string    密码
                                      @"utmSource" : @"",///推广渠道
                                      @"marketSource" : @"ios"///市场来源
                                      };
    } responseResult:^(id responseData, NSError *erro) {
        if (resultBlock) {
            resultBlock(responseData,erro);
        }
    }];
}

@end
