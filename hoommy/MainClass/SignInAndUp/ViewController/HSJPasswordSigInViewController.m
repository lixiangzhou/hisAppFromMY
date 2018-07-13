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
@interface HSJPasswordSigInViewController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) HXBCustomTextField *passwordField;

@property (nonatomic, strong) HSJSignInButton *nextButton;

@property (nonatomic, strong) UIButton *codeButton;



@end

@implementation HSJPasswordSigInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
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
    [self.viewModel loginRequetWithMobile:self.viewModel.phoneNumber password:self.passwordField.text resultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            //登录成功
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            //登录失败
        }
    }];
    
    
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
        _passwordField.isHiddenLeftImage = YES;
        _passwordField.textColor = kHXBFontColor_555555_100;
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
        _codeButton = [[UIButton alloc] init];
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


@end
