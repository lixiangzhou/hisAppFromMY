//
//  AppDelegate.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/10.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "AppDelegate.h"
#import "NYNetworkConfig.h"
#import "IQKeyboardManager.h"
#import "HXBVersionUpdateManager.h"
#import "HXBRootVCManager.h"
#import "HXBBaseUrlSettingView.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()
@property (nonatomic, strong) NSDate *exitTime;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //fabrci crash 统计
    [Fabric with:@[[Crashlytics class]]];
    //设置键盘
    [self setKeyboardManager];
    
    if (HXBShakeChangeBaseUrl == YES) {
        [HXBBaseUrlSettingView attatchToWindow];
        [[HXBBaseUrlManager manager] startObserve];
    }
    
    [[HXBRootVCManager manager] createRootVCAndMakeKeyWindow];
    [HXBBaseUrlSettingView attatchToWindow];
    
    return YES;
}


- (void)setKeyboardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    self.exitTime = [NSDate date];
    NSLog(@"%@",application);
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    NSDate *nowTime = [NSDate date];
    NSTimeInterval timeDifference = [nowTime timeIntervalSinceDate: self.exitTime];
    if (timeDifference > 300 && ![HXBVersionUpdateManager sharedInstance].isMandatoryUpdate) {
        [[HXBRootVCManager manager] enterTheGesturePasswordVCOrTabBar];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_starCountDown object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
