//
//  UIScrollView+HXBScrollView.m
//  hoomxb
//
//  Created by HXB on 2017/4/25.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

static NSString * const footerNoMoreDataStr = @"已加载全部";
static const char headRefreshBlockKey = '\0';
static const char footRefreshBlockKey = '\0';
static const char refreshOptionKey = '\0';

#import "UIScrollView+HXBScrollView.h"

@implementation UIScrollView (HXBScrollView)

#pragma mark 属性方法动态实现

- (void)setFooterWithRefreshBlock:(void (^)(UIScrollView *scrollView))footerWithRefreshBlock {
    objc_setAssociatedObject(self, &footRefreshBlockKey,
                             footerWithRefreshBlock, OBJC_ASSOCIATION_RETAIN);
}

- (void (^)(UIScrollView *scrollView))footerWithRefreshBlock {
    return objc_getAssociatedObject(self, &footRefreshBlockKey);
}


- (void)setHeaderWithRefreshBlock:(void (^)(UIScrollView *scrollView))headerWithRefreshBlock {
    objc_setAssociatedObject(self, &headRefreshBlockKey,
                             headerWithRefreshBlock, OBJC_ASSOCIATION_RETAIN);
}

- (void (^)(UIScrollView *scrollView))headerWithRefreshBlock {
    return objc_getAssociatedObject(self, &headRefreshBlockKey);
}

- (void)setFreshOption:(ScrollViewFreshOption)freshOption {
    objc_setAssociatedObject(self, &refreshOptionKey,
                             @(freshOption), OBJC_ASSOCIATION_ASSIGN);
    
    switch (freshOption) {
        case ScrollViewFreshOptionNormal:
            self.mj_header = nil;
            self.mj_footer = nil;
            break;
        case ScrollViewFreshOptionDownPull:
            [self setUpHeaderRefreshView];
            self.mj_footer = nil;
            break;
        case ScrollViewFreshOptionAll:
            [self setUpHeaderRefreshView];
            [self setUpFooterRefreshView];
            break;
            
        default:
            break;
    }
    [self resetContentInset];
}

- (ScrollViewFreshOption)freshOption {
    NSNumber* option = objc_getAssociatedObject(self, &refreshOptionKey);
    if(!option) {
        return ScrollViewFreshOptionNormal;
    }
    return option.integerValue;
}

#pragma mark 安装下拉视图

// MARK: 默认的下拉刷新
- (void)setUpHeaderRefreshView
{
    if(self.mj_header) {
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if(weakSelf.mj_footer.isRefreshing) {
            [weakSelf.mj_header endRefreshing];
            return ;
        }
        
        if(weakSelf.headerWithRefreshBlock) {
            weakSelf.headerWithRefreshBlock(weakSelf);
        }
    }];
    header.stateLabel.font = kHXBFont_PINGFANGSC_REGULAR(12);
    header.stateLabel.textColor = kHXBFontColor_333333_100;
    header.lastUpdatedTimeLabel.font = kHXBFont_PINGFANGSC_REGULAR(12);
    header.lastUpdatedTimeLabel.textColor = kHXBFontColor_333333_100;
    self.mj_header = header;
}

// MARK: 默认的上拉加载
- (void)setUpFooterRefreshView
{
    if(self.mj_footer) {
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if(weakSelf.mj_header.isRefreshing) {
            [weakSelf.mj_footer endRefreshing];
            return ;
        }
        if(weakSelf.footerWithRefreshBlock) {
            weakSelf.footerWithRefreshBlock(weakSelf);
        }
    }];
    footer.stateLabel.font = kHXBFont_PINGFANGSC_REGULAR(12);
    footer.stateLabel.textColor = kHXBFontColor_333333_100;
    [footer setTitle:footerNoMoreDataStr forState:MJRefreshStateNoMoreData];
    footer.automaticallyHidden = YES;

    self.mj_footer = footer;
}

- (void)resetContentInset {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = 0;
    inset.top = 0;
    self.contentInset = inset;
}

#pragma mark 刷新状态更新

- (void)endRefresh:(BOOL)isNoMoreData {
    [self.mj_header endRefreshing];
    
    if(isNoMoreData) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
    else{
        [self.mj_footer endRefreshing];
    }
}

/// 开始刷新
- (void)beginRefresh {
    [self.mj_header beginRefreshing];
}

/**
 更新无更多数据时，底部显示的文本
 
 @param text 更新内容
 */
- (void)setNoMoreDataText:(NSString*)text {
    MJRefreshBackNormalFooter *footer = (MJRefreshBackNormalFooter *)self.mj_footer;
    [footer setTitle:text forState:MJRefreshStateNoMoreData];
}

@end


// ---------------- readMe -----------------------
/**
 * 相关设置
 1. 状态的lable
 footer.stateLabel header.stateLabel
 2. 记录时间的label
 header.lastUpdatedTimeLabel
 3. 设置footer在没有数据的时候隐藏： （默认为NO）
 footer.automaticallyHidden = YES;
 */

