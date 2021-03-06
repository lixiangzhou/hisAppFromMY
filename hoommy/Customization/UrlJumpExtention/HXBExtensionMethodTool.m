//
//  HXBExtensionMethodTool.m
//  hoomxb
//
//  Created by HXB-C on 2018/6/13.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HXBExtensionMethodTool.h"
#import "BannerModel.h"
#import "HXBBaseViewController.h"
#import "HXBRootVCManager.h"
#import "HXBBannerWebViewController.h"
#import "HXBBannerViewModel.h"
#import "HXBNoticeViewController.h"
#import "HSJPlanDetailController.h"
#import "HSJDepositoryOpenController.h"

@implementation HXBExtensionMethodTool

// 点击benner跳转的方法(公告列表，详情，计划列表) H5
+ (void)pushToViewControllerWithModel:(BannerModel *)model andWithFromVC:(HXBBaseViewController *)comeFromVC{
    
    __block HXBBaseViewController *vc;
    if ([model.type isEqualToString:@"native"]) {
        [model.link parseUrlParam:^(NSString *path, NSDictionary *paramDic) {
             if ([path isEqualToString:kPlanDetailVC]) { // 计划详情
                HSJPlanDetailController *planVC = [HSJPlanDetailController new];
                planVC.planId = paramDic[@"productId"];
                vc = planVC;
            }  else if ([path isEqualToString:kLoginVC]) { //跳转登录注册
                [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_ShowLoginVC object:nil];
            } else if([path isEqualToString:kEscrowActivityVC]) {   // 开户
                if(KeyChain.isLogin) {
                    HSJDepositoryOpenController *openDepositAccountVC = [[HSJDepositoryOpenController alloc] init];
                    vc = openDepositAccountVC;
                }
                else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_ShowLoginVC object:nil];
                }
                
            } 
        }];
        
    } else if ([model.type isEqualToString:@"h5"]){
        if (model.link.length) {
            HXBBannerWebViewController *webViewVC = [[HXBBannerWebViewController alloc] init];
            webViewVC.pageUrl = model.link;
            webViewVC.model = model;
            vc = webViewVC;
        }
        
    } else if ([model.type isEqualToString:@"broswer"]) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.link]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.link]];
        }
    }
    [comeFromVC.navigationController pushViewController:vc animated:YES];
}


@end
