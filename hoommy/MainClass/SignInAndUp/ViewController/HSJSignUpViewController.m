//
//  HSJSignUpViewController.m
//  hoommy
//
//  Created by HXB-C on 2018/7/9.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJSignUpViewController.h"
#import "HXBCustomTextField.h"
#import "HXBAgreementView.h"
#import "HSJSignInButton.h"
#import "TimerWeakTarget.h"
#import "NSAttributedString+HxbAttributedString.h"
#import "HSJSignupViewModel.h"
#import "HXBGeneralAlertVC.h"
#import "HSJCheckCaptcha.h"
#import "HXBBaseWKWebViewController.h"

@interface HSJSignUpViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) HXBCustomTextField *codeTextField;

@property (nonatomic, strong) HXBCustomTextField *passwordTextField;

@property (nonatomic, strong) HSJSignInButton *signUpButton;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) HXBAgreementView *agreementView;

@property (nonatomic, strong) UIButton *codeButton;

@property (nonatomic, strong) UIButton *voiceCodeButton;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, assign) int timeCount;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) HSJSignupViewModel *viewModel;

@property (nonatomic, strong) HSJCheckCaptcha *captchaView;

@property (nonatomic, copy) NSString *captcha;

@end

@implementation HSJSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSelected = YES;
    self.viewModel = [[HSJSignupViewModel alloc] init];
    [self setupUI];
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getCode];
}

- (void)setupUI {
    self.isWhiteColourGradientNavigationBar = YES;
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:self.codeTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.signUpButton];
    [self.view addSubview:self.agreementView];
    [self.view addSubview:self.codeButton];
    [self.view addSubview:self.voiceCodeButton];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kScrAdaptationW(25));
        make.top.equalTo(self.view).offset(kScrAdaptationH(30) + HXBStatusBarAndNavigationBarHeight);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kScrAdaptationH(5));
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kScrAdaptationH(80));
        make.left.equalTo(self.view).offset(kScrAdaptationW(25));
        make.right.equalTo(self.view).offset(-kScrAdaptationW(25));
        make.height.offset(kScrAdaptationH(40));
    }];
    
    [self.codeButton sizeToFit];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.height.equalTo(self.codeTextField);
        make.width.mas_equalTo(self.codeButton.size.width);
    }];
    
    [self.voiceCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.codeTextField);
        make.top.equalTo(self.codeTextField.mas_bottom).offset(kScrAdaptationH(10));
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.codeTextField);
        make.top.equalTo(self.voiceCodeButton.mas_bottom).offset(kScrAdaptationH(25));
        make.height.offset(kScrAdaptationH(40));
    }];
    

    
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.codeTextField);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(kScrAdaptationH(60));
        make.height.offset(kScrAdaptationH(41));
    }];
    
    [self.agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.codeTextField);
        make.height.equalTo(@14);
        make.top.equalTo(self.signUpButton.mas_bottom).offset(kScrAdaptationH(20));
    }];
}

-(void)signUpButtonClick {
    [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_SignUpButtonClick];
    kWeakSelf
    [self.viewModel signUPRequetWithMobile:self.phoneNumber smscode:self.codeTextField.text password:self.passwordTextField.text resultBlock:^(id responseData, NSError *erro) {
        if (responseData) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)getVoiceCode {
    [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_SignUpVoiceCodeButtonClick];
    HXBGeneralAlertVC *alertVC = [[HXBGeneralAlertVC alloc] initWithMessageTitle:@"获取语音验证码" andSubTitle:@"我们将以电话形式告知验证码，请您注意接听" andLeftBtnName:@"暂不接听" andRightBtnName:@"现在接听" isHideCancelBtn:NO isClickedBackgroundDiss:NO];
    [self presentViewController:alertVC animated:NO completion:nil];
    kWeakSelf
    [alertVC setLeftBtnBlock:^{
        
    }];
    [alertVC setRightBtnBlock:^{
        [weakSelf getVoiceCodeWithType:@"voice"];//获取语音验证码
    }];
}

- (void) checkCaptcha{
    kWeakSelf
    [self.viewModel checkCaptchaRequestWithCaptcha:self.captcha resultBlock:^(BOOL isSuccess, BOOL needDownload) {
        if (isSuccess) {
            [weakSelf getCode];
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
    [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_SignUpGetCodeButtonClick];
    [self getVoiceCodeWithType:@"sms"];
}

- (void)getVoiceCodeWithType:(NSString *)type {

    kWeakSelf
    [self.viewModel getVerifyCodeRequesWithSignupWithAction:@"newsignup" andWithType:type andWithMobile:self.phoneNumber andWithCaptcha:self.captcha andCallbackBlock:^(BOOL isSuccess, BOOL isNeedCaptcha) {
        if (isNeedCaptcha) {
            
            [weakSelf.view addSubview:weakSelf.captchaView];
            weakSelf.captchaView.isFirstResponder = YES;
            [weakSelf getCaptcha];
            [weakSelf getCodeField];
            
        } else if (isSuccess) {
            
            weakSelf.timeCount = 60;
            weakSelf.codeButton.enabled = NO;
            weakSelf.voiceCodeButton.hidden = YES;
            [weakSelf.codeButton setTitle:[NSString stringWithFormat:@"%ds",self.timeCount] forState:UIControlStateNormal];
            [weakSelf.codeButton setTitleColor:kHXBFontColor_C7C7CD_100 forState:(UIControlStateNormal)];
            weakSelf.timer = [TimerWeakTarget scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
            
        } else {
            [weakSelf getCodeField];
        }
    }];
    
}



- (void)timeDown
{
    self.timeCount--;
    [self.codeButton setTitle:[NSString stringWithFormat:@"%ds",self.timeCount] forState:UIControlStateNormal];
    if (self.timeCount <= 0) {
        [self getCodeField];
    }
}

- (void)getCodeField {
    self.codeButton.enabled = YES;
    self.voiceCodeButton.hidden = NO;
    self.captcha = @"";
    [self.timer invalidate];
    self.timer = nil;
    [self.codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
    [self.codeButton setTitleColor:kHXBFontColor_FB9561_100 forState:(UIControlStateNormal)];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.codeTextField.textField == textField) {
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_SignUpCodeTextFieldClick];
    } else if (self.passwordTextField.textField == textField) {
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_SignUpPasswordTextFieldClick];
    }
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.text = [NSString stringWithFormat:@"验证码已发送至%@",[self.phoneNumber hxb_hiddenPhonNumberWithMid]];
        _phoneLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
        _phoneLabel.textColor = kHXBFontColor_555555_100;
    }
    return _phoneLabel;
}

- (HXBCustomTextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[HXBCustomTextField alloc] init];
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.isHidenLine = NO;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.isHiddenLeftImage = YES;
        _codeTextField.limitStringLength = 6;
        _codeTextField.isGetCode = YES;
        _codeTextField.bottomLineEditingColor = kHXBSpacingColor_F5F5F9_100;
        _codeTextField.bottomLineNormalColor = kHXBSpacingColor_F5F5F9_100;
        _codeTextField.delegate = self;
        kWeakSelf
        _codeTextField.block = ^(NSString *text1) {
            if (weakSelf.isSelected && weakSelf.codeTextField.text.length && weakSelf.passwordTextField.text.length) {
                
                weakSelf.signUpButton.enabled = YES;
            }
            else
            {
                weakSelf.signUpButton.enabled = NO;
            }
        };
        
    }
    return _codeTextField;
}


- (HXBCustomTextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[HXBCustomTextField alloc] init];
        _passwordTextField.placeholder = @"请设置8-20位数字+字母组合的密码";
        _passwordTextField.isHidenLine = NO;
        _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.isHiddenLeftImage = YES;
        _passwordTextField.limitStringLength = 20;
        _passwordTextField.textColor = kHXBFontColor_555555_100;
        _passwordTextField.bottomLineEditingColor = kHXBSpacingColor_F5F5F9_100;
        _passwordTextField.bottomLineNormalColor = kHXBSpacingColor_F5F5F9_100;
        kWeakSelf
        _passwordTextField.block = ^(NSString *text1) {
            if (weakSelf.isSelected && weakSelf.codeTextField.text.length && weakSelf.passwordTextField.text.length) {
                
                weakSelf.signUpButton.enabled = YES;
            }
            else
            {
                weakSelf.signUpButton.enabled = NO;
            }
        };
    }
    return _passwordTextField;
}

- (HSJSignInButton *)signUpButton {
    if (!_signUpButton) {
        _signUpButton = [[HSJSignInButton alloc] init];
        [_signUpButton addTarget:self action:@selector(signUpButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_signUpButton setTitle:@"完成注册" forState:(UIControlStateNormal)];
    }
    return _signUpButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"请输入验证码";
        _titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(30);
        _titleLabel.textColor = kHXBFontColor_505050_100;
    }
    return _titleLabel;
}

- (HXBAgreementView *)agreementView {
    if (!_agreementView) {
        _agreementView = [[HXBAgreementView alloc] initWithFrame:CGRectZero];
        
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"我已阅读并同意《红小宝注册服务协议》"];
        
        NSDictionary *linkAttributes = @{NSForegroundColorAttributeName:kHXBColor_73ADFF_100, NSFontAttributeName:kHXBFont_PINGFANGSC_REGULAR(12)};
        
        kWeakSelf
        NSMutableAttributedString *attributedString = [HXBAgreementView configureLinkAttributedString:attString withString:@"《红小宝注册服务协议》" sameStringEnable:NO linkAttributes:linkAttributes activeLinkAttributes:linkAttributes parameter:nil clickLinkBlock:^{
            NSLog(@"《红小宝认证服务协议》");
            HXBBaseWKWebViewController *vc = [[HXBBaseWKWebViewController alloc] init];
            vc.pageUrl = [NSString splicingH5hostWithURL:kHXB_Negotiate_SginUPURL];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        _agreementView.text = attributedString;
        _agreementView.agreeBtnBlock = ^(BOOL isSelected){
            weakSelf.isSelected = isSelected;
            if (isSelected && weakSelf.codeTextField.text.length && weakSelf.passwordTextField.text.length) {
                
                weakSelf.signUpButton.enabled = YES;
            }
            else
            {
                weakSelf.signUpButton.enabled = NO;
            }
        };
    }
    return _agreementView;
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

- (HSJCheckCaptcha *)captchaView {
    if (!_captchaView) {
        kWeakSelf
        _captchaView = [[HSJCheckCaptcha alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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

@end
