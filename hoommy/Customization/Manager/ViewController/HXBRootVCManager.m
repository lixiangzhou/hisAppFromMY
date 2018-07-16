//
//  HXBRootVCManager.m
//  hoomxb
//
//  Created by lxz on 2017/11/14.
//Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBRootVCManager.h"
#import "HSJHomeViewController.h"
#import "HSJMyViewController.h"
#import "AXHNewFeatureController.h"
#import "HXBVersionUpdateManager.h"
#define AXHVersionKey @"version"

@interface HXBRootVCManager ()
@property (nonatomic, strong) UIWindow *window;
@end

@implementation HXBRootVCManager

+ (instancetype)manager {
    static HXBRootVCManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [HXBRootVCManager new];
    });
    return manager;
}

/// 创建根控制器
- (void)createRootVCAndMakeKeyWindow {
    
    //升级弹框
//    [[HXBVersionUpdateManager sharedInstance] checkVersionUpdate];
    NSString *currentVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:AXHVersionKey];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [UIApplication sharedApplication].delegate.window = self.window;
    //版本检测
    if ([currentVersion isEqualToString:lastVersion]) { // 没有最新的版本号
        self.window.rootViewController = self.mainTabbarVC;
    } else { // 有新版本
        AXHNewFeatureController *VC = [[AXHNewFeatureController alloc] init];
        self.window.rootViewController = VC;
        //保存当前版本，用偏好设置
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:AXHVersionKey];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

- (UIViewController *)topVC {
    return [self topControllerWithRootController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

#pragma mark - 获取最顶端控制器
- (UIViewController *)topControllerWithRootController:(UIViewController *)rootController {
    if ([rootController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVC = (UITabBarController *)rootController;
        return [self topControllerWithRootController:tabBarVC.selectedViewController];
    } else if ([rootController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationVC = (UINavigationController *)rootController;
        return [self topControllerWithRootController:navigationVC.visibleViewController];
    } else if (rootController.presentedViewController) {
        return [self topControllerWithRootController:rootController.presentedViewController];
    } else {
        return rootController;
    }
}

#pragma mark - Lazy
/// 懒加载主界面Tabbar
- (HXBBaseTabBarController *)mainTabbarVC
{
    if (!_mainTabbarVC) {
        _mainTabbarVC = [[HXBBaseTabBarController alloc]init];
        _mainTabbarVC.selectColor = [UIColor redColor];///选中的颜色
        _mainTabbarVC.normalColor = [UIColor grayColor];///平常状态的颜色

        NSArray *controllerNameArray = @[
                                         @"HSJHomeViewController",//首页
                                         @"HSJMyViewController"//我的
                                         ];
        //title 集合
        NSArray *controllerTitleArray = @[@"首页",@"我的"];
        //正常图片
        NSArray *imageArray = @[@"home_Unselected.svg",@"my_Unselected.svg"];
        //选中下的图片
        NSArray *commonName = @[@"home_Selected.svg",@"my_Selected.svg"];
        
        for (UIView *view in self.mainTabbarVC.tabBar.subviews) {
            NSLog(@"view = %@", view);
            if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1) {
                UIImageView *ima = (UIImageView *)view;
                ima.height = 0.000001;
                ima.hidden = YES;
            }
        }

        [_mainTabbarVC subViewControllerNames:controllerNameArray andNavigationControllerTitleArray:controllerTitleArray andImageNameArray:imageArray andSelectImageCommonName:commonName];
    }
    
    return _mainTabbarVC ;
}

@end
