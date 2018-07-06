//
//  HXBBaseViewController+HSJAPI.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/17.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HXBBaseViewController+HSAPI.h"
#import "UIScrollView+HXBScrollView.h"

@implementation HXBBaseViewController (HSJAPI)

/**
 加载无网络视图
 
 @return 是否显示了无网络视图
 */
- (BOOL)loadNoNetworkView {
    return NO;
}

#pragma mark 如果控制器中有滚动视图需要下拉操作， 则使用以下方法

/**
 安装刷新回调
 
 @param scrollView 安装对象
 */
- (void)setUpScrollFreshBlock:(UIScrollView *)scrollView {
    
    kWeakSelf
    scrollView.headerWithRefreshBlock = ^(UIScrollView *scrollView) {
        [weakSelf headerRefreshAction:scrollView];
    } ;
    
    scrollView.footerWithRefreshBlock = ^(UIScrollView *scrollView) {
        [weakSelf footerRefreshAction:scrollView];
    };
}

/**
 下拉刷新回调, 子类需要重写
 
 @param scrollView 发生下拉的视图
 */
- (void)headerRefreshAction:(UIScrollView *)scrollView {
    
}

/**
 上拉加载回调, 子类需要重写
 
 @param scrollView 发生上拉的视图
 */
- (void)footerRefreshAction:(UIScrollView *)scrollView {
    
}
@end
