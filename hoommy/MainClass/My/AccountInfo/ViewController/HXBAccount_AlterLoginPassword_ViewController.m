//
//  HXBAccount_AlterLoginPassword_ViewController.m
//  hoomxb
//
//  Created by HXB on 2017/6/8.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBAccount_AlterLoginPassword_ViewController.h"
#import "HXBAccount_AlterLoginPassword_View.h"///修改登录密码的view
#import "HXBAccountAlterLoginPasswordViewModel.h"///修改密码接口
#import "HXBGeneralAlertVC.h"
#import "HXBSendSmscodeViewController.h"
#import "HXBCheckCaptchaViewController.h"

@interface HXBAccount_AlterLoginPassword_ViewController ()
@property (nonatomic,strong) HXBAccount_AlterLoginPassword_View *alterLoginPasswordView;

@property (nonatomic, strong) HXBAccountAlterLoginPasswordViewModel* viewModel;
@end

@implementation HXBAccount_AlterLoginPassword_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改登录密码";
    [self setUPView];
    self.viewModel = [[HXBAccountAlterLoginPasswordViewModel alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isWhiteColourGradientNavigationBar = YES;
}

- (void)setUPView {
    kWeakSelf
    self.alterLoginPasswordView = [[HXBAccount_AlterLoginPassword_View alloc]init];
    [self.view addSubview:self.alterLoginPasswordView];
    self.alterLoginPasswordView.frame = CGRectMake(0, HXBStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight - HXBStatusBarAndNavigationBarHeight);
    
//    KeyChain.siginCount = @(0).description;
    
    self.alterLoginPasswordView.forgotPasswordBlock = ^{
        NSLog(@"点击了忘记密码");
        HXBCheckCaptchaViewController *checkCaptchVC = [[HXBCheckCaptchaViewController alloc] init];
        [checkCaptchVC checkCaptchaSucceedFunc:^(NSString *checkPaptcha){
            //发送短信vc
            HXBSendSmscodeViewController *sendSmscodeVC = [[HXBSendSmscodeViewController alloc]init];
            sendSmscodeVC.title = weakSelf.title;
            sendSmscodeVC.phonNumber = KeyChain.mobile;
            sendSmscodeVC.captcha = checkPaptcha;
            sendSmscodeVC.type = weakSelf.type;
            [weakSelf.navigationController pushViewController:sendSmscodeVC animated:YES];
        }];
        [weakSelf presentViewController:checkCaptchVC animated:YES completion:nil];
    };
    
    [self.alterLoginPasswordView clickAlterButtonWithBlock:^(NSString *password_Original, NSString *password_New) {
        //验证密码
        NSString * message = [NSString isOrNoPasswordStyle:password_New];
        if (message.length > 0) {
            [HxbHUDProgress showTextWithMessage:message];
            return;
        }
        NSLog(@"---%ld---",KeyChain.siginCount.integerValue);
        
        [self.viewModel mobifyPassword_LoginRequest_requestWithOldPwd:password_Original andNewPwd:password_New andSuccessBlock:^{
            KeyChain.siginCount = @(0).description;
            [KeyChain signOut];
            weakSelf.tabBarController.selectedIndex = 0;
            [HxbHUDProgress showTextWithMessage:@"密码修改成功，请用新密码号登录"];
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_ShowLoginVC object:nil];
        } andFailureBlock:^(NSError *error) {
            KeyChain.siginCount = @(KeyChain.siginCount.integerValue + 1).description;
            if (error.code != HSJNetStateCodeAlreadyPopWindow && KeyChain.siginCount.integerValue >= 3) {
                [self alertVC_4];
            }
        }];
        
        
//        if (KeyChain.siginCount.integerValue > 5) {
//            [self alertVC_5];
//        }
        
    }];
    
}

- (void)alertVC_4 {
    //弹窗提示是否找回，点击确定到手机验证码更改登录密码页面
    HXBGeneralAlertVC *alertVC = [[HXBGeneralAlertVC alloc] initWithMessageTitle:@"是否需要找回登录密码" andSubTitle:@"" andLeftBtnName:@"取消" andRightBtnName:@"找回登录密码" isHideCancelBtn:NO isClickedBackgroundDiss:NO];
    [self presentViewController:alertVC animated:NO completion:nil];
    kWeakSelf
    [alertVC setLeftBtnBlock:^{
    }];
    [alertVC setRightBtnBlock:^{
        //去手机号修改登陆密码页   HXBSignUPAndLoginRequest_sendSmscodeType_forgot
        HXBCheckCaptchaViewController *checkCaptchVC = [[HXBCheckCaptchaViewController alloc] init];
        [checkCaptchVC checkCaptchaSucceedFunc:^(NSString *checkPaptcha){
            //发送短信vc
            HXBSendSmscodeViewController *sendSmscodeVC = [[HXBSendSmscodeViewController alloc]init];
            sendSmscodeVC.title = weakSelf.title;
            sendSmscodeVC.phonNumber = KeyChain.mobile;
            sendSmscodeVC.captcha = checkPaptcha;
            sendSmscodeVC.type = weakSelf.type;
            [weakSelf.navigationController pushViewController:sendSmscodeVC animated:YES];
            
//            [weakSelf.viewModel getVerifyCodeRequesWithMobile:KeyChain.mobile andAction:weakSelf.type andCaptcha:checkPaptcha andType:@"" andCallbackBlock:^(BOOL isSuccess, NSError *error) {
//            NSLog(@"发送 验证码");
//            if (isSuccess) {
//
//                }
//                else {
//
//                }
//            }];
        }];
        [weakSelf presentViewController:checkCaptchVC animated:YES completion:nil];
        
        
        //        ///退出登录
        //        [KeyChain signOut];
        //        //到登录界面
        //        [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_ShowLoginVC object:nil];
    }];
}

- (void)alertVC_5 {
    //弹窗提示是否找回，点击找回退出登录到登录页面
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"错误超过5次，请24小时之后再试" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    //
    //            }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        ///退出登录
        [KeyChain signOut];
        //到登录界面
        [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_ShowLoginVC object:nil];
    }];
    
//    UIAlertAction *cancalAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
//    [alertController addAction:cancalAction];
    [self presentViewController:alertController animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
