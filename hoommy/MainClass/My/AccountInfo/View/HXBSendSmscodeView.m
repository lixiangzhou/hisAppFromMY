//
//  HXBSendSmscodeView.m
//  hoomxb
//
//  Created by HXB on 2017/6/3.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBSendSmscodeView.h"

#import "HXBCustomTextField.h"
#import "HXBFinBaseNegotiateView.h"
#import "HXBNsTimerManager.h"

static NSString *const kSmscode_ConstLableTitle = @"请输入短信验证码";
static NSString *const kPassword_constLableTitle = @"密码为8-20位数字与字母组合";
static NSString *const kSetPassWordButtonTitle = @"确认设置登录密码";
static NSString *const kSendSmscodeAgainTitle = @"语音验证码";
static NSString *const kSendSmscodeTitle = @"获取验证码";

@interface HXBSendSmscodeView () <UITextFieldDelegate>
/// 倒计时秒数
@property (nonatomic, assign) NSInteger totalTimeNumber;
///展示手机号的label
@property (nonatomic, strong) UILabel       *phonNumberLabel;

@property (nonatomic,strong) UILabel *phone_TextField_title;
///手机号
@property (nonatomic, strong) HXBCustomTextField   *phone_TextField;

@property (nonatomic,strong) UILabel *smscode_TextField_title;
///验证码的textField
@property (nonatomic, strong) HXBCustomTextField   *smscode_TextField;
///发送按钮
@property (nonatomic, strong) UIButton      *sendButton;

///定时器
@property (nonatomic, strong) HXBNsTimerManager       *timer;
@property (nonatomic,strong) UILabel *password_TextField_title;
///密码输入框
@property (nonatomic, strong) HXBCustomTextField   *password_TextField;

///确认设置密码按钮
@property (nonatomic, strong) UIButton      *setPassWordButton;

@property (nonatomic, strong) HXBCustomTextField *inviteCodeTextField;
@property (nonatomic, assign) BOOL isSelect;
/**
 用户协议
 */
@property (nonatomic, strong) HXBFinBaseNegotiateView *negotiateView;
//@property (nonatomic,strong) UIButton *negotiateButton;
/// 密码是否合格 （字符，数字不能有特殊字符）
@property (nonatomic, assign) BOOL isPasswordQualified;
///点击了确认
@property (nonatomic, copy) void(^clickSetPassWordButtonBlock)(NSString *password, NSString *smscode,NSString *inviteCode);
///点击了发送短信验证码按钮
@property (nonatomic, copy) void(^clickSendSmscodeButtonBlock)();
///点击了服务协议
@property (nonatomic, copy) void(^clickAgreementSignUPBlock)();


@end

@implementation HXBSendSmscodeView

- (void)setType:(HXBSignUPAndLoginRequest_sendSmscodeType)type {
    _type = type;
    switch (type) {
        case HXBSignUPAndLoginRequest_sendSmscodeType_forgot:
        {
            [self.inviteCodeTextField setHidden:YES];
            [self.negotiateView setHidden:YES];
            [self.setPassWordButton setTitle:@"确认重置密码" forState:UIControlStateNormal];
            [self.setPassWordButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.password_TextField.mas_bottom).offset(kScrAdaptationH(50));
                make.left.equalTo(self).offset(kScrAdaptationW(20));
                make.right.equalTo(self).offset(kScrAdaptationW(-20));
                make.height.offset(kScrAdaptationH(41));
            }];
        }
            break;
        case HXBSignUPAndLoginRequest_sendSmscodeType_signup:
        {
            [self.setPassWordButton setTitle:@"注册" forState:UIControlStateNormal];
            [self.setPassWordButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.inviteCodeTextField.mas_bottom).offset(kScrAdaptationH(50));
                make.left.equalTo(self).offset(kScrAdaptationW(20));
                make.right.equalTo(self).offset(kScrAdaptationW(-20));
                make.height.offset(kScrAdaptationH(41));
            }];
            [self.negotiateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.setPassWordButton.mas_bottom).offset(kScrAdaptationH(10));
                make.left.right.equalTo(self).offset(kScrAdaptationW(65));
                make.right.equalTo(self).offset(kScrAdaptationW(-80));
                make.height.offset(kScrAdaptationH(14));
            }];
        }
            break;
        default:
            break;
    }
}

- (void)setIsSendSpeechCode:(BOOL)isSendSpeechCode {
    
    self.phonNumberLabel.text = @"请验证手机后设置新密码";
    
//    _isSendSpeechCode = isSendSpeechCode;
//    NSString *str = [NSString hiddenStr:_phonNumber MidWithFistLenth:3 andLastLenth:4];
//    NSString *string = _isSendSpeechCode ? [NSString stringWithFormat:@"请留意接听%@上的来电",str] : [NSString stringWithFormat:@"已向手机%@发送短信",str];
//    self.phonNumberLabel.attributedText = [self transferString:string str:str];
}

- (NSMutableAttributedString *)transferString:(NSString *)string str:(NSString *)str {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    // 设置字体和设置字体的范围
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:RGB(253, 54, 54)
                    range:[string rangeOfString:str]];
    return attrStr;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUP];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setStartsCountdown) name:kHXBNotification_registrationStartCountdown object:nil];
        self.totalTimeNumber = 60;
    }
    return self;
}

- (void)dealloc
{
    [self deleteTimer];
}
//- (void)setStartsCountdown{
//    _startsCountdown = YES;
//}
- (void)setUP {
    [self creatSubView];
    [self layoutSubView_sendSmscode];
    [self setSubView];
    [self addButtonTarget];
}

- (void)didMoveToSuperview {
    [self clickSendButton:self.sendButton];
}

- (HXBNsTimerManager *) timer {
    if (!_timer) {
        kWeakSelf
        _timer = [HXBNsTimerManager createTimer:1 startSeconds:self.totalTimeNumber countDownTime:YES notifyCall:^(NSString *times) {
            [weakSelf addTime:times];
        }];
    }
    return _timer;
}

///创建对象
- (void)creatSubView {
    self.phonNumberLabel = [[UILabel alloc]init];
    self.phone_TextField = [[HXBCustomTextField alloc]init];
    self.smscode_TextField = [[HXBCustomTextField alloc]init];
    
    self.phone_TextField.number = 1;
    self.phone_TextField.userInteractionEnabled = NO;
    self.smscode_TextField.isGetCode = YES;
    self.smscode_TextField.number = 2;
    _isSelect = YES;
    self.sendButton = [[UIButton alloc]init];
    self.password_TextField = [[HXBCustomTextField alloc]init];
    self.password_TextField.number = 3;
    self.setPassWordButton = [[UIButton alloc]init];
    self.inviteCodeTextField = [[HXBCustomTextField alloc]init];
    self.inviteCodeTextField.number = 4;
    self.negotiateView = [[HXBFinBaseNegotiateView alloc]init];
//    self.phone_TextField.leftImage = [UIImage imageNamed:@"security_code"];
//    self.smscode_TextField.leftImage = [UIImage imageNamed:@"security_code"];
//    self.password_TextField.leftImage = [UIImage imageNamed:@"password"];
//    self.inviteCodeTextField.leftImage = [UIImage imageNamed:@"invitation_code"];
    self.password_TextField.secureTextEntry = YES;
    self.password_TextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.phone_TextField.delegate = self;
    self.smscode_TextField.delegate = self;
    self.password_TextField.delegate = self;
    self.inviteCodeTextField.delegate = self;
    self.phone_TextField.limitStringLength = 11;
    self.smscode_TextField.limitStringLength = 6;
    self.password_TextField.limitStringLength = 20;
    self.inviteCodeTextField.limitStringLength = 1000;
    
    kWeakSelf
    self.phone_TextField.block = ^(NSString *text) {
    };
    self.smscode_TextField.block = ^(NSString *text) {
        if (text.length > 0 && _password_TextField.text.length > 0  && _isSelect) {
            weakSelf.setPassWordButton.backgroundColor = COR29;
            weakSelf.setPassWordButton.userInteractionEnabled = YES;
        } else {
            weakSelf.setPassWordButton.backgroundColor = COR12;
            weakSelf.setPassWordButton.userInteractionEnabled = NO;
        }
    };
    self.password_TextField.block = ^(NSString *text) {
        if (text.length > 0 && _smscode_TextField.text.length > 0 && _isSelect) {
            weakSelf.setPassWordButton.backgroundColor = COR29;
            weakSelf.setPassWordButton.userInteractionEnabled = YES;
        } else {
            weakSelf.setPassWordButton.backgroundColor = COR12;
            weakSelf.setPassWordButton.userInteractionEnabled = NO;
        }
    };
    self.inviteCodeTextField.block = ^(NSString *text) {
    };
    
    [self addSubview : self.phonNumberLabel];
    [self addSubview : self.phone_TextField];
    [self.phone_TextField addSubview : self.phone_TextField_title];
    [self addSubview : self.smscode_TextField];
    [self.smscode_TextField addSubview : self.smscode_TextField_title];
    [self addSubview : self.password_TextField];
    [self.password_TextField addSubview : self.password_TextField_title];
    [self addSubview : self.sendButton];
    [self addSubview : self.setPassWordButton];
    [self addSubview : self.inviteCodeTextField];
    [self addSubview : self.negotiateView];
   
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    self.password_TextField.placeholder = @"密码为8-20位数字与字母组合";
    self.inviteCodeTextField.placeholder = @"请输入邀请码（选填）";
    self.inviteCodeTextField.keyboardType = UIKeyboardTypeASCIICapable;

    self.negotiateView.negotiateStr = @"红小宝注册协议";
    [self.negotiateView clickNegotiateWithBlock:^{
        NSLog(@"点击了红小宝注册协议");
        if (weakSelf.clickAgreementSignUPBlock) weakSelf.clickAgreementSignUPBlock();
    }];
    [self.negotiateView clickCheckMarkWithBlock:^(BOOL isSelected) {
        [weakSelf clickCheckMarkDeal:isSelected];
    }];
}

- (void)clickCheckMarkDeal:(BOOL)isSelected
{
    _isSelect = isSelected;
    if (isSelected) {
        if (_password_TextField.text.length > 0 && _smscode_TextField.text.length > 0) {
            self.setPassWordButton.backgroundColor = COR29;
            self.setPassWordButton.userInteractionEnabled = YES;
        } else {
            self.setPassWordButton.backgroundColor = COR12;
            self.setPassWordButton.userInteractionEnabled = NO;
        }
    } else {
        self.setPassWordButton.userInteractionEnabled = NO;
        self.setPassWordButton.backgroundColor = kHXBColor_Font0_5;
        [self.setPassWordButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    }
}

- (void)layoutSubView_sendSmscode {
    kWeakSelf
    [self.phonNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kScrAdaptationH(15));
        make.centerX.equalTo(weakSelf);
    }];
    
    [self.phone_TextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.phonNumberLabel.mas_bottom).offset(kScrAdaptationH(33));
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.offset(kScrAdaptationH(60));
    }];
    [self.phone_TextField_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.phone_TextField);
        make.left.equalTo(weakSelf.phone_TextField.leftImageView);
        make.height.equalTo(weakSelf.phone_TextField.textField);
        make.width.equalTo(@kScrAdaptationW(46));
    }];
    [self.phone_TextField.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.phone_TextField_title.mas_right).offset(kScrAdaptationW(29));
    }];
    [self.smscode_TextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.phone_TextField.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.offset(kScrAdaptationH(60));
    }];
    [self.smscode_TextField_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.smscode_TextField);
        make.left.equalTo(weakSelf.smscode_TextField.leftImageView);
        make.height.equalTo(weakSelf.smscode_TextField.textField);
        make.width.equalTo(@kScrAdaptationW(46));
    }];
    [self.smscode_TextField.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.smscode_TextField_title.mas_right).offset(kScrAdaptationW(29));
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.smscode_TextField);
        make.right.equalTo(weakSelf).offset(kScrAdaptationW(-20));
        make.width.equalTo(@(kScrAdaptationW(80)));
        make.height.equalTo(@(kScrAdaptationH(30)));
    }];
    
    [self.password_TextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.smscode_TextField.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.offset(kScrAdaptationH(60));
    }];
    [self.password_TextField_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.password_TextField);
        make.left.equalTo(weakSelf.password_TextField.leftImageView);
        make.height.equalTo(weakSelf.password_TextField.textField);
        make.width.equalTo(@kScrAdaptationW(46));
    }];
    [self.password_TextField.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.password_TextField_title.mas_right).offset(kScrAdaptationW(29));
    }];
    [self.inviteCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.password_TextField.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.offset(kScrAdaptationH(60));
    }];
}

- (void)setPhonNumber:(NSString *)phonNumber{
    _phonNumber = phonNumber;
    self.phone_TextField.text = _phonNumber;
}

///设置
- (void)setSubView {
    self.phone_TextField.delegate = self;
    self.password_TextField.delegate = self;
    self.password_TextField.secureTextEntry = YES;
    
    self.phone_TextField.font = kHXBFont_PINGFANGSC_REGULAR(14);
    self.phone_TextField.textColor = RGB(45, 47, 70);
    
    self.phonNumberLabel.font = kHXBFont_PINGFANGSC_REGULAR(12);
    self.phonNumberLabel.textColor = RGB(85, 85, 85);
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:kSmscode_ConstLableTitle];
    // 设置字体和设置字体的范围
    self.smscode_TextField.delegate = self;
    self.smscode_TextField.keyboardType = UIKeyboardTypeNumberPad;
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:COR10
                    range:NSMakeRange(0, kSmscode_ConstLableTitle.length)];
    self.smscode_TextField.attributedPlaceholder = attrStr;
    
    
    NSMutableAttributedString *passwordattrStr = [[NSMutableAttributedString alloc] initWithString:kPassword_constLableTitle];
    // 设置字体和设置字体的范围
    [passwordattrStr addAttribute:NSForegroundColorAttributeName
                    value:COR10
                    range:NSMakeRange(0, kPassword_constLableTitle.length)];
    self.password_TextField.attributedPlaceholder = passwordattrStr;
    
    self.sendButton.backgroundColor = RGB(222, 222, 222);
    self.sendButton.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(15);
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendButton.layer.cornerRadius = kScrAdaptationW(4);
    self.sendButton.layer.masksToBounds = YES;

    self.setPassWordButton.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(16);
    [self.setPassWordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.setPassWordButton.backgroundColor = COR12;
    self.setPassWordButton.userInteractionEnabled = NO;
    self.setPassWordButton.layer.cornerRadius = kScrAdaptationW(4);
    self.setPassWordButton.layer.masksToBounds = YES;
}


///事件
- (void) addButtonTarget {
    [self.sendButton addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.setPassWordButton addTarget:self action:@selector(clickSetPassWordButton:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setStartsCountdown:(BOOL)startsCountdown{
    _startsCountdown = startsCountdown;
    if (_startsCountdown) {
        [self setSendButtonStatus];
        self.sendButton.backgroundColor = RGB(222, 222, 222);
    } else {
        NSString *btnTitle = _type == HXBSignUPAndLoginRequest_sendSmscodeType_forgot ? kSendSmscodeTitle : kSendSmscodeAgainTitle;
        [self.sendButton setTitle:btnTitle forState:UIControlStateNormal];
        [self.sendButton setBackgroundColor:[UIColor whiteColor]];
        [self.sendButton setTitleColor:COR29 forState:(UIControlStateNormal)];
//        self.sendButton.layer.borderWidth = kXYBorderWidth;
//        self.sendButton.layer.borderColor = COR29.CGColor;
        [self deleteTimer];
        self.sendButton.userInteractionEnabled = YES;
        _startsCountdown = NO;
    }
}
///点击了验证码按钮
- (void)clickSendButton: (UIButton *)button {

    if (self.clickSendSmscodeButtonBlock)
        self.clickSendSmscodeButtonBlock();
}

- (void) setSendButtonStatus {
    self.sendButton.userInteractionEnabled = NO;
    [self.timer startTimer];
}

///点击了确定设置按钮
- (void)clickSetPassWordButton: (UIButton *)button {
//    [HXBUmengManagar HXB_clickEventWithEnevtId:kHXBUmeng_registSuccess];
    if (self.smscode_TextField.text.length == 0) {
        [HxbHUDProgress showTextWithMessage:@"请输入短信验证码"];
    } else if (self.smscode_TextField.text.length != 6) {
        [HxbHUDProgress showTextWithMessage:@"请输入正确的验证码"];
    } else {
        if ([self isPasswordQualifiedFunWithStr:self.password_TextField.text]) {
            if (self.type == HXBSignUPAndLoginRequest_sendSmscodeType_forgot) {
                //合格 请求数据
                if (self.clickSetPassWordButtonBlock) {
                    self.clickSetPassWordButtonBlock(self.password_TextField.text,self.smscode_TextField.text,self.inviteCodeTextField.text);
                }
            } else {
                //合格 请求数据
                if (self.clickSetPassWordButtonBlock)
                    self.clickSetPassWordButtonBlock(self.password_TextField.text,self.smscode_TextField.text,self.inviteCodeTextField.text);
            }
        } else {
            NSString * message = [NSString isOrNoPasswordStyle:self.password_TextField.text];
            [HxbHUDProgress showTextWithMessage:message];
            NSLog(@"🌶密码不合格");
        }
    }
}

- (void)addTime:(NSString*)times {
    [self.sendButton setTitle:[NSString stringWithFormat:@"%@s",times] forState:UIControlStateNormal];
//    [self.sendButton setTitle:times forState:UIControlStateNormal];
    
    if (times.intValue <= 0) {
        NSString *btnTitle = _type == HXBSignUPAndLoginRequest_sendSmscodeType_forgot ? kSendSmscodeTitle : kSendSmscodeAgainTitle;
        [self.sendButton setTitle:btnTitle forState:UIControlStateNormal];
        [self.sendButton setBackgroundColor:[UIColor whiteColor]];
        [self.sendButton setTitleColor:COR29 forState:(UIControlStateNormal)];
//        self.sendButton.layer.borderWidth = kXYBorderWidth;
//        self.sendButton.layer.borderColor = COR29.CGColor;
        [self deleteTimer];
        self.sendButton.userInteractionEnabled = YES;
        _startsCountdown = NO;
    } else {
        [self.sendButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.sendButton.layer.borderWidth = 0;
    }
}
///销毁定时器
- (void)deleteTimer {
    if (_timer) {
        [self.timer stopTimer];
        _startsCountdown = NO;
        self.timer = nil;
    }
}

#pragma mark - textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.type == HXBSignUPAndLoginRequest_sendSmscodeType_forgot) {
    } else {
        if (kScreenWidth == 320 ) {
            [UIView animateWithDuration:0.4 animations:^{
                self.y = -75;
            }];
        } else {
            if (textField.superview == _inviteCodeTextField) {
                [UIView animateWithDuration:0.4 animations:^{
                    self.y = -45;
                }];
            }
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (kScreenWidth == 320) {
        [UIView animateWithDuration:0.4 animations:^{
            self.y = 0;
        }];
    } else {
        if (textField.superview == _inviteCodeTextField) {
            [UIView animateWithDuration:0.4 animations:^{
                self.y = 0;
            }];
        }
    }
}
- (BOOL)isPasswordQualifiedFunWithStr: (NSString *)password {
    ///判断字符串是否包含数字
    BOOL isContentNumber = [NSString isStringContainNumberWith:password];
    ///判断是否有中文字符
    BOOL isContentChiness = [NSString isChinese:password];
    ///判断字符串是否包含特殊字符
    BOOL isContentSpecialCharact = [NSString isIncludeSpecialCharact:password];
    ///判断是否有字母
    BOOL isContentCar = [NSString isStringCOntainStringWith:password];
    
    return isContentNumber && (!isContentChiness) && (!isContentSpecialCharact) && isContentCar;
}

///点击了确认设置密码按钮
- (void)clickSetPassWordButtonFunc:(void (^)(NSString *password, NSString *smscode,NSString *inviteCode))clickSetPassWordButtonBlock {
    self.clickSetPassWordButtonBlock = clickSetPassWordButtonBlock;
}

///点击了发送短信验证码按钮
- (void)clickSendSmscodeButtonWithBlock: (void(^)())clickSendSmscodeButtonBlock {
    self.clickSendSmscodeButtonBlock = clickSendSmscodeButtonBlock;
}

///点击了服务协议
- (void)clickAgreementSignUPWithBlock:(void (^)())clickAgreementSignUPBlock {
    self.clickAgreementSignUPBlock = clickAgreementSignUPBlock;
}
- (UILabel *)phone_TextField_title {
    if (!_phone_TextField_title) {
        _phone_TextField_title = [[UILabel alloc] init];
        _phone_TextField_title.textColor = COR5;
        _phone_TextField_title.font = kHXBFont_PINGFANGSC_REGULAR(14);
        _phone_TextField_title.text = @"手机号";
    }
    return _phone_TextField_title;
}
- (UILabel *)smscode_TextField_title {
    if (!_smscode_TextField_title) {
        _smscode_TextField_title = [[UILabel alloc] init];
        _smscode_TextField_title.textColor = COR5;
        _smscode_TextField_title.font = kHXBFont_PINGFANGSC_REGULAR(14);
        _smscode_TextField_title.text = @"验证码";
    }
    return _smscode_TextField_title;
}
- (UILabel *)password_TextField_title {
    if (!_password_TextField_title) {
        _password_TextField_title = [[UILabel alloc] init];
        _password_TextField_title.textColor = COR5;
        _password_TextField_title.font = kHXBFont_PINGFANGSC_REGULAR(14);
        _password_TextField_title.text = @"新密码";
    }
    return _password_TextField_title;
}

#pragma make UITextFieldDelegate

@end
