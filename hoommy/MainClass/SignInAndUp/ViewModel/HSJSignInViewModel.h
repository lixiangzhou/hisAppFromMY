//
//  HSJSignInViewModel.h
//  hoommy
//
//  Created by HXB-C on 2018/7/11.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"

@interface HSJSignInViewModel : HSJBaseViewModel


/**
 登录或注册的手机号
 */
@property (nonatomic, copy) NSString *phoneNumber;

/**
 校验手机号是否注册

 @param mobile 手机号
 @param resultBlock 返回
 */
- (void)checkExistMobile:(NSString *)mobile resultBlock:(NetWorkResponseBlock)resultBlock;

/**
 登录请求
 @param resultBlock 是否成功，是否需要弹图验
 */
- (void)loginRequetWithMobile: (NSString *)mobile password: (NSString *)password
               andWithSmscode:(NSString *)smscode andWithCaptcha:(NSString *)captcha resultBlock:(void(^)(BOOL isSuccess ,BOOL isNeedCaptcha))resultBlock;

//短验登录
- (void)getVerifyCodeRequesWithSignInWithAction:(NSString *)action
                                    andWithType:(NSString *)type
                                  andWithMobile:(NSString *)mobile
                               andCallbackBlock: (void(^)(BOOL isSuccess,NSError *error))callbackBlock;

//获取图验
- (void)captchaRequestWithResultBlock:(void(^)(UIImage *captchaimage))callbackBlock;

/// 校验图片验证码
- (void)checkCaptchaRequestWithCaptcha: (NSString *)captcha resultBlock:(void(^)(BOOL isSuccess, BOOL needDownload))resultBlock;
@end
