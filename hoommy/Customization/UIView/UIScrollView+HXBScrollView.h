//
//  UIScrollView+HXBScrollView.h
//  hoomxb
//
//  Created by HXB on 2017/4/25.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ScrollViewFreshOptionNormal,
    ScrollViewFreshOptionDownPull,
    ScrollViewFreshOptionAll,
} ScrollViewFreshOption;

@interface UIScrollView (HXBScrollView)

///指定值， 选择安装对应的下拉视图
@property (nonatomic, assign) ScrollViewFreshOption freshOption;

///下拉刷新
@property (nonatomic, strong) void (^headerWithRefreshBlock)(UIScrollView *scrollView);

///上拉加载
@property (nonatomic, strong) void (^footerWithRefreshBlock)(UIScrollView *scrollView);

/**
 结束刷新

 @param isNoMoreData YES， 底部显示无更多数据的文本； NO， 底部隐藏
 */
- (void)endRefresh:(BOOL)isNoMoreData;

/// 开始刷新
- (void)beginRefresh;

/**
 更新无更多数据时，底部显示的文本

 @param text 更新内容
 */
- (void)setNoMoreDataText:(NSString*)text;

@end
