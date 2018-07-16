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
#import "HSJSignInViewModel.h"
#import "HXBCheckCaptcha.h"
#import "HXBGeneralAlertVC.h"
@interface HSJCodeSigInViewController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *phoneNumberLabel;

@property (nonatomic, strong) HXBCustomTextField *codeTextField;

@property (nonatomic, strong) HSJSignInButton *signInButton;

@property (nonatomic, strong) UIButton *codeButton;

@property (nonatomic, strong) UIButton *voiceCodeButton;

@property (nonatomic, strong) HXBCheckCaptcha *captchaView;

@property (nonatomic, copy) NSString *captcha;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) int timeCount;


@end

@implementation HSJCodeSigInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getCode];
}

- (void)setupUI {
    self.isWhiteColourGradientNavigationBar = YES;
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.phoneNumberLabel];
    [self.view addSubview:self.codeTextField];
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
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kScrAdaptationH(55));
        make.left.equalTo(self.view).offset(kScrAdaptationW(25));
        make.right.equalTo(self.view).offset(-kScrAdaptationW(25));
        make.height.offset(kScrAdaptationH(40));
    }];
    
    
    
    [self.signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.codeTextField);
        make.top.equalTo(self.codeTextField.mas_bottom).offset(kScrAdaptationH(60));
        make.height.offset(kScrAdaptationH(41));
    }];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.height.equalTo(self.codeTextField);
        make.width.offset(kScrAdaptationW(60));
    }];
    
    [self.voiceCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.codeTextField);
        make.top.equalTo(self.codeTextField.mas_bottom).offset(kScrAdaptationH(10));
    }];
}
- (void)signInButtonClick {
    kWeakSelf
    [self.viewModel loginRequetWithMobile:self.viewModel.phoneNumber password:@"" andWithSmscode:self.codeTextField.text andWithCaptcha:self.captcha resultBlock:^(BOOL isSuccess,BOOL isNeedCaptcha) {
        if (isSuccess) {
            //登录成功
            [self dismissViewControllerAnimated:YES completion:nil];
        } else if (isNeedCaptcha) {
           //需要图验
            [weakSelf.view addSubview:weakSelf.captchaView];
            [weakSelf getCaptcha];
            
        } else {
             //登录失败
        }
    }];
}

- (void)getCaptcha {
    kWeakSelf
    [self.viewModel captchaRequestWithResultBlock:^(UIImage *captchaimage) {
        weakSelf.captchaView.checkCaptchaImage = captchaimage;
    }];
}

- (void) checkCaptcha{
    kWeakSelf
    [self.viewModel checkCaptchaRequestWithCaptcha:self.captcha resultBlock:^(BOOL isSuccess, BOOL needDownload) {
        if (isSuccess) {
            [weakSelf signInButtonClick];
            [weakSelf.captchaView removeFromSuperview];
        } else if (needDownload) {
            [weakSelf getCaptcha];
        } else {
            [weakSelf.captchaView removeFromSuperview];
        }
    }];
}

- (void)getVoiceCode {
    HXBGeneralAlertVC *alertVC = [[HXBGeneralAlertVC alloc] initWithMessageTitle:@"获取语音验证码" andSubTitle:@"我们将以电话形式告知验证码，请您注意接听" andLeftBtnName:@"暂不接听" andRightBtnName:@"现在接听" isHideCancelBtn:NO isClickedBackgroundDiss:NO];
    [self presentViewController:alertVC animated:NO completion:nil];
    kWeakSelf
    [alertVC setLeftBtnBlock:^{
        
    }];
    [alertVC setRightBtnBlock:^{
        [weakSelf getVoiceCodeWithType:@"voice"];//获取语音验证码
    }];
}

- (void)getCode {
    [self getVoiceCodeWithType:@"sms"];
}

- (void)getVoiceCodeWithType:(NSString *)type {
    self.timeCount = 60;
    self.codeButton.enabled = NO;
    self.voiceCodeButton.hidden = YES;
    [self.codeButton setTitle:[NSString stringWithFormat:@"%ds",self.timeCount] forState:UIControlStateNormal];
    [self.codeButton setTitleColor:kHXBFontColor_C7C7CD_100 forState:(UIControlStateNormal)];
    [self.viewModel getVerifyCodeRequesWithSignInWithAction:@"login" andWithType:type andWithMobile:self.viewModel.phoneNumber andCallbackBlock:^(BOOL isSuccess, NSError *error) {
        
    }];
    self.timer = [TimerWeakTarget scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
}

- (void)timeDown
{
    self.timeCount--;
    [self.codeButton setTitle:[NSString stringWithFormat:@"%ds",self.timeCount] forState:UIControlStateNormal];
    if (self.timeCount <= 0) {
        self.codeButton.enabled = YES;
        self.voiceCodeButton.hidden = NO;
        [self.timer invalidate];
        self.timer = nil;
        [self.codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.codeButton setTitleColor:kHXBFontColor_FB9561_100 forState:(UIControlStateNormal)];
    }
    
}
- (HXBCustomTextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[HXBCustomTextField alloc] init];
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.isHidenLine = NO;
        _codeTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _codeTextField.isHiddenLeftImage = YES;
        _codeTextField.isGetCode = YES;
        _codeTextField.textColor = kHXBFontColor_555555_100;
        _codeTextField.font = kHXBFont_PINGFANGSC_REGULAR(15);
        _codeTextField.limitStringLength = 6;
        kWeakSelf
        _codeTextField.block = ^(NSString *text1) {
            weakSelf.signInButton.enabled = text1.length;
        };
    }
    return _codeTextField;
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
        
        [_voiceCodeButton addTarget:self action:@selector(getVoiceCode) forControlEvents:(UIControlEventTouchUpInside)];
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
        _phoneNumberLabel.text = [NSString stringWithFormat:@"验证码已经发送发到%@",[self.viewModel.phoneNumber hxb_hiddenPhonNumberWithMid]];
        _phoneNumberLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
        _phoneNumberLabel.textColor = kHXBFontColor_555555_100;
    }
    return _phoneNumberLabel;
}

- (HXBCheckCaptcha *)captchaView {
    if (!_captchaView) {
        kWeakSelf
        _captchaView = [[HXBCheckCaptcha alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _captchaView.cancelBlock = ^{
            [weakSelf.captchaView removeFromSuperview];
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

- (void)dealloc {
    [self.timer invalidate];
}
@end
