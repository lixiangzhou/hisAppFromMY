//
//  HSJCodeSigInViewController.m
//  hoommy
//
//  Created by HXB-C on 2018/7/10.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJCodeSigInViewController.h"
#import "HXBCustomTextField.h"
#import "TimerWeakTarget.h"
@interface HSJCodeSigInViewController ()

@property (nonatomic, strong) HXBCustomTextField *passwordField;

@property (nonatomic, strong) UIButton *signInButton;

@property (nonatomic, strong) UIButton *codeButton;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) int timeCount;

@end

@implementation HSJCodeSigInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.signInButton];
    [self.view addSubview:self.codeButton];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(self.view).offset(kScrAdaptationW(15));
        make.right.equalTo(self.view).offset(-kScrAdaptationW(15));
    }];
    [self.signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.passwordField);
        make.top.equalTo(self.passwordField.mas_bottom).offset(kScrAdaptationH(10));
        make.height.offset(kScrAdaptationH(41));
    }];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.passwordField);
        make.top.equalTo(self.signInButton.mas_bottom).offset(kScrAdaptationH(10));
        make.height.offset(kScrAdaptationH(41));
        make.width.offset(kScrAdaptationH(150));
    }];
}
- (void)signInButtonClick {
    BOOL success = YES;
    if (success) {
        //登录成功
        
    } else {
        //登录失败
    }
}

- (void)getCode {
    self.timeCount = 60;
    self.codeButton.enabled = NO;
    [self.codeButton setTitle:[NSString stringWithFormat:@"%d秒",self.timeCount] forState:UIControlStateNormal];
    self.timer = [TimerWeakTarget scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
}

- (void)timeDown
{
    self.timeCount--;
    [self.codeButton setTitle:[NSString stringWithFormat:@"%d秒",self.timeCount] forState:UIControlStateNormal];
    if (self.timeCount <= 0) {
        self.codeButton.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        [self.codeButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
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

- (UIButton *)signInButton {
    if (!_signInButton) {
        _signInButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_signInButton addTarget:self action:@selector(signInButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_signInButton setTitle:@"登陆" forState:(UIControlStateNormal)];
        [_signInButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        _signInButton.layer.borderWidth = 1;
        _signInButton.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _signInButton;
}

- (UIButton *)codeButton {
    if (!_codeButton) {
        _codeButton = [[UIButton alloc] init];
        [_codeButton setTitle:@"重新获取验证码" forState:(UIControlStateNormal)];
        [_codeButton addTarget:self action:@selector(getCode) forControlEvents:(UIControlEventTouchUpInside)];
        [_codeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }
    return _codeButton;
}

- (void)dealloc {
    [self.timer invalidate];
}
@end
