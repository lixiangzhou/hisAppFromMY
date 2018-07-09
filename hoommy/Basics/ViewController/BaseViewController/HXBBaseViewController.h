//
//  HXBBaseViewController.h
//  hoomxb
//
//  Created by HXB on 2017/4/13.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+HSContentAreaInset.h"
#import "UIViewController+HSJStandard.h"

@interface HXBBaseViewController : UIViewController
///所有的子视图都在这个视图里添加
@property (nonatomic, strong) UIView* safeAreaView;
///导航条是否为白色
@property (nonatomic,assign) BOOL isWhiteColourGradientNavigationBar;
///导航条是否为红色
@property (nonatomic,assign) BOOL isRedColourGradientNavigationBar;
///是否全屏显示, 仅能在viewDidLoad方法顶部指定
@property (nonatomic, assign) BOOL isFullScreenShow;
///是否禁用滑动返回, 仅能在viewDidLoad方法顶部指定
@property (nonatomic, assign) BOOL isDisableSliderBack;

///可以重写返回方法
- (void)leftBackBtnClick;

///可以重写返回按钮样式
- (void)setupLeftBackBtn;

/**
 子类如果需要重新加载页面，只需重写这个方法就可以
 注意：这个方法处理了滑动返回时的种种情况，要将所有的重新加载操作，放在这个方法里
 */
- (void)reLoadWhenViewAppear;

/**
 当滑动返回上一个页面时回调这个方法
 */
- (void)sliderBackAction;

@end
