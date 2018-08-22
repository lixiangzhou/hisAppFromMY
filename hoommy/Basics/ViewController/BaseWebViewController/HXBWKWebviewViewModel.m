//
//  HXBWKWebviewViewModuel.m
//  hoomxb
//
//  Created by caihongji on 2017/11/23.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBWKWebviewViewModel.h"

@interface HXBWKWebviewViewModuel ()

@end

@implementation HXBWKWebviewViewModuel

#pragma mark 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (self.loadStateBlock) {
        self.loadStateBlock(HXBPageLoadStateStart);
    }
}

#pragma mark 页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (self.loadStateBlock) {
        self.loadStateBlock(HXBPageLoadStateEnd);
    }
}

#pragma mark 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (self.loadStateBlock) {
        self.loadStateBlock(HXBPageLoadStateFaile);
    }
}

// 处理拨打电话以及Url跳转等等
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
}
@end
