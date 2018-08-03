//
//  HXBBaseWKWebViewController.m
//  hoomxb
//
//  Created by caihongji on 2017/11/21.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBaseWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "HXBWKWebviewViewModel.h"
#import "HXBWKWebViewProgressView.h"
#import "SVGKit/SVGKImage.h"
#import "HXBUMengShareManager.h"
#import "HXBUMShareViewModel.h"
#import "HXBUMShareModel.h"

@interface HXBBaseWKWebViewController ()<WKNavigationDelegate> {
    //进度视图的高度
    NSInteger _progressViewHeight;
    //判断是否时首次加载页面
    BOOL _firstLoadPage;
    CGFloat _buttonMaxWidth;
    CGFloat _buttonHeight;
}

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) HXBWKWebViewProgressView* progressView;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *buttonTilteLb;

//分享数据
@property (nonatomic, strong) HXBUMShareViewModel *shareViewModel;

//js 代理
@property (nonatomic, strong) WKWebViewJavascriptBridge *jsBridge;

//webview viewModuel
@property (nonatomic, strong) HXBWKWebviewViewModuel *webViewModuel;

@property (nonatomic, assign) BOOL loadResult;

//显示关闭按钮控制
@property (nonatomic, assign) BOOL showCloseButton;

@end

@implementation HXBBaseWKWebViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageReload = YES;
        _firstLoadPage = YES;
        _showCloseButton = NO;
        _isShowCloseButton = YES;
        _buttonMaxWidth = 95;
        _buttonHeight = 35;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //计算最大高度
    if(!self.isShowLeftButtonTitle) {
        self.title = self.pageTitle;
        _buttonMaxWidth = 50;
    }
    else{
        self.title = nil;
        _buttonMaxWidth = [self.pageTitle caleFontWidhSize:self.buttonTilteLb.font forViewHeight:_buttonHeight]+25;
    }
    
    //
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self setupRightBtn];
    [self setupConstraints];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:(NSKeyValueObservingOptionNew) context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [self loadWebPage];
    
    self.isShowSplitLine = YES;
    
    kWeakSelf
    [self registJavascriptBridge:@"shareData" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf shareDataJsCall:data];
    }];
    [self registJavascriptBridge:@"showShare" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf showShareJsCall:data];
    }];
}

- (void)shareDataJsCall:(NSDictionary*)urlParamDic {
    if(urlParamDic && [urlParamDic isKindOfClass:[NSDictionary class]]) {
        HXBUMShareModel *shareModel = [[HXBUMShareModel alloc] initWithDictionary:urlParamDic];
        self.shareViewModel = [[HXBUMShareViewModel alloc] init];
        self.shareViewModel.shareModel = shareModel;
        self.shareViewModel.shareViewTitle = self.shareViewTitle;
        self.rightBtn.hidden = NO;
    }
    else {
        self.rightBtn.hidden = YES;
    }
}

- (void)showShareJsCall:(NSDictionary*)urlParamDic {
    [self rightBtnClick];
}

- (void)setupRightBtn {
    //右侧按钮
    self.rightBtn = [[UIButton alloc] init];
    self.rightBtn.backgroundColor = [UIColor greenColor];
    self.rightBtn.hidden = YES;
    [self.rightBtn sizeToFit];
    [self.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.rightBtn]];
}

- (void)rightBtnClick {
    if(self.shareViewModel) {
        [HXBUMengShareManager showShareMenuViewInWindowWith:self.shareViewModel];
    }
}

- (void)setupLeftBackBtn {
    if(self.navigationController.viewControllers.count <= 1) {
        return;
    }
    UIButton *leftBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _buttonMaxWidth, _buttonHeight)];
    self.leftBackBtn = leftBackBtn;
    [leftBackBtn addTarget:self action:@selector(leftBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    if(self.isFullScreenShow) {
        [leftBackBtn setImage:nil forState:UIControlStateNormal];
        [leftBackBtn setImage:nil forState:UIControlStateHighlighted];
    }
    else {
        [leftBackBtn setImage:[UIImage imageNamed:@"back_hei"] forState:UIControlStateNormal];
        [leftBackBtn setImage:[UIImage imageNamed:@"back_hei"] forState:UIControlStateHighlighted];
    }
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _buttonMaxWidth, _buttonHeight)];
    [closeBtn setImage:[UIImage imageNamed:@"webView_close"] forState:(UIControlStateNormal)];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn = closeBtn;
    self.closeBtn.hidden = YES;
    
    closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftBackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:leftBackBtn], [[UIBarButtonItem alloc] initWithCustomView:closeBtn]];
}

- (void)leftBackBtnClick {
    if(self.isShowCloseButton && self.showCloseButton) {
        if(self.webView.canGoBack) {
            [self.webView goBack];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UILabel *)buttonTilteLb {
    if(!_buttonTilteLb) {
        _buttonTilteLb = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, _buttonMaxWidth-25, _buttonHeight)];
        _buttonTilteLb.text = self.pageTitle;
        _buttonTilteLb.font = kHXBFont_34;
        _buttonTilteLb.hidden = YES;
        _buttonTilteLb.textColor = kHXBFontColor_333333_100;
    }
    return _buttonTilteLb;
}

- (void)closeBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)reLoadWhenViewAppear {
    [super reLoadWhenViewAppear];
    
    if (![self loadNoNetworkView]) {
        if (!_firstLoadPage && self.pageReload) {
            [self reloadPage];
        }
    }
    
    _firstLoadPage = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
    } else if ([keyPath isEqualToString:@"title"]) {
        if(!self.pageTitle) {
            self.title = [NSString H5Title:self.webView.title];
        }
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        self.showCloseButton = self.webView.canGoBack;
    }
}

- (void)setShowCloseButton:(BOOL)showCloseButton {
    _showCloseButton = showCloseButton;
    if(self.isShowCloseButton) {
        self.closeBtn.hidden = !showCloseButton;
        if(showCloseButton) {
            self.leftBackBtn.width = 25;
            if(self.isShowLeftButtonTitle) {
                [self.closeBtn addSubview:self.buttonTilteLb];
            }
        }
        else {
            self.leftBackBtn.width = _buttonMaxWidth;
            if(self.isShowLeftButtonTitle) {
                [self.leftBackBtn addSubview:self.buttonTilteLb];
            }
        }
    }
}

#pragma mark 无网络重新加载H5
- (void)getNetworkAgain
{
    [self loadWebPage];
}

#pragma mark 安装约束
- (void)setupConstraints {
    kWeakSelf
    NSInteger height = _progressViewHeight;
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(HXBStatusBarAndNavigationBarHeight);
        make.height.mas_equalTo(height);
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(HXBStatusBarAndNavigationBarHeight);
    }];
}

#pragma mark 更新约束
- (void)updateConstraints {
    NSInteger height = _progressViewHeight;
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

#pragma mark 显示加载进度
- (void)loadProgress:(BOOL)isShow {
    if (isShow) {
        _progressViewHeight = 3;
    }
    else {
        _progressViewHeight = 0;
    }
    
    if(self.loadResult) {
        self.webView.hidden = NO;
    }
    [self updateConstraints];
}

#pragma mark 注册js回调
- (void)registJavascriptBridge:(NSString *)handlerName handler:(WVJBHandler)handler {
    [self.jsBridge registerHandler:handlerName handler:handler];
}

#pragma mark 调用js
- (void)callHandler:(NSString *)handlerName data:(id)data {
    [self.jsBridge callHandler:handlerName data:data];
}

+ (instancetype)pushWithPageUrl:(NSString *)pageUrl fromController:(HXBBaseViewController *)controller
{
    HXBBaseWKWebViewController *VC = [HXBBaseWKWebViewController new];
    VC.pageUrl = pageUrl;
    [controller.navigationController pushViewController:VC animated:YES];
    return VC;
}

#pragma mark webView初始化
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [[WKUserContentController alloc] init];
        
        WKPreferences *preferences = [[WKPreferences alloc] init];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
//        preferences.minimumFontSize = 30.0;
        configuration.preferences = preferences;
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webView.navigationDelegate = self.webViewModuel;
        _webView.scrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _webView;
}

#pragma mark progressView初始化
- (HXBWKWebViewProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[HXBWKWebViewProgressView alloc] init];
        kWeakSelf
        _progressView.webViewLoadSuccessBlock = ^{
            [weakSelf loadProgress:NO];
        };
    }
    return _progressView;
}

#pragma mark webViewModuel初始化
- (HXBWKWebviewViewModuel *)webViewModuel {
    if (!_webViewModuel) {
        _webViewModuel = [[HXBWKWebviewViewModuel alloc] init];
        
        kWeakSelf
        _webViewModuel.loadStateBlock = ^(HXBPageLoadState state) {
            switch (state) {
                case HXBPageLoadStateStart: {
                    [weakSelf loadProgress:YES];
                    break;
                }
                case HXBPageLoadStateEnd: {
                    weakSelf.loadResult = YES;
                    break;
                }
                case HXBPageLoadStateFaile: {
                    [weakSelf loadProgress:NO];
                    break;
                }
                default:
                    break;
            }
        };
    }
    return _webViewModuel;
}

#pragma mark jsBridge初始化
- (WKWebViewJavascriptBridge *)jsBridge {
    if (!_jsBridge) {
        [WKWebViewJavascriptBridge enableLogging];
        
        _jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:(NSObject<WKNavigationDelegate>*)self.webViewModuel handler:^(id data, WVJBResponseCallback responseCallback) {
        }];
    }
    
    return _jsBridge;
}

#pragma mark 加载页面
- (void)loadWebPage {
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL:[NSURL URLWithString:self.pageUrl]];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *version = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSString *userAgent = [NSString stringWithFormat:@"%@/IOS %@/v%@ iphone" ,[HXBDeviceVersion deviceVersion],systemVersion,version];
    NSLog(@"%@",[KeyChain token]);
    [urlRequest setValue:[KeyChain token] forHTTPHeaderField:@"X-Hxb-Auth-Token"];
    [urlRequest setValue:userAgent forHTTPHeaderField:X_Hxb_User_Agent];
    [self.webView loadRequest:urlRequest];
}

#pragma mark 重新加载页面
- (void)reloadPage {
    self.webView.hidden = YES;
    self.loadResult = NO;
    [self.webView reload];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y > kScrAdaptationH(5)) {
        self.buttonTilteLb.hidden = NO;
    }
    else {
        self.buttonTilteLb.hidden = YES;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
