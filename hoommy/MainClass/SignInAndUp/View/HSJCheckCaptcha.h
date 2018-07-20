//
//  HSJCheckCaptcha.h
//  hoomxb
//
//  Created by HXB on 2017/6/2.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>
///图形验证码的view
@interface HSJCheckCaptcha : UIView
@property (nonatomic, strong) UIImage *checkCaptchaImage;
///验证码是否正确
@property (nonatomic, assign) BOOL isCorrect;
///成为第一响应者
@property (nonatomic, assign) BOOL isFirstResponder;

/**
 点击了取消
 */
@property (nonatomic, copy) void(^cancelBlock)(void);

///点击了确认按钮
- (void)clickTrueButtonFunc:(void (^)(NSString *checkCaptChaStr))clickTrueButtonBlock;
///点击了图形验证码
- (void)clickCheckCaptchaImageViewFunc: (void(^)(void))clickCheckCaptchaImageViewBlock;
@end
