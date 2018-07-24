//
//  HSJDepositoryOpenTipView.h
//  hoommy
//
//  Created by lxz on 2018/7/24.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSJDepositoryOpenTipView : UIView
/// 显示提示，并可进入存管开通页面，如果没有特殊的需要，使用此方法
+ (void)show;
/// 显示提示，自定义进入存管的block
+ (void)showWithOpenBlock:(void (^)(void))openBlock;
@end
