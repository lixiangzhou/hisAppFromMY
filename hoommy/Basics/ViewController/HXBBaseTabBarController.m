//
//  HXBBaseTabBarController.m
//  hoomxb
//
//  Created by HXB on 2017/4/18.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBaseTabBarController.h"
#import "HXBBaseNavigationController.h"
#import "SVGKit/SVGKImage.h"
#import "HSJMyViewController.h"
#import "HSJSignInViewController.h"
#import "HSJHomeViewController.h"
@interface HXBBaseTabBarController ()<UITabBarControllerDelegate>

@end

@implementation HXBBaseTabBarController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.backgroundColor = kHXBColor_FFFFFF_100;
    ///注册通知
    [self registerNotification];

    self.delegate = self;
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UINavigationController *navController = self.selectedViewController;
    if(navController.viewControllers.count > 1){
        self.tabBar.hidden = YES;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI
// 去除tabBar上面的横线
- (void)hiddenTabbarLine {
    UIImageView *shadowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3)];
    shadowImage.backgroundColor = [UIColor colorWithWhite:0.952 alpha:0.8];
    [self createViewShadDow:shadowImage];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [self.tabBar addSubview:shadowImage];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
}

//创建阴影
- (void)createViewShadDow:(UIImageView*)imageView {
    //阴影的颜色
    imageView.layer.shadowColor = [UIColor colorWithWhite:0.7 alpha:10.f].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(-2, -2);
    //阴影透明度
    imageView.layer.shadowOpacity = 0.8f;
    imageView.layer.shadowRadius = 3.0f;
    
}

#pragma mark - Observer
///注册通知
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentLoginVC:) name:kHXBNotification_ShowLoginVC object:nil];

}


- (void)presentLoginVC:(NSNotification *)notification {
    HSJSignInViewController *signInVC = [[HSJSignInViewController alloc] init];
    HXBBaseNavigationController *nav = [[HXBBaseNavigationController alloc] initWithRootViewController:signInVC];
    signInVC.selectedIndexVC = notification.object[@"selectedIndex"];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 封装的方法
/* 根据subVC名创建subVC并加入到self.childViewControllers里面 */
- (void)subViewControllerNames: (NSArray <NSString *> *)subViewControllerNameArray andNavigationControllerTitleArray: (NSArray<NSString *>*)titleArray andImageNameArray: (NSArray<NSString *>*)imageNameArray andSelectImageCommonName: (NSArray<NSString *>*)selectImageCommonNameArray{
    
    for (int i = 0; i < subViewControllerNameArray.count; i ++) {
        UIViewController *VC = [self ctratSubControllerWithName:subViewControllerNameArray[i]];
        UIEdgeInsets insets = UIEdgeInsetsMake(8, 0, -8, 0);
        self.tabBar.items[i].imageInsets = insets;
        //设置字体
        VC.title = titleArray[i];
        HXBBaseNavigationController *NAV = [self creatNavigationControllerBySubViewController:VC];
        if (self.font) {
            [NAV.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : self.font} forState: UIControlStateNormal];
        }
        
        //字体的颜色
        [NAV.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : self.normalColor} forState:UIControlStateNormal];
        [NAV.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : self.selectColor} forState:UIControlStateSelected];
        
        // 设置image 及渲染模式
        SVGKImage *svgImage = [SVGKImage imageNamed:imageNameArray[i]];
        UIImage *image = [svgImage.UIImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        NAV.tabBarItem.image = image;

        svgImage = [SVGKImage imageNamed:selectImageCommonNameArray[i]];
        UIImage *selectImage = svgImage.UIImage;
        selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        NAV.tabBarItem.selectedImage = selectImage;
        
        [self addChildViewController:NAV];
        if (i == 2) {
            [NAV.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:(UIBarMetricsDefault)];
            NAV.navigationItem.leftBarButtonItem = nil;
            [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
            
        }
    }
}

//MARK: 创建导航控制器
- (HXBBaseNavigationController *)creatNavigationControllerBySubViewController: (UIViewController *)VC {
    HXBBaseNavigationController *NAV = [[HXBBaseNavigationController alloc]initWithRootViewController:VC];
    return NAV;
}

//MARK: 根据文件名创建subVC
- (UIViewController *)ctratSubControllerWithName: (NSString *)subViewControllerName {
    Class class = NSClassFromString(subViewControllerName);
    UIViewController *controller = [[class alloc]init];
    return controller;
}

#pragma mark - tabBarDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    HXBBaseNavigationController *vc = (HXBBaseNavigationController *)viewController ;
    if ([vc.topViewController isMemberOfClass:[HSJHomeViewController class]]) {
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSJUmeng_HomeTabClick];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //获取当前的导航控制器的跟控制器
//    HXBBaseNavigationController *vc = ((HXBBaseNavigationController *)viewController).viewControllers.firstObject;
    HXBBaseNavigationController *vc = (HXBBaseNavigationController *)viewController ;
    
    if ([vc.topViewController isMemberOfClass:[HSJMyViewController class]]) {
        if (!KeyChain.isLogin)  {
            [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_ShowLoginVC object:@{@"selectedIndex" : [NSString stringWithFormat:@"%lu",(unsigned long)tabBarController.selectedIndex]}];
            return YES;
        }
    }
    
    return YES;
}

#pragma mark - gtter方法
- (UIColor *)normalColor {
    if (!_normalColor) {
        _normalColor = [UIColor redColor];
    }
    return _normalColor;
}
- (UIColor *)selectColor {
    if (!_selectColor) {
        _selectColor = [UIColor blueColor];
    }
    return _selectColor;
}

@end

