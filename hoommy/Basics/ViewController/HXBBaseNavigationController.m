//
//  HXBBaseNavigationController.m
//  hoomxb
//
//  Created by HXB on 2017/4/18.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBaseNavigationController.h"

@interface HXBBaseNavigationController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *splitLineImv;

@property (nonatomic, strong) UIPanGestureRecognizer *fullScreenGesture;
@end

@implementation HXBBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBarItem setTitlePositionAdjustment:UIOffsetMake(-3, -3)];
    
    id target = self.interactivePopGestureRecognizer.delegate;
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    self.fullScreenGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:handler];
    self.fullScreenGesture.delegate = self;
    [targetView addGestureRecognizer:self.fullScreenGesture];
    self.enableFullScreenGesture = YES;
    // 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

- (void)setIsShowSplitLine:(BOOL)isShowSplitLine {
    _isShowSplitLine = isShowSplitLine;
    
    if(isShowSplitLine) {
        [self.navigationBar addSubview:self.splitLineImv];
    }
    else {
        [self.splitLineImv removeFromSuperview];
    }
}

- (UIImageView *)splitLineImv {
    if(!_splitLineImv) {
        _splitLineImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navigationBar.height-0.5, kScreenWidth, 0.5)];
        _splitLineImv.backgroundColor = kHXBColor_EEEEF5_100;
    }
    
    return _splitLineImv;
}

#pragma mark - override push
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >= 1)
    {
        //第一次push的时候， 强制手滑返回可用
        if(1 == self.viewControllers.count) {
            self.enableFullScreenGesture = YES;
        }
        viewController.hidesBottomBarWhenPushed = YES;
        self.navigationBar.hidden = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    ///这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）3、向左滑
    BOOL panLeft = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view].x > 0;
    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue] && panLeft;
}

#pragma mark - Setter
- (void)setEnableFullScreenGesture:(BOOL)enableFullScreenGesture {
    _enableFullScreenGesture = enableFullScreenGesture;
    if (self.fullScreenGesture) {
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.fullScreenGesture];
    }
    self.fullScreenGesture.enabled = enableFullScreenGesture;
}

#pragma mark - setter pop的自定义
- (void)popViewControllerWithToViewController: (NSString *)toViewControllerStr andAnimated: (BOOL)animated{
    for (UIViewController *toVC in self.childViewControllers) {
        if ([NSStringFromClass(toVC.class) isEqualToString:toViewControllerStr]) {
            [self popToViewController:toVC animated:animated];
        }
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [super popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    return [super popToRootViewControllerAnimated:animated];
}


@end
