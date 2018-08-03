//
//  HXBBaseWKWebViewController.h
//  hoomxb
//
//  Created by caihongji on 2017/11/21.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBaseViewController.h"
#import "WKWebViewJavascriptBridge.h"

#define HXB_POST_JS @"function my_post(path, params) {\
var method = \"POST\";\
var form = document.createElement(\"form\");\
form.setAttribute(\"method\", method);\
form.setAttribute(\"action\", path);\
form.setAttribute(\"accept-charset\", \"UTF-8\");\
for(var key in params){\
if (params.hasOwnProperty(key)) {\
var hiddenFild = document.createElement(\"input\");\
hiddenFild.setAttribute(\"type\", \"hidden\");\
hiddenFild.setAttribute(\"name\", key);\
hiddenFild.setAttribute(\"value\", params[key]);\
}\
form.appendChild(hiddenFild);\
}\
document.body.appendChild(form);\
form.submit();\
}"

@interface HXBBaseWKWebViewController : HXBBaseViewController
/**
 用于加载一个新的URLRequest。
 */
@property (nonatomic, strong,readonly) WKWebView *webView;

@property (nonatomic, copy) NSString* pageUrl;
/**
 页面title， 可以不传
 */
@property (nonatomic, copy) NSString* pageTitle;

//分享视图的title
@property (nonatomic, copy) NSString *shareViewTitle;

//重新获取焦点时，是否需要重新加载, 默认值是YES
@property (nonatomic, assign) BOOL pageReload;

//是否需要显示关闭按钮
@property (nonatomic, assign) BOOL isShowCloseButton;
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
 加载第三方H5页面需要重写此方法
 */
- (void)loadWebPage;
/**
 push 一个显示网页的控制器

 @param pageUrl 网页的URL
 @param controller 从该控制器push
 @return 返回当前控制器
 */
+ (instancetype)pushWithPageUrl:(NSString *)pageUrl fromController:(HXBBaseViewController *)controller;

@end
