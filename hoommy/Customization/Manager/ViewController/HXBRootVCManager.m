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
#import "HXBAdvertiseManager.h"
#import "HxbAdvertiseViewController.h"
#import "HSJGlobalInfoManager.h"
#import "HXBHomePopViewManager.h"

#define AXHVersionKey @"version"

@interface HXBRootVCManager ()
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) HxbAdvertiseViewController *advertiseVC;
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
    [[UITextField appearance] setTintColor:[UIColor blackColor]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [HXBUmengManagar HXB_umengStart];
    [[HXBHomePopViewManager sharedInstance] getHomePopViewData];//获取首页弹窗数据
    [[HXBAdvertiseManager shared] getSplash];
    [[HSJGlobalInfoManager shared] getData];
    
    //升级弹框
    [[HXBVersionUpdateManager sharedInstance] checkVersionUpdate];
    NSString *currentVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:AXHVersionKey];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [UIApplication sharedApplication].delegate.window = self.window;
    //版本检测
    if ([currentVersion isEqualToString:lastVersion]) { // 没有最新的版本号
        [self makeTabbarRootVC];
        [self showSlash];
    } else { // 有新版本
        AXHNewFeatureController *VC = [[AXHNewFeatureController alloc] init];
        self.window.rootViewController = VC;
        //保存当前版本，用偏好设置
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:AXHVersionKey];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

- (UIViewController *)getTabBarOrGesPwdVC {
    UIViewController *VC = nil;
    if (KeyChain.isLogin) {
        NSLog(@"%@ %@ %d", KeyChain.gesturePwd, KeyChain.skipGesture, KeyChain.skipGestureAlertAppeared);
        if (KeyChain.gesturePwd.length > 0 && [KeyChain.skipGesture isEqualToString:kHXBGesturePwdSkipeNO]) {   // 已有手势密码，手势登录
            HSJGestureLoginController *gestureVC = [[HSJGestureLoginController alloc] init];
            gestureVC.type = HSJGestureTypeLogin;
            VC = gestureVC;
        } else {
            NSString *skip = KeyChain.skipGesture;
            BOOL skipGesturePwd = NO;
            if (![skip isEqual:kHXBGesturePwdSkipeNONE]) {
                skipGesturePwd = [skip isEqualToString:kHXBGesturePwdSkipeYES];
            }
            
            BOOL appeared = KeyChain.skipGestureAlertAppeared;
            
            if (skipGesturePwd && appeared) {
                VC = self.mainTabbarVC;
            } else {
                HSJGestureLoginController *gestureVC = [[HSJGestureLoginController alloc] init];
                gestureVC.type = HSJGestureTypeSetting;
                gestureVC.showSkip = YES;
                VC = gestureVC;
            }
        }
    } else {
        VC = self.mainTabbarVC;
    }
    return VC;
}

- (void)makeTabbarRootVC {
    [HXBAdvertiseManager shared].couldPopAtHomeAfterSlashOrGesturePwd = NO;
    self.window.rootViewController = self.mainTabbarVC;
}

- (void)showGesturePwd {
    if (self.gesturePwdVC) {
        [self.mainTabbarVC.view addSubview:self.gesturePwdVC.view];
//        [self.gesturePwdVC checkAlertSkipSetting];
    }
}

- (void)showSlash {
    [self.mainTabbarVC.view addSubview:self.advertiseVC.view];
    [self.advertiseVC addTimer];
}

- (void)popWindowsAtHomeAfterSlashOrGesturePwd {
    [HXBAdvertiseManager shared].couldPopAtHomeAfterSlashOrGesturePwd = YES;
    UIViewController *VC = self.mainTabbarVC.childViewControllers.firstObject.childViewControllers.firstObject;
    [[HXBHomePopViewManager sharedInstance] popHomeViewfromController:VC];//展示首页弹窗
    [[HXBVersionUpdateManager sharedInstance] show];
}

/// 获取最顶端控制器
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

- (void)enterTheGesturePasswordVCOrTabBar
{
    if ([self.mainTabbarVC isKindOfClass:[HXBBaseTabBarController class]] == NO) {
        return;
    }
    if (KeyChain.isLogin) {
        NSLog(@"%@ %@ %d", KeyChain.gesturePwd, KeyChain.skipGesture, KeyChain.skipGestureAlertAppeared);
        if (KeyChain.gesturePwd.length > 0 && [KeyChain.skipGesture isEqualToString:kHXBGesturePwdSkipeNO]) {   // 已有手势密码，手势登录
            [self.window.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            HSJGestureLoginController *gesturePasswordVC = [[HSJGestureLoginController alloc] init];
            gesturePasswordVC.type = HSJGestureTypeLogin;
            [self.gesturePwdVC.view removeFromSuperview];
            id block = self.gesturePwdVC.dismissBlock;
            self.gesturePwdVC = gesturePasswordVC;
            
            if ([HXBAdvertiseManager shared].couldPopAtHomeAfterSlashOrGesturePwd == NO) {
                self.gesturePwdVC.dismissBlock = block;
            } else {
                kWeakSelf
                self.gesturePwdVC.dismissBlock = ^(BOOL delay, BOOL toActivity, BOOL popRightNow) {
                    [weakSelf.gesturePwdVC.view removeFromSuperview];
                };
            }
        } else {
            BOOL skipGesturePwd = [KeyChain.skipGesture isEqualToString:kHXBGesturePwdSkipeYES];
            BOOL appeared = KeyChain.skipGestureAlertAppeared;
            
            if (skipGesturePwd && appeared) {
                return;
            } else {
                [self.window.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                HSJGestureLoginController *gesturePasswordVC = [[HSJGestureLoginController alloc] init];
                gesturePasswordVC.type = HSJGestureTypeSetting;
                gesturePasswordVC.showSkip = YES;
                [self.gesturePwdVC.view removeFromSuperview];
                id block = self.gesturePwdVC.dismissBlock;
                self.gesturePwdVC = gesturePasswordVC;
                
                if ([HXBAdvertiseManager shared].couldPopAtHomeAfterSlashOrGesturePwd == NO) {
                    self.gesturePwdVC.dismissBlock = block;
                } else {
                    if (block == nil) {
                        kWeakSelf
                        self.gesturePwdVC.dismissBlock = ^(BOOL delay, BOOL toActivity, BOOL popRightNow) {
                            [weakSelf.gesturePwdVC.view removeFromSuperview];
                        };
                    }
                }
            }
        }
        
        [self showGesturePwd];
    }
}

#pragma mark - Getter
- (UIViewController *)topVC {
    return [self topControllerWithRootController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (HXBBaseNavigationController *)curNavigationVC {
    return (HXBBaseNavigationController *)self.topVC.navigationController;
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
        NSArray *controllerTitleArray = @[@"",@""];
        //正常图片
        NSArray *imageArray = @[@"tabbar_home",@"tabbar_mine"];
        //选中下的图片
        NSArray *commonName = @[@"tabbar_home_sel",@"tabbar_mine_sel"];
        
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

- (HxbAdvertiseViewController *)advertiseVC {
    if (_advertiseVC == nil) {
        _advertiseVC = [HxbAdvertiseViewController new];
        kWeakSelf
        // 3 秒后自动消失
        _advertiseVC.dismissBlock = ^{
            [weakSelf.advertiseVC.view removeFromSuperview];
            if (weakSelf.gesturePwdVC) {    // 需要显示手势密码
                [weakSelf showGesturePwd];
                // 需要在手势密码页消失的时候 手动调用弹窗
                weakSelf.gesturePwdVC.dismissBlock = ^(BOOL delay, BOOL toActivity, BOOL popRightNow) {
                    [[HXBRootVCManager manager].gesturePwdVC.view removeFromSuperview];
                    if (popRightNow) {
                        [[HXBRootVCManager manager] popWindowsAtHomeAfterSlashOrGesturePwd];
                    } else {
                        [HXBAdvertiseManager shared].couldPopAtHomeAfterSlashOrGesturePwd = YES;
                    }
                };
            } else {
                // 自动到首页的时候 手动调用弹窗
                [[HXBRootVCManager manager] popWindowsAtHomeAfterSlashOrGesturePwd];
            }
        };
    }
    return _advertiseVC;
}

- (HSJGestureLoginController *)gesturePwdVC {
    if (_gesturePwdVC == nil) {
        UIViewController *vc = [self getTabBarOrGesPwdVC];
        if ([vc isKindOfClass:[HSJGestureLoginController class]]) {
            self.gesturePwdVC = (HSJGestureLoginController *)vc;
        }
    }
    return _gesturePwdVC;
}
@end
