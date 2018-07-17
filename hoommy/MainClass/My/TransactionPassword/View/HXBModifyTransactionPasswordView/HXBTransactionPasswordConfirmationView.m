//
//  HXBTransactionPasswordConfirmationView.m
//  修改交易密码
//
//  Created by HXB-C on 2017/6/8.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBTransactionPasswordConfirmationView.h"
#import "HBAlertPasswordView.h"
@interface HXBTransactionPasswordConfirmationView ()<HBAlertPasswordViewDelegate>

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *subTipLabel;
@property (nonatomic, strong) UIButton *checkButton;
/**
 输入密码框
 */
@property (nonatomic, strong) HBAlertPasswordView *passwordView;

@property (nonatomic, copy) NSString *passwordText;


@end

@implementation HXBTransactionPasswordConfirmationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
        [self setupSubViewFrame];
    }
    return self;
}

- (void)setupSubViewFrame
{
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(kScrAdaptationH(60));
        make.height.offset(kScrAdaptationH(34));
    }];
    
    [self.subTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(kScrAdaptationH(20));
        make.height.offset(kScrAdaptationH(18));
    }];
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.subTipLabel.mas_bottom).offset(kScrAdaptationH(30));
        make.height.offset(kScrAdaptationH(50));
        make.width.offset(kScrAdaptationH(305));
    }];
    
    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordView.mas_bottom).offset(kScrAdaptationH(60));
        make.height.mas_equalTo(kScrAdaptationH(41));
        make.left.equalTo(self).offset(kScrAdaptationW(25));
        make.right.equalTo(self).offset(-kScrAdaptationW(25));
    }];
}

/**
 设置子试图
 */
- (void)setup
{
    [self addSubview:self.tipLabel];
    [self addSubview:self.subTipLabel];
    [self addSubview:self.passwordView];
    [self addSubview:self.checkButton];
}

- (void)checkButtonAct:(UIButton*)button {
    if(self.confirmChangeButtonClickBlock) {
        self.confirmChangeButtonClickBlock(self.passwordText);
    }
}

#pragma mark - HBAlertPasswordViewDelegate
- (void)sureActionWithAlertPasswordView:(HBAlertPasswordView *)alertPasswordView password:(NSString *)password
{
    if (password.length == 6) {
        self.passwordText = password;
        self.checkButton.enabled = YES;
    }
    else{
        self.checkButton.enabled = NO;;
    }
}

#pragma mark - get方法（懒加载）
- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"修改密码";
        _tipLabel.font = kHXBFont_24;
        _tipLabel.textColor = kHXBFontColor_2D2F46_100;
    }
    return _tipLabel;
}

- (UILabel *)subTipLabel {
    if (!_subTipLabel) {
        _subTipLabel = [[UILabel alloc] init];
        _subTipLabel.text = @"请设置新的六位交易密码";
        _subTipLabel.font = kHXBFont_14;
        _subTipLabel.textColor = kHXBFontColor_9295A2_100;
    }
    return _subTipLabel;
}

- (HBAlertPasswordView *)passwordView
{
    if (!_passwordView) {
        _passwordView = [[HBAlertPasswordView alloc] initWithFrame:CGRectMake(0, 0, kScrAdaptationW(305), kScrAdaptationH(50))];
        _passwordView.delegate = self;
    }
    return _passwordView;
}

- (UIButton *)checkButton {
    if(!_checkButton) {
        _checkButton = [[UIButton alloc] init];
        _checkButton.layer.cornerRadius = 2;
        _checkButton.enabled = NO;
        _checkButton.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(15);
        [_checkButton setTitle:@"确定" forState:UIControlStateNormal];
        [_checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _checkButton.backgroundColor = kHXBColor_FE7E5E_100;
        [_checkButton addTarget:self action:@selector(checkButtonAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _checkButton;
}

@end
