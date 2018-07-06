//
//  UIViewController+HSJContentAreaInset.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/16.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "UIViewController+HSContentAreaInset.h"

@implementation UIViewController (HSJContentAreaInset)

- (CGFloat)contentViewTop {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if(375==screenSize.width && 812==screenSize.height) {//iphoneX
        return 88;
    }
    return 64;
}

- (CGFloat)contentViewLeft {
    return 0;
}

- (CGFloat)contentViewRight {
    return 0;
}

- (CGFloat)contentViewBottomNoTabbar {
    CGFloat bottom = 0;
    CGFloat safeAreaBottom = 34;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if(375==screenSize.width && 812==screenSize.height) {//iphoneX
        bottom = safeAreaBottom;
    }

    return bottom;
}

- (CGFloat)contentViewBottomWithTabbar {    
    return self.tabBarController.tabBar.frame.size.height;
}

- (UIEdgeInsets)contentViewInsetNoTabbar {
    return UIEdgeInsetsMake(self.contentViewTop, self.contentViewLeft, self.contentViewBottomNoTabbar, self.contentViewRight);
}

- (UIEdgeInsets)contentViewInsetWithTabbar {
    return UIEdgeInsetsMake(self.contentViewTop, self.contentViewLeft, self.contentViewBottomWithTabbar, self.contentViewRight);
}
@end
