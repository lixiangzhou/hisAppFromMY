//
//  HSJMyViewController.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/13.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJMyViewController.h"
#import "HSJBaseModel.h"
#import "HSJBankCardListViewController.h"
#import "HSJRiskAssessmentViewController.h"
#import "HSJSignInViewController.h"
#import "HxbAccountInfoViewController.h"
@interface HSJMyViewController ()

@end

@implementation HSJMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)settingAccount:(id)sender {
    HxbAccountInfoViewController *accountInfoVC = [[HxbAccountInfoViewController alloc]init];
//    accountInfoVC.userInfoViewModel = self.viewModel.userInfoModel;
//    accountInfoVC.isDisplayAdvisor = self.viewModel.userInfoModel.userInfoModel.userInfo.isDisplayAdvisor;
    [self.navigationController pushViewController:accountInfoVC animated:YES];
}

- (IBAction)loginAct:(UIButton *)sender {
    
}

- (IBAction)openAccountAct:(UIButton *)sender {
}

- (IBAction)bindPhoneAct:(UIButton *)sender {

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
