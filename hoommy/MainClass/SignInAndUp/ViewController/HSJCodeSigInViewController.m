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
#import "HSJSignInButton.h"
#import "NSAttributedString+HxbAttributedString.h"
@interface HSJCodeSigInViewController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *phoneNumberLabel;

@property (nonatomic, strong) HXBCustomTextField *passwordField;

@property (nonatomic, strong) HSJSignInButton *signInButton;

@property (nonatomic, strong) UIButton *codeButton;

@property (nonatomic, strong) UIButton *voiceCodeButton;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) int timeCount;

@end

@implementation HSJCodeSigInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.isWhiteColourGradientNavigationBar = YES;
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.phoneNumberLabel];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.signInButton];
    [self.view addSubview:self.codeButton];
    [self.view addSubview:self.voiceCodeButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kScrAdaptationW(25));
        make.top.equalTo(self.view).offset(kScrAdaptationH(30) + HXBStatusBarAndNavigationBarHeight);
        make.height.offset(kScrAdaptationH(42));
    }];
    
    [self.phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kScrAdaptationH(5));
    }];
    
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kScrAdaptationH(55));
        make.left.equalTo(self.view).offset(kScrAdaptationW(25));
        make.right.equalTo(self.view).offset(-kScrAdaptationW(25));
        make.height.offset(kScrAdaptationH(40));
    }];
    
    
    
    [self.signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.passwordField);
        make.top.equalTo(self.passwordField.mas_bottom).offset(kScrAdaptationH(60));
        make.height.offset(kScrAdaptationH(41));
    }];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.height.equalTo(self.passwordField);
        make.width.offset(kScrAdaptationW(60));
    }];
    
    [self.voiceCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.passwordField);
        make.top.equalTo(self.passwordField.mas_bottom).offset(kScrAdaptationH(10));
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
    [self.codeButton setTitle:[NSString stringWithFormat:@"%ds",self.timeCount] forState:UIControlStateNormal];
    [self.codeButton setTitleColor:kHXBFontColor_C7C7CD_100 forState:(UIControlStateNormal)];
    self.timer = [TimerWeakTarget scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
}

- (void)timeDown
{
    self.timeCount--;
    [self.codeButton setTitle:[NSString stringWithFormat:@"%ds",self.timeCount] forState:UIControlStateNormal];
    if (self.timeCount <= 0) {
        self.codeButton.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        [self.codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.codeButton setTitleColor:kHXBFontColor_FB9561_100 forState:(UIControlStateNormal)];
    }
    
}
- (HXBCustomTextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [[HXBCustomTextField alloc] init];
        _passwordField.placeholder = @"请输入验证码";
        _passwordField.isHidenLine = NO;
        _passwordField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordField.isHiddenLeftImage = YES;
        _passwordField.isGetCode = YES;
        _passwordField.textColor = kHXBFontColor_555555_100;
        _passwordField.font = kHXBFont_PINGFANGSC_REGULAR(15);
        kWeakSelf
        _passwordField.block = ^(NSString *text1) {
            weakSelf.signInButton.enabled = text1.length;
        };
    }
    return _passwordField;
}

- (HSJSignInButton *)signInButton {
    if (!_signInButton) {
        _signInButton = [HSJSignInButton buttonWithType:(UIButtonTypeCustom)];
        [_signInButton addTarget:self action:@selector(signInButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_signInButton setTitle:@"完成" forState:(UIControlStateNormal)];
    }
    return _signInButton;
}

- (UIButton *)codeButton {
    if (!_codeButton) {
        _codeButton = [[UIButton alloc] init];
        [_codeButton setTitle:@"重新获取" forState:(UIControlStateNormal)];
        [_codeButton addTarget:self action:@selector(getCode) forControlEvents:(UIControlEventTouchUpInside)];
        [_codeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_codeButton setTitleColor:kHXBFontColor_FB9561_100 forState:(UIControlStateNormal)];
        _codeButton.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(15);
    }
    return _codeButton;
}

- (UIButton *)voiceCodeButton {
    if (!_voiceCodeButton) {
        _voiceCodeButton = [[UIButton alloc] init];
        
        NSString *messageStr = @"您也可以";
        
        NSMutableAttributedString *voiceCodeStr = [NSMutableAttributedString setupAttributeStringWithString:messageStr WithRange:NSMakeRange(0, messageStr.length) andAttributeColor:kHXBFontColor_555555_100 andAttributeFont:kHXBFont_PINGFANGSC_REGULAR(12)];
        
        messageStr = @"接听语音验证码";
        
        [voiceCodeStr appendAttributedString:[NSMutableAttributedString setupAttributeStringWithString:messageStr WithRange:NSMakeRange(0, messageStr.length) andAttributeColor:kHXBFontColor_FB9561_100 andAttributeFont:kHXBFont_PINGFANGSC_REGULAR(12)]];
        
        [_voiceCodeButton addTarget:self action:@selector(getCode) forControlEvents:(UIControlEventTouchUpInside)];
        _voiceCodeButton.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(12);
        [_voiceCodeButton setAttributedTitle:voiceCodeStr  forState:(UIControlStateNormal)];
    }
    return _voiceCodeButton;
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

- (UILabel *)phoneNumberLabel {
    if (!_phoneNumberLabel) {
        _phoneNumberLabel = [[UILabel alloc] init];
        _phoneNumberLabel.text = @"验证码已经发送发到";
        _phoneNumberLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
        _phoneNumberLabel.textColor = kHXBFontColor_555555_100;
    }
    return _phoneNumberLabel;
}

- (void)dealloc {
    [self.timer invalidate];
}
@end
