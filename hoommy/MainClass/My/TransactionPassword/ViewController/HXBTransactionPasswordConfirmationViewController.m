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
    kWeakSelf
    [self.viewModel modifyTransactionPasswordWithIdCard:self.idcard password:surePassword resultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            UIViewController *accountVC = [weakSelf shouldPopToAccountVC];
            if (accountVC != nil) {
                [weakSelf.navigationController popToViewController:accountVC animated:YES];
            } else {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }];
}
// 以下代码控制跳转到账户信息，从解绑银行卡 忘记密码 进入时 有效
- (UIViewController *)shouldPopToAccountVC {
    __block HxbAccountInfoViewController *accountVC = nil;
    __block HXBUnBindCardController *unBindVC = nil;
    [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[HXBUnBindCardController class]]) {
            unBindVC = obj;
        } else if ([obj isKindOfClass:[HxbAccountInfoViewController class]]) {
            accountVC = obj;
        }
        if (unBindVC != nil && accountVC != nil) {
            *stop = YES;
        }
    }];
    
    if (unBindVC != nil && accountVC != nil) {
        return accountVC;
    }
    
    return nil;
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
