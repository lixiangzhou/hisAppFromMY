//
//  HSJSignUpViewController.m
//  hoommy
//
//  Created by HXB-C on 2018/7/9.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJSignUpViewController.h"
#import "HXBCustomTextField.h"
@interface HSJSignUpViewController ()

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) HXBCustomTextField *codeTextField;

@property (nonatomic, strong) UILabel *passwordLabel;

@property (nonatomic, strong) HXBCustomTextField *passwordTextField;

@property (nonatomic, strong) UIButton *signUpButton;

@end

@implementation HSJSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:self.codeTextField];
    [self.view addSubview:self.passwordLabel];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.signUpButton];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kScrAdaptationW(15));
        make.top.equalTo(self.view).offset(kScrAdaptationH(100));
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneLabel);
        make.right.equalTo(self.view).offset(-kScrAdaptationW(15));
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(kScrAdaptationH(10));
    }];
    
    [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneLabel);
        make.top.equalTo(self.codeTextField).offset(kScrAdaptationH(40));
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.codeTextField);
        make.top.equalTo(self.passwordLabel.mas_bottom).offset(kScrAdaptationH(10));
    }];
    
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.codeTextField);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(kScrAdaptationH(10));
        make.height.offset(kScrAdaptationH(41));
    }];
}

-(void)signUpButtonClick {
    NSLog(@"完成注册");
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.text = @"验证码已发送至 133 2098 746";
    }
    return _phoneLabel;
}

- (HXBCustomTextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[HXBCustomTextField alloc] init];
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.isHidenLine = NO;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _codeTextField;
}

- (UILabel *)passwordLabel {
    if (!_passwordLabel) {
        _passwordLabel = [[UILabel alloc] init];
        _passwordLabel.text = @"为了您的账户安全请设置登陆密码";
    }
    return _passwordLabel;
}

- (HXBCustomTextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[HXBCustomTextField alloc] init];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.isHidenLine = NO;
        _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextField.secureTextEntry = YES;
    }
    return _passwordTextField;
}

- (UIButton *)signUpButton {
    if (!_signUpButton) {
        _signUpButton = [[UIButton alloc] init];
        [_signUpButton addTarget:self action:@selector(signUpButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_signUpButton setTitle:@"完成注册" forState:(UIControlStateNormal)];
        [_signUpButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        _signUpButton.layer.borderWidth = 1;
        _signUpButton.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _signUpButton;
}

@end
