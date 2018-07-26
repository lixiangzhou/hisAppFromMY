//
//  HXBBannerWebViewController.m
//  hoomxb
//
//  Created by HXB-C on 2017/8/23.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBannerWebViewController.h"
#import "WebViewJavascriptBridge.h"
#import "HXBUMengShareManager.h"
#import "HXBUMShareViewModel.h"
#import "HXBUMShareModel.h"
#import "HXBBannerViewModel.h"
#import "HXBXYAlertViewController.h"
#import "NSObject+YYModel.h"
#import "BannerModel.h"
#import "HXBExtensionMethodTool.h"
static NSString *const HXB_Toast = @"toast";
static NSString *const HXB_Dialog = @"dialog";

@interface HXBBannerWebViewController ()
@property (nonatomic, strong) HXBBannerViewModel* viewModel;
@end

@implementation HXBBannerWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.pageTitle) {
       self.title = @"";
    }
    self.isWhiteColourGradientNavigationBar = YES;
    self.pageReload = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupJavascriptBridge];
    [self setupShareBtn];
}

#pragma mark 初始化viewModel
- (HXBBannerViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [[HXBBannerViewModel alloc] init];
    }
    
    return _viewModel;
}

- (void)setupShareBtn {
    self.viewModel.model = self.model;
    if ([self.viewModel isNeedShare]) {
        UIButton *shareBtn = [[UIButton alloc] initWithFrame: CGRectMake(kScreenWidth - HXBNavigationBarHeight, 0, HXBNavigationBarHeight, HXBNavigationBarHeight)];
        shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kScrAdaptationW(15));
        [shareBtn setImage:[UIImage imageNamed:@"share"] forState:(UIControlStateNormal)];
        [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.navigationController.navigationBar addSubview:shareBtn];
    }
    
}

- (void)shareClick {
    [self.viewModel share];
}
/**
 初始化与H5交互
 */
- (void)setupJavascriptBridge {

    kWeakSelf
    /****** OC端注册一个方法 (测试)******/
    [self registJavascriptBridge:@"startPage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"%@",data);
        [weakSelf logicalJumpWithData:data];
    }];
    /****** OC端注册一个方法 (h5 调app 展示信息框)******/
    [self registJavascriptBridge:@"showMessage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"%@",data);
        [weakSelf showH5MessageWithData:data];
    }];
    [self registJavascriptBridge:@"startH5Page" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"%@",data);
        [weakSelf h5PageJumpWithData:data];
    }];
    [self registJavascriptBridge:@"share" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"%@",data);
        HXBUMShareViewModel *shareViewModel = [[HXBUMShareViewModel alloc] init];
        shareViewModel.shareModel = [HXBUMShareModel yy_modelWithDictionary:data];
        [HXBUMengShareManager showShareMenuViewInWindowWith:shareViewModel];
    }];
    
}

/**
 跳转H5页面的回调

 @param data 参数
 */
- (void)h5PageJumpWithData:(id)data
{
    NSDictionary* urlParamDic = data;
    NSString *path = [urlParamDic stringAtPath:@"path"];
    
    if([path isEqualToString:kH5LandingDeposit]){
        HXBBannerWebViewController* webviewVC = [[HXBBannerWebViewController alloc] init];
        webviewVC.pageTitle = [urlParamDic stringAtPath:@"title"];
        webviewVC.pageUrl = [NSString stringWithFormat:@"%@%@", [KeyChainManage sharedInstance].h5host, path];
        [self.navigationController pushViewController:webviewVC animated:YES];
    }
    else if([path isEqualToString:kH5LandingTrust]) {
        HXBBaseWKWebViewController* webviewVC = [[HXBBaseWKWebViewController alloc] init];
        webviewVC.pageTitle = [urlParamDic stringAtPath:@"title"];
        webviewVC.pageUrl = [NSString stringWithFormat:@"%@%@", [KeyChainManage sharedInstance].h5host, path];
        [self.navigationController pushViewController:webviewVC animated:YES];
    }
}

- (void)logicalJumpWithData:(id)data
{
    NSString *path = data[@"path"];
    BannerModel *bannerModel = [[BannerModel alloc] init];
    bannerModel.type = @"native";
    bannerModel.link = path;
    [HXBExtensionMethodTool pushToViewControllerWithModel:bannerModel andWithFromVC:self];
   
}

// H5回传弹出样式
- (void)showH5MessageWithData:(id)data {
    NSString *type = data[@"type"];
    NSString *showMessage = data[@"message"];
    if ([type isEqualToString:HXB_Toast]) {
        
        [HxbHUDProgress showTextWithMessage:showMessage];
    } else if ([type isEqualToString:HXB_Dialog]) {
        HXBXYAlertViewController *alertVC = [[HXBXYAlertViewController alloc] initWithTitle:nil Massage:showMessage force:2 andLeftButtonMassage:@"" andRightButtonMassage:@"确定"];
        [alertVC setClickXYRightButtonBlock:^{
        }];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}


@end
