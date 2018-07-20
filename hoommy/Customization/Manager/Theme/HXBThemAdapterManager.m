//
//  HXBThemAdapterManager.m
//  hoomxb
//
//  Created by caihongji on 2017/12/14.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBThemAdapterManager.h"
#import <sys/utsname.h>

@implementation HXBThemAdapterManager


/**
 获取以屏幕高适配的比例

 @return 比例值
 */
+ (CGFloat)getAdaterScreenHeightScale
{
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //以iphone6为基准
    CGFloat scale = screenSize.height/667;
    
    if(375==screenSize.width && 812==screenSize.height) {//iphoneX
        scale = 1;
    }
    
    return scale;
}

/**
 获取以屏幕宽适配的比例
 
 @return 比例值
 */
+ (CGFloat)getAdaterScreenWidthScale
{
    
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //以iphone6为基准
    CGFloat baseWidth = 375.0;
    
    return screenSize.width/baseWidth;
    
//    CGFloat scale = 1;
//    if(baseWidth != screenSize.width) {
//        if(screenSize.width > baseWidth) {
//            scale = (screenSize.width+100)/baseWidth;
//        }
//        else {
//            scale = (screenSize.width)/baseWidth;
//        }
//    }
//
//    return scale;
}

/**
 获取状态栏高度
 
 @return 适配后的高度
 */
+ (CGFloat)getStateBarHeight
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if(375==screenSize.width && 812==screenSize.height) {//iphoneX
        return 44;
    }
    return 20;
}

/**
 获取导航栏和状态栏的总高度
 
 @return 适配后的导航栏和状态栏的总高度
 */
+ (CGFloat)getStateNavgationBarHeight
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if(375==screenSize.width && 812==screenSize.height) {//iphoneX
        return 88;
    }
    return 64;
}
@end
