//
//  HSJCodeSigInViewController.m
//  hoommy
//
//  Created by HXB-C on 2018/7/10.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJCodeSigInViewController.h"
#import "HXBCustomTextField.h"

@interface HSJCodeSigInViewController ()

@property (nonatomic, strong) HXBCustomTextField *passwordField;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) UIButton *codeButton;

@end

@implementation HSJCodeSigInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.codeButton];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(self.view).offset(kScrAdaptationW(15));
        make.right.equalTo(self.view).offset(-kScrAdaptationW(15));
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.passwordField);
        make.top.equalTo(self.passwordField.mas_bottom).offset(kScrAdaptationH(10));
        make.height.offset(kScrAdaptationH(41));
    }];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.passwordField);
        make.top.equalTo(self.nextButton.mas_bottom).offset(kScrAdaptationH(10));
        make.height.offset(kScrAdaptationH(41));
        make.width.offset(kScrAdaptationH(150));
    }];
}
- (void)nextButtonClick {
    BOOL success = YES;
    if (success) {
        //登录成功
        
    } else {
        //登录失败
    }
}

- (HXBCustomTextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [[HXBCustomTextField alloc] init];
        _passwordField.placeholder = @"请输入验证码";
        _passwordField.isHidenLine = NO;
        _passwordField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _passwordField;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] init];
        [_nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_nextButton setTitle:@"登陆" forState:(UIControlStateNormal)];
        [_nextButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        _nextButton.layer.borderWidth = 1;
        _nextButton.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _nextButton;
}

- (UIButton *)codeButton {
    if (!_codeButton) {
        _codeButton = [[UIButton alloc] init];
        [_codeButton setTitle:@"重新获取验证码" forState:(UIControlStateNormal)];
        [_codeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }
    return _codeButton;
}

@end
