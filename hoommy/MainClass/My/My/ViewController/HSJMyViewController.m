//
//  HSJMyViewController.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/13.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJMyViewController.h"
#import "HSJBaseModel.h"

#import "HXBBindPhoneViewController.h"

#import "HSJBankCardListViewController.h"
#import "HSJRiskAssessmentViewController.h"
#import "HSJSignInViewController.h"
#import "HXBBaseNavigationController.h"
#import "HxbAccountInfoViewController.h"
#import "HXBGeneralAlertVC.h"

#import "HSJMyViewVCViewModel.h"

@interface HSJMyViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginOrSignout;

@property (nonatomic, strong) HSJMyViewVCViewModel *viewModel;
@end

@implementation HSJMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
}

- (void)setupData {
    self.viewModel = [[HSJMyViewVCViewModel alloc] init];
    
    kWeakSelf
    [self.viewModel downLoadUserInfo:YES resultBlock:^(id responseData, NSError *erro) {
        weakSelf.viewModel.userInfoModel = responseData;
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    if (!KeyChain.isLogin) {
        [self.loginOrSignout setTitle:@"登陆" forState:UIControlStateNormal];
    } else {
        [self.loginOrSignout setTitle:@"退出" forState:UIControlStateNormal];
    }
}

- (IBAction)settingAccount:(id)sender {
    HxbAccountInfoViewController *accountInfoVC = [[HxbAccountInfoViewController alloc]init];
//    accountInfoVC.userInfoViewModel = self.viewModel.userInfoModel;
//    accountInfoVC.isDisplayAdvisor = self.viewModel.userInfoModel.userInfoModel.userInfo.isDisplayAdvisor;
    [self.navigationController pushViewController:accountInfoVC animated:YES];
}

- (IBAction)loginAct:(UIButton *)sender {
    
    if (!KeyChain.isLogin) {
        HXBBaseNavigationController *nav = [[HXBBaseNavigationController alloc] initWithRootViewController:[[HSJSignInViewController alloc] init]];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    } else {
        IDPLogDebug(@"已经登录");
        //登出按钮事件
        [self signOutButtonButtonClick];
    }

}

- (IBAction)openAccountAct:(UIButton *)sender {
}

- (IBAction)bindPhoneAct:(UIButton *)sender {
    HXBBindPhoneViewController* vc = [[HXBBindPhoneViewController alloc] init];
    vc.bindPhoneStepType = HXBBindPhoneStepFirst;
    vc.userInfoModel = self.viewModel.userInfoModel;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)signOutButtonButtonClick{
    kWeakSelf
    HXBGeneralAlertVC *alertVC = [[HXBGeneralAlertVC alloc] initWithMessageTitle:@"提示" andSubTitle:@"您确定要退出登录吗？" andLeftBtnName:@"取消" andRightBtnName:@"确定" isHideCancelBtn:YES isClickedBackgroundDiss:YES];
    alertVC.isCenterShow = YES;
    [self presentViewController:alertVC animated:NO completion:nil];
    [alertVC setRightBtnBlock:^{
        [KeyChain signOut];
        [(HXBBaseTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController setSelectedIndex:0];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)buttonClickAct:(UIButton *)sender {
    HSJBaseModel* mode = [[HSJBaseModel alloc] initWithDictionary:@{@"code":@200, @"id":@"hello", @"data":@{@"name":@"jim"}}];
    if(mode.code.intValue == 200) {
        [[IDPCache sharedCache] setObj:mode forKey:@"obj"];
        HSJBaseModel* test = [[IDPCache sharedCache] objectForKey:@"obj"];
        int i = 0;
        i++;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
