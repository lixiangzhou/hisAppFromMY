//
//  HXBAccountAlterLoginPasswordViewModel.h
//  hoomxb
//
//  Created by caihongji on 2018/3/1.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HSJBaseViewModel.h"

@interface HXBAccountAlterLoginPasswordViewModel : HSJBaseViewModel


- (void)mobifyPassword_LoginRequest_requestWithOldPwd: (NSString *)oldPassword
                                            andNewPwd: (NSString *)newPassword
                                      andSuccessBlock: (void(^)())successDateBlock
                                      andFailureBlock: (void(^)(NSError *error))failureBlock;
/**
 获取短验
 @param mobile 手机号
 @param action 获取短信的事件
 @param captcha 图验(只有在登录错误超过3次才需要输入图验)
 @param callbackBlock 请求回调
 */
- (void)getVerifyCodeRequesWithMobile: (NSString *)mobile
                            andAction: (HXBSignUPAndLoginRequest_sendSmscodeType)action
                           andCaptcha: (NSString *)captcha
                              andType: (NSString *)type
                     andCallbackBlock: (void(^)(BOOL isSuccess,NSError *error))callbackBlock;
@end
