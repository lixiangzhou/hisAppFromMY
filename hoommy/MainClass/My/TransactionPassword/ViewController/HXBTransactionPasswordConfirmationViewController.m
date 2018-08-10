//
//  HXBTransactionPasswordConfirmationViewController.m
//  修改交易密码
//
//  Created by HXB-C on 2017/6/8.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBTransactionPasswordConfirmationViewController.h"
#import "HXBTransactionPasswordConfirmationView.h"
#import "HxbAccountInfoViewController.h"
#import "HXBUnBindCardController.h"
#import "HxbAccountInfoViewController.h"
#import "HXBTransactionPasswordConfirmationViewModel.h"

@interface HXBTransactionPasswordConfirmationViewController ()

@property (nonatomic, strong) HXBTransactionPasswordConfirmationView *homeView;
@property (nonatomic, strong) HXBTransactionPasswordConfirmationViewModel *viewModel;
@end

@implementation HXBTransactionPasswordConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isShowSplitLine = YES;
    
    self.viewModel = [[HXBTransactionPasswordConfirmationViewModel alloc] init];
    
    [self setupSubView];
}

- (void)setupSubView
{
    self.title = @"设置新交易密码";
    [self.view addSubview:self.homeView];
}

/**
 确认修改交易密码

 @param surePassword 设置的新密码
 */
- (void)confirmTransactionWithPassword:(NSString *)surePassword
{
    if(surePassword.length < 6) {
        [HxbHUDProgress showTextInView:self.view text:@"请输入6为交易密码"];
        return;
    }
    
    kWeakSelf
    [self.viewModel modifyTransactionPasswordWithIdCard:self.idcard password:surePassword resultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            HXBBaseNavigationController *navVC =(HXBBaseNavigationController *)weakSelf.navigationController;
            UIViewController *accountVC = [navVC getViewControllerByClassName:@"HSJBuyViewController"];
            if(!accountVC) {
                accountVC = [navVC getViewControllerByClassName:@"HxbAccountInfoViewController"];
            }
            
            if (accountVC != nil) {
                [weakSelf.navigationController popToViewController:accountVC animated:YES];
            } else {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }];
}

#pragma mark - get方法
- (HXBTransactionPasswordConfirmationView *)homeView
{
    if (!_homeView) {
        _homeView = [[HXBTransactionPasswordConfirmationView alloc] initWithFrame:CGRectMake(0, HXBStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight - HXBStatusBarAndNavigationBarHeight)];
        kWeakSelf
        _homeView.confirmChangeButtonClickBlock = ^(NSString *surePassword){
            [weakSelf confirmTransactionWithPassword:surePassword];
        };
    }
    return _homeView;
}


@end
