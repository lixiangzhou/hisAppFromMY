//
//  HxbSecurityCertificationViewController.m
//  hoomxb
//
//  Created by HXB-C on 2017/5/3.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HxbSecurityCertificationViewController.h"
#import "HxbSecurityCertificationView.h"
#import "HxbWithdrawCardViewController.h"//绑卡
#import "HXBSecurityCertificationViewModel.h"
@interface HxbSecurityCertificationViewController ()
@property (nonatomic, strong)HXBSecurityCertificationViewModel *viewModel;
@end

@implementation HxbSecurityCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kWeakSelf
    self.viewModel = [[HXBSecurityCertificationViewModel alloc] init];
    self.title = @"安全认证";
    HxbSecurityCertificationView *securityCertificationView = [[HxbSecurityCertificationView alloc]initWithFrame:self.view.frame];
    securityCertificationView.userInfoViewModel = self.userInfoViewModel;
    [self.view addSubview:securityCertificationView];
    
    ///点击了next
    [securityCertificationView clickNextButtonFuncWithBlock:^(NSString *name, NSString *idCard, NSString *transactionPassword,NSString *url) {
        
        //安全认证请求
        [weakSelf.viewModel securityCertification_RequestWithName:name andIdCardNo:idCard andTradpwd:transactionPassword andURL:url andSuccessBlock:^(BOOL isExist) {
            //（获取用户信息）
            [weakSelf.viewModel downLoadUserInfo:YES resultBlock:^(id responseData, NSError *erro) {
                if (!erro) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }];
        } andFailureBlock:^(NSError *error, NSString *message) {
            
        }];
    }];
}




- (void)didClickSecurityCertificationButton{
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
