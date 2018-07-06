//
//  HXBBaseTabBarController.h
//  hoomxb
//
//  Created by HXB on 2017/4/18.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXBBaseNavigationController.h"

@interface HXBBaseTabBarController : UITabBarController

///选中的字体颜色 （默认蓝色）
@property (nonatomic,strong) UIColor *selectColor;
///默认的字体颜色 （默认红色）
@property (nonatomic,strong) UIColor *normalColor;
///字体
@property (nonatomic,strong) UIFont *font;
/**
 * 根据subVC名创建subVC并加入到self.childViewControllers里面
 * @param subViewControllerNameArray subViewController的名字
 * @param titleArray subViewController的NAV与tabbar的title
 * @param imageNameArray 默认情况下的image的名字
 * @param selectImageCommonNameArray 选中情况下的image的名字的前缀
 */
- (void)subViewControllerNames: (NSArray <NSString *> *)subViewControllerNameArray andNavigationControllerTitleArray: (NSArray<NSString *>*)titleArray andImageNameArray: (NSArray<NSString *>*)imageNameArray andSelectImageCommonName: (NSArray<NSString *>*)selectImageCommonNameArray;

@end
