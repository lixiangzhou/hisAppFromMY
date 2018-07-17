//
//  HSJSignupViewModel.h
//  hoommy
//
//  Created by HXB-C on 2018/7/13.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"

@interface HSJSignupViewModel : HSJBaseViewModel

- (void)getVerifyCodeRequesWithSignupWithAction:(NSString *)action
                                    andWithType:(NSString *)type
                                  andWithMobile:(NSString *)mobile
                               andCallbackBlock: (void(^)(BOOL isSuccess,BOOL isNeedCaptcha))callbackBlock;

- (void)signUPRequetWithMobile: (NSString *)mobile smscode: (NSString *)smscode password: (NSString *)password resultBlock:(NetWorkResponseBlock)resultBlock;

//获取图验
- (void)captchaRequestWithResultBlock:(void(^)(UIImage *captchaimage))callbackBlock;

/// 校验图片验证码
- (void)checkCaptchaRequestWithCaptcha: (NSString *)captcha resultBlock:(void(^)(BOOL isSuccess, BOOL needDownload))resultBlock;

@end
