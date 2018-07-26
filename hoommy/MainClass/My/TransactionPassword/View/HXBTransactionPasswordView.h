//
//  HXBTransactionPasswordView.h
//  测试
//
//  Created by HXB-C on 2017/12/19.
//Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXBTransactionPasswordView : UIView

/**
 输入密码回调
 */
@property (nonatomic, copy) void (^getTransactionPasswordBlock)(NSString *password);
//展示
- (void)showInView:(UIView *)view;
//关闭
- (void)closePasswordView;
//清空密码
- (void)clearUpPassword;
@end
