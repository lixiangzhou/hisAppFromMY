//
//  HXBBaseWKWebViewController.h
//  hoomxb
//
//  Created by caihongji on 2017/11/21.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBaseViewController.h"
#import "WKWebViewJavascriptBridge.h"

@interface HXBBaseWKWebViewController : HXBBaseViewController

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, copy) NSString* pageUrl;
/**
 页面title， 可以不传
 */
@property (nonatomic, copy) NSString* pageTitle;

//重新获取焦点时，是否需要重新加载, 默认值是YES
@property (nonatomic, assign) BOOL pageReload;


/**
 加载页面
 */
- (void)loadWebPage;

/**
 注册js回调
 
 @param handlerName js 名称
 @param handler 回到方法
 */
- (void)registJavascriptBridge:(NSString *)handlerName handler:(WVJBHandler)handler;
/**
 调用js

 @param handlerName js 名称
 @param data 数据
 */
- (void)callHandler:(NSString *)handlerName data:(id)data;

/**
 重新加载页面
 */
- (void)reloadPage;

/**
 push 一个显示网页的控制器

 @param pageUrl 网页的URL
 @param controller 从该控制器push
 @return 返回当前控制器
 */
+ (instancetype)pushWithPageUrl:(NSString *)pageUrl fromController:(HXBBaseViewController *)controller;

@end
