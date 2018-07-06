//
//  UIViewController+HSJContentAreaInset.h
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/16.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HSJContentAreaInset)

@property (nonatomic, readonly) CGFloat contentViewTop;
@property (nonatomic, readonly) CGFloat contentViewBottomNoTabbar;
@property (nonatomic, readonly) CGFloat contentViewBottomWithTabbar;
@property (nonatomic, readonly) CGFloat contentViewLeft;
@property (nonatomic, readonly) CGFloat contentViewRight;
@property (nonatomic, readonly) UIEdgeInsets contentViewInsetNoTabbar;
@property (nonatomic, readonly) UIEdgeInsets contentViewInsetWithTabbar;

@end
