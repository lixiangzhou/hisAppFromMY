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
@interface HSJPasswordSigInViewController ()

@property (nonatomic, strong) HXBCustomTextField *passwordField;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) UIButton *codeButton;

@end

@implementation HSJPasswordSigInViewController

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
        make.width.offset(kScrAdaptationH(100));
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

- (void)getCode {
    [self.navigationController pushViewController:[[HSJCodeSigInViewController alloc] init] animated:YES];
}

- (HXBCustomTextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [[HXBCustomTextField alloc] init];
        _passwordField.placeholder = @"请输入密码";
        _passwordField.isHidenLine = NO;
        _passwordField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordField.secureTextEntry = YES;
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
        [_codeButton setTitle:@"验证码登陆" forState:(UIControlStateNormal)];
        [_codeButton addTarget:self action:@selector(getCode) forControlEvents:(UIControlEventTouchUpInside)];
        [_codeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }
    return _codeButton;
}


@end
