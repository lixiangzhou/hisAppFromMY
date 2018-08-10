//
//  HXBCheckLoginPasswordViewController.m
//  hoomxb
//
//  Created by HXB-C on 2017/6/29.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HSJCheckLoginPasswordViewController.h"
#import "HSJGestureSettingController.h"//手势密码
#import "HXBCustomTextField.h"
#import "HSJMyGestureViewModel.h"

@interface HSJCheckLoginPasswordViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *loginPassword_Original_title;
@property (nonatomic, strong) HXBCustomTextField *loginPasswordTextField;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic, strong) UIButton *checkLoginBtn;

@property (nonatomic, strong) HSJMyGestureViewModel *viewModel;
@end

@implementation HSJCheckLoginPasswordViewController

- (UIButton *)checkLoginBtn
{
    if (!_checkLoginBtn) {
        _checkLoginBtn = [UIButton btnwithTitle:@"下一步" andTarget:self andAction:@selector(checkLoginPassword) andFrameByCategory:CGRectZero];
        _checkLoginBtn.backgroundColor = kHXBColor_FF7055_40;
        _checkLoginBtn.userInteractionEnabled = NO;
    }
    return _checkLoginBtn;
}

- (UILabel *)loginPassword_Original_title {
    if (!_loginPassword_Original_title) {
        _loginPassword_Original_title = [[UILabel alloc] init];
        _loginPassword_Original_title.textColor = COR5;
        _loginPassword_Original_title.font = kHXBFont_PINGFANGSC_REGULAR(14);
        _loginPassword_Original_title.text = @"登录密码";
    }
    return _loginPassword_Original_title;
}
- (HXBCustomTextField *)loginPasswordTextField
{
    if (!_loginPasswordTextField) {
        _loginPasswordTextField = [[HXBCustomTextField alloc] init];
        _loginPasswordTextField.secureTextEntry = YES;
        _loginPasswordTextField.delegate = self;
        _loginPasswordTextField.placeholder = @"请输入您的登录密码";
        _loginPasswordTextField.textColor = kHXBFontColor_555555_100;
        _loginPasswordTextField.bottomLineEditingColor = kHXBSpacingColor_F5F5F9_100;
        _loginPasswordTextField.bottomLineNormalColor = kHXBSpacingColor_F5F5F9_100;
        
//        _loginPasswordTextField.leftImage = [UIImage imageNamed:@"password"];
        kWeakSelf
        _loginPasswordTextField.block = ^(NSString *text) {
            if (text.length > 0) {
                weakSelf.checkLoginBtn.backgroundColor = RGB(254, 126, 94);
                weakSelf.checkLoginBtn.userInteractionEnabled = YES;
            } else {
                weakSelf.checkLoginBtn.backgroundColor = kHXBColor_FF7055_40;
                weakSelf.checkLoginBtn.userInteractionEnabled = NO;
            }
        };
    }
    return _loginPasswordTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置手势密码";
    
    _viewModel = [[HSJMyGestureViewModel alloc] init];
    self.lineView = [UIView new];
    [self.view addSubview:self.lineView];
    self.lineView.backgroundColor = RGB(238, 238, 245);
    [self.view addSubview:self.loginPasswordTextField];
    [self.loginPasswordTextField addSubview: self.loginPassword_Original_title];
    [self.view addSubview:self.checkLoginBtn];
    [self setupSubViewFrame];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isWhiteColourGradientNavigationBar = YES;
}

- (void)setupSubViewFrame
{
    kWeakSelf
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1.0f);
        make.left.right.equalTo(weakSelf.view);
        make.top.mas_equalTo(HXBStatusBarAndNavigationBarHeight);
    }];
    
    [self.loginPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineView.mas_bottom);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.offset(kScrAdaptationH750(120));
    }];
    [self.loginPassword_Original_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.loginPasswordTextField);
        make.left.equalTo(weakSelf.loginPasswordTextField.leftImageView);
        make.height.equalTo(weakSelf.loginPasswordTextField.textField);
        make.width.equalTo(@kScrAdaptationW(60));
    }];
    [self.loginPasswordTextField.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.loginPassword_Original_title).offset(kScrAdaptationW(29+60));
    }];
    [self.checkLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(kScrAdaptationW750(40));
        make.right.equalTo(weakSelf.view).offset(-kScrAdaptationW750(40));
        make.top.equalTo(weakSelf.loginPasswordTextField.mas_bottom).offset(kScrAdaptationH750(92));
        make.height.offset(kScrAdaptationH750(82));
    }];
}

- (void)checkLoginPassword
{
    kWeakSelf
    NSString * message = [NSString isOrNoPasswordStyle:self.loginPasswordTextField.text];
    if (message.length > 0) {
        [HxbHUDProgress showTextWithMessage:message];
        return;
    } else {
        [_viewModel accountSetGesturePasswordWithPassword:self.loginPasswordTextField.text resultBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                if (weakSelf.switchType == HXBAccountSecureSwitchTypeOff) {
                    KeyChain.skipGesture = kHXBGesturePwdSkipeYES;
                    KeyChain.skipGestureAlertAppeared = YES;
                    [KeyChain removeGesture];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } else {
                    HSJGestureSettingController *VC = [[HSJGestureSettingController alloc] init];
                    VC.switchType = weakSelf.switchType;
                    [weakSelf.navigationController pushViewController:VC animated:YES];
                }
            }
        }];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    _checkLoginBtn.backgroundColor = kHXBColor_FF7055_40;
    _checkLoginBtn.userInteractionEnabled = NO;
    return YES;
}


@end
