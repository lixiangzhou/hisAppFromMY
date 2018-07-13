//
//  HXBVerificationCodeAlertView.m
//  hoomxb
//
//  Created by HXB-C on 2017/7/14.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBVerificationCodeAlertView.h"
#import "HXBNsTimerManager.h"

@interface HXBVerificationCodeAlertView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *codeBtn;

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UILabel *speechVerificationCodeLab;
@property (nonatomic, strong) UIButton *speechVerificationCodeBtn;

@property (nonatomic, assign) int count;

@property (nonatomic, strong) HXBNsTimerManager *timer;
@end


@implementation HXBVerificationCodeAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.textField];
        [self addSubview:self.codeBtn];
        [self addSubview:self.line];
        [self addSubview:self.verticalLine];
        [self addSubview:self.speechVerificationCodeLab];
        [self addSubview:self.speechVerificationCodeBtn];
        [self setupSubViewFrame];
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self getVerificationCode];
    }
    return self;
}

- (void)setIsCleanSmsCode:(BOOL)isCleanSmsCode {
    _isCleanSmsCode = isCleanSmsCode;
    if (_isCleanSmsCode) {
        _textField.text = @"";
    } else {
        
    }
}

-(void)setIsSpeechVerificationCode:(BOOL)isSpeechVerificationCode{
    _isSpeechVerificationCode = isSpeechVerificationCode;
    self.speechVerificationCodeLab.hidden = !isSpeechVerificationCode;
    self.speechVerificationCodeBtn.hidden = !isSpeechVerificationCode;
    kWeakSelf
    if (_isSpeechVerificationCode) {
        [self.speechVerificationCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.line.mas_bottom).offset(kScrAdaptationH(30));
            make.left.equalTo(weakSelf.textField.mas_left);
            make.height.offset(kScrAdaptationH(12.5));
        }];
        [self.speechVerificationCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.line.mas_bottom).offset(kScrAdaptationH(30.5));
            make.left.equalTo(weakSelf.speechVerificationCodeLab.mas_right);
            make.right.equalTo(weakSelf.mas_right);
            make.height.offset(kScrAdaptationH(12));
        }];
    }
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.line.backgroundColor = lineColor;
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    _delegate = delegate;
    self.textField.delegate = delegate;
}

- (void)setupSubViewFrame
{
    kWeakSelf
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self);
        make.top.equalTo(weakSelf.mas_top).offset(kScrAdaptationH750(40));
        make.right.equalTo(weakSelf.mas_right);
        make.width.offset(kScrAdaptationW750(160));
        make.height.offset(kScrAdaptationH750(60));
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.codeBtn);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.codeBtn.mas_left).offset(kScrAdaptationW750(-50));
        make.height.offset(kScrAdaptationH(32));
    }];
    [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.codeBtn.mas_left).offset(kScrAdaptationW750(-31.5));
        make.right.equalTo(weakSelf.codeBtn.mas_left).offset(kScrAdaptationW750(-30));
        make.top.equalTo(weakSelf.textField.mas_top).offset(kScrAdaptationH750(15));
        make.bottom.equalTo(weakSelf.textField.mas_bottom).offset(kScrAdaptationH750(-15));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.textField.mas_left);
        make.right.equalTo(weakSelf.codeBtn.mas_right);
        make.bottom.equalTo(weakSelf.codeBtn.mas_bottom).offset(kScrAdaptationH750(10));
        make.height.equalTo(@kScrAdaptationH750(1.5));;
    }];
}

- (void)enabledBtns{
    self.codeBtn.enabled = YES;
    [self.codeBtn setBackgroundColor:[UIColor whiteColor]];
    [self.codeBtn setTitleColor:COR29 forState:(UIControlStateNormal)];
    [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.speechVerificationCodeBtn.enabled = YES;
    [self.speechVerificationCodeBtn setTitle:@"获取语音验证码" forState:UIControlStateNormal];
    [self.speechVerificationCodeBtn setTitleColor:RGB(45, 121, 243) forState:UIControlStateNormal];
    [self stopTimer];
}

- (void)disEnabledBtns{
    self.speechVerificationCodeBtn.enabled = NO;
    [self.speechVerificationCodeBtn setTitleColor:COR10 forState:UIControlStateNormal];
    self.codeBtn.enabled = NO;
    [self.codeBtn setBackgroundColor:[UIColor whiteColor]];
    [self.codeBtn setTitleColor:COR10 forState:(UIControlStateNormal)];
    self.count = 60;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%ds",self.count] forState:UIControlStateNormal];
    [self.timer startTimer];
}

- (void)stopTimer {
    if(_timer) {
        [self.timer stopTimer];
        self.timer = nil;
    }
}

- (void)getSpeechVerificationCode
{
    [self enabledBtns];
    if (self.getSpeechVerificationCodeBlock) {
        self.getSpeechVerificationCodeBlock();
        NSLog(@"");
    }
}

- (void)getVerificationCode
{
    if (self.isSpeechVerificationCode) {
        self.speechVerificationCodeBtn.enabled = NO;
        [self.speechVerificationCodeBtn setTitleColor:COR10 forState:UIControlStateNormal];
    }
    self.codeBtn.enabled = NO;
    self.count = 60;
    [self.codeBtn setBackgroundColor:[UIColor whiteColor]];
    self.codeBtn.layer.borderWidth = 0;
    [self.codeBtn setTitleColor:COR10 forState:(UIControlStateNormal)];
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%ds",self.count] forState:UIControlStateNormal];
    [self.timer startTimer];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    if (self.getVerificationCodeBlock) {
        self.getVerificationCodeBlock();
    }
}

- (void)timeDown
{
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%ds",self.count] forState:UIControlStateNormal];
    if (!self.timer.isTimerWorking) {
        self.codeBtn.enabled = YES;
        [self.codeBtn setBackgroundColor:[UIColor whiteColor]];
        [self.codeBtn setTitleColor:COR29 forState:(UIControlStateNormal)];
        [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.isSpeechVerificationCode = _isSpeechVerificationCode;
        self.speechVerificationCodeBtn.enabled = YES;
        [_speechVerificationCodeBtn setTitleColor:RGB(45, 121, 243) forState:UIControlStateNormal];
    }
}

- (NSString *)verificationCode
{
    return self.textField.text;
}


#pragma mark - 懒加载

- (HXBNsTimerManager *) timer {
    if (!_timer) {
        kWeakSelf
        _timer = [HXBNsTimerManager createTimer:1 startSeconds:self.count countDownTime:YES notifyCall:^(NSString *times) {
            weakSelf.count = times.intValue;
            [weakSelf timeDown];
        }];
    }
    return _timer;
}

-(UILabel *)speechVerificationCodeLab{
    if (!_speechVerificationCodeLab) {
        _speechVerificationCodeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _speechVerificationCodeLab.textAlignment = NSTextAlignmentLeft;
        _speechVerificationCodeLab.font = kHXBFont_PINGFANGSC_REGULAR(12);
        _speechVerificationCodeLab.textColor = COR10;
        [_speechVerificationCodeLab sizeToFit];
        _speechVerificationCodeLab.text = @"若没有收到短信，可点此";
    }
    return _speechVerificationCodeLab;
}
- (UIButton *)speechVerificationCodeBtn{
    if (!_speechVerificationCodeBtn) {
        _speechVerificationCodeBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        _speechVerificationCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _speechVerificationCodeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _speechVerificationCodeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_speechVerificationCodeBtn setTitle:@"获取语音验证码" forState:UIControlStateNormal];
        [_speechVerificationCodeBtn setTitleColor:COR10 forState:UIControlStateNormal];
        [_speechVerificationCodeBtn.titleLabel setFont:kHXBFont_PINGFANGSC_REGULAR(12)];
        [_speechVerificationCodeBtn addTarget:self action:@selector(getSpeechVerificationCode) forControlEvents:UIControlEventTouchUpInside];//点击 获得语音验证码的事件处理
    }
    return _speechVerificationCodeBtn;
}
- (UIButton *)codeBtn
{
    if (!_codeBtn) {
        _codeBtn = [[UIButton alloc] init];
        _codeBtn.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(28);
        [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:COR29 forState:UIControlStateNormal];
        [_codeBtn addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
        [_codeBtn setBackgroundColor:[UIColor whiteColor]];
    }
    return _codeBtn;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = kHXBFont_PINGFANGSC_REGULAR_750(28);
        _textField.textColor = RGB(51, 51, 51);
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.placeholder = @"验证码";
        [_textField setValue:COR10 forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _textField;
}

- (UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] init];
        _verticalLine.backgroundColor = RGB(221, 221, 221);
    }
    return _verticalLine;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = RGB(221, 221, 221);
    }
    return _line;
}
- (void)dealloc
{
    [self stopTimer];
}


@end
