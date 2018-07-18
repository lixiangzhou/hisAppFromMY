//
//  HSJHomeCustomNavbarView.h
//  hoommy
//
//  Created by HXB-C on 2018/7/17.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSJHomeCustomNavbarView : UIView
/**
 标题
 */
@property (nonatomic, copy) NSString *title;
/**
 透明度
 */
@property (nonatomic, assign) CGFloat navAlpha;

/**
 背景色
 */
@property (nonatomic, strong) UIColor *navBackgroundColor;

/**
 标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 标题文字大小
 */
@property (nonatomic, strong) UIFont *titleFount;

/**
 公告的回调
 */
@property (nonatomic, copy) void (^noticeBlock)(void);
@end
