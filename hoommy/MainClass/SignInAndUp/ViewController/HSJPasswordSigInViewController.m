//
//  HSJPasswordSigInViewController.m
//  hoommy
//
//  Created by HXB-C on 2018/7/10.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJPasswordSigInViewController.h"
#import "HXBCustomTextField.h"
#import "HSJCodeSigInViewController.h"
#import "HSJSignInButton.h"
#import "HSJCheckCaptcha.h"
@interface HSJPasswordSigInViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) HXBCustomTextField *passwordField;

@property (nonatomic, strong) HSJSignInButton *nextButton;

@property (nonatomic, strong) UIButton *codeButton;

@property (nonatomic, strong) HSJCheckCaptcha *captchaView;

@property (nonatomic, copy) NSString *captcha;

@property (nonatomic, strong) HSJSignInViewModel *viewModel;

@end

@implementation HSJPasswordSigInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
}

- (void)setupData {
    self.viewModel = [[HSJSignInViewModel alloc] init];
    self.viewModel.phoneNumber = self.phoneNumber;
}

- (void)setupUI {
    self.isWhiteColourGradientNavigationBar = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.codeButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.nextButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kScrAdaptationW(25));
        make.top.equalTo(self.view).offset(kScrAdaptationH(30) + HXBStatusBarAndNavigationBarHeight);
    }];
    
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kScrAdaptationH(55));
        make.left.equalTo(self.view).offset(kScrAdaptationW(25));
        make.right.equalTo(self.view).offset(-kScrAdaptationW(25));
        make.height.offset(kScrAdaptationH(40));
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.passwordField);
        make.top.equalTo(self.passwordField.mas_bottom).offset(kScrAdaptationH(60));
        make.height.offset(kScrAdaptationH(41));
    }];
}


- (void)nextButtonClick {
    [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_SignInPasswordButtonClick];
    kWeakSelf
    [self.viewModel loginRequetWithMobile:self.viewModel.phoneNumber password:self.passwordField.text andWithSmscode:@"" andWithCaptcha:weakSelf.captcha resultBlock:^(BOOL isSuccess,BOOL isNeedCaptcha) {
        weakSelf.captcha = @"";
        if (isSuccess) {
            //登录成功
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } else if (isNeedCaptcha){
            //需要图验
            [weakSelf.view addSubview:weakSelf.captchaView];
            weakSelf.captchaView.isFirstResponder = YES;
            [weakSelf getCaptcha];
            
        } else {
            //登录失败
        }
    }];
    
}

- (void) checkCaptcha{
    kWeakSelf
    [self.viewModel checkCaptchaRequestWithCaptcha:self.captcha resultBlock:^(BOOL isSuccess, BOOL needDownload) {
        if (isSuccess) {
            [weakSelf nextButtonClick];
            [weakSelf.captchaView removeFromSuperview];
        } else if (needDownload) {
            [weakSelf getCaptcha];
        } else {
            [weakSelf.captchaView removeFromSuperview];
        }
    }];
}

- (void)getCaptcha {
    kWeakSelf
    [self.viewModel captchaRequestWithResultBlock:^(UIImage *captchaimage) {
        weakSelf.captchaView.checkCaptchaImage = captchaimage;
    }];
}

- (void)getCode {
    [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_SignInGoCodeSignInButtonClick];
    
    HSJCodeSigInViewController *codeSigInVC = [[HSJCodeSigInViewController alloc] init];
    codeSigInVC.phoneNumber = self.viewModel.phoneNumber;
    [self.navigationController pushViewController:codeSigInVC animated:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.passwordField.textField == textField) {
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_SignInPasswordTextFieldClick];
    }
}

- (HXBCustomTextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [[HXBCustomTextField alloc] init];
        _passwordField.placeholder = @"请输入密码";
        _passwordField.isHidenLine = NO;
        _passwordField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordField.secureTextEntry = YES;
        _passwordField.isHiddenLeftImage = YES;
        _passwordField.textColor = kHXBFontColor_555555_100;
        _passwordField.bottomLineEditingColor = kHXBSpacingColor_F5F5F9_100;
        _passwordField.bottomLineNormalColor = kHXBSpacingColor_F5F5F9_100;
        _passwordField.delegate = self;
        kWeakSelf
        _passwordField.block = ^(NSString *text1) {
            weakSelf.nextButton.enabled = text1.length;
        };
    }
    return _passwordField;
}

- (HSJSignInButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[HSJSignInButton alloc] init];
        [_nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_nextButton setTitle:@"登录" forState:(UIControlStateNormal)];
    }
    return _nextButton;
}

- (UIButton *)codeButton {
    if (!_codeButton) {
        _codeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScrAdaptationW(70), kScrAdaptationH(22))];
        [_codeButton setTitle:@"验证码登录" forState:(UIControlStateNormal)];
        [_codeButton addTarget:self action:@selector(getCode) forControlEvents:(UIControlEventTouchUpInside)];
        _codeButton.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
        [_codeButton setTitleColor:kHXBColor_666666_100 forState:(UIControlStateNormal)];
        
    }
    return _codeButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"请输入登录密码";
        _titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(30);
        _titleLabel.textColor = kHXBFontColor_505050_100;
    }
    return _titleLabel;
}

- (HSJCheckCaptcha *)captchaView {
    if (!_captchaView) {
        kWeakSelf
        _captchaView = [[HSJCheckCaptcha alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _captchaView.cancelBlock = ^{
            [weakSelf.captchaView removeFromSuperview];
            weakSelf.captcha = @"";
        };
        
        [_captchaView clickTrueButtonFunc:^(NSString *checkCaptChaStr) {
            weakSelf.captcha = checkCaptChaStr;
            [weakSelf checkCaptcha];
        }];
        
        [_captchaView clickCheckCaptchaImageViewFunc:^{
            [weakSelf getCaptcha];
        }];
        
    }
    return _captchaView;
}

@end
