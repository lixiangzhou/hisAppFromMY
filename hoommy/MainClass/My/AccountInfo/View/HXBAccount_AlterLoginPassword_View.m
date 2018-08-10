//
//  HXBAccount_AlterLoginPassword_View.m
//  hoomxb
//
//  Created by HXB on 2017/6/8.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBAccount_AlterLoginPassword_View.h"
#import "HXBCustomTextField.h"///密码的View

@interface HXBAccount_AlterLoginPassword_View ()<UITextFieldDelegate>
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *password_Original_title;
///原始的密码的textField
@property (nonatomic,strong) HXBCustomTextField *password_Original;
@property (nonatomic,strong) UILabel *password_New_title;
///新密码的textField
@property (nonatomic, strong) HXBCustomTextField *password_New;
/// 忘记密码
@property (nonatomic,strong) UIButton *forgotPasswordButton;
///确认修改密码
@property (nonatomic,strong) UIButton *alterButton;

////点击了确认修改密码
@property (nonatomic,copy) void(^clickAlterButtonBlock)(NSString *password_Original, NSString *password_New);
@end

@implementation HXBAccount_AlterLoginPassword_View
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUPView];
    }
    return self;
}

///设置UI
- (void)setUPView {
    kWeakSelf
    self.lineView = [UIView new];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = RGB(238, 238, 245);
    self.alterButton = [UIButton btnwithTitle:@"确认修改" andTarget:self andAction:@selector(clickAlterButton:) andFrameByCategory:CGRectZero];
    self.alterButton.backgroundColor = kHXBColor_FF7055_40;
    self.alterButton.userInteractionEnabled = NO;
    
    [self addSubview: self.password_Original];
    [self.password_Original addSubview: self.password_Original_title];
    [self addSubview:self.password_New];
    [self.password_New addSubview: self.password_New_title];
    [self addSubview:self.alterButton];
    [self addSubview:self.forgotPasswordButton];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1.0f);
        make.top.left.right.equalTo(weakSelf);
    }];
    
    [self.password_Original mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineView.mas_bottom);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.height.equalTo(@(kScrAdaptationH(60)));
    }];
    [self.password_Original_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.password_Original);
        make.left.equalTo(weakSelf.password_Original.leftImageView);
        make.height.equalTo(weakSelf.password_Original.textField);
        make.width.equalTo(@kScrAdaptationW(46));
    }];
    [self.password_Original.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.password_Original_title).offset(kScrAdaptationW(29+46));
    }];
    
    [self.password_New mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.password_Original.mas_bottom);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.height.offset(kScrAdaptationH(60));
    }];
    [self.password_New_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.password_New);
        make.left.equalTo(weakSelf.password_New.leftImageView);
        make.height.equalTo(weakSelf.password_New.textField);
        make.width.equalTo(@kScrAdaptationW(46));
    }];
    [self.password_New.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.password_New_title).offset(kScrAdaptationW(29+46));
    }];
    [self.forgotPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(kScrAdaptationW(-15));
        make.height.equalTo(@(kScrAdaptationH(17)));
        make.top.equalTo(weakSelf.password_New_title.mas_bottom).offset(kScrAdaptationH(10));
        make.width.equalTo(@kScrAdaptationW(80));
    }];
    [self.alterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.password_New.mas_bottom).offset(kScrAdaptationH(100));
        make.left.equalTo(weakSelf).offset(kScrAdaptationW(20));
        make.right.equalTo(weakSelf).offset(kScrAdaptationW(-20));
        make.height.equalTo(@(kScrAdaptationH(41)));
    }];
}
///点击了确认修改按钮
- (void)clickAlterButton: (UIButton *)button {
    NSLog(@"点击了确认修改按钮");
    if (self.clickAlterButtonBlock) self.clickAlterButtonBlock(self.password_Original.text,self.password_New.text);
}
- (void)clickAlterButtonWithBlock:(void (^)(NSString *password_Original, NSString *password_New))clickAlterButtonBlock {
    self.clickAlterButtonBlock = clickAlterButtonBlock;
}
- (void)forgotPasswordButtonClick:(UIButton *)sender {
    if (self.forgotPasswordBlock) {
        self.forgotPasswordBlock();
    }
}

#pragma mark - 懒加载
- (UIButton *)forgotPasswordButton {
    if (!_forgotPasswordButton) {
        _forgotPasswordButton = [UIButton new];
        [_forgotPasswordButton setTitle:@" 忘记密码?" forState:UIControlStateNormal];
        [_forgotPasswordButton addTarget:self action:@selector(forgotPasswordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_forgotPasswordButton setTitleColor:RGB(254, 126, 94) forState:UIControlStateNormal];
        [_forgotPasswordButton.titleLabel setFont:kHXBFont_PINGFANGSC_REGULAR(12)];
        _forgotPasswordButton.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _forgotPasswordButton;
}
- (UILabel *)password_New_title {
    if (!_password_New_title) {
        _password_New_title = [[UILabel alloc] init];
        _password_New_title.textColor = COR5;
        _password_New_title.font = kHXBFont_PINGFANGSC_REGULAR(14);
        _password_New_title.text = @"新密码";
    }
    return _password_New_title;
}
- (UILabel *)password_Original_title {
    if (!_password_Original_title) {
        _password_Original_title = [[UILabel alloc] init];
        _password_Original_title.textColor = COR5;
        _password_Original_title.font = kHXBFont_PINGFANGSC_REGULAR(14);
        _password_Original_title.text = @"原密码";
    }
    return _password_Original_title;
}
- (HXBCustomTextField *)password_New
{
    if (!_password_New) {
        _password_New = [[HXBCustomTextField alloc] init];
        _password_New.leftImage = [UIImage imageNamed:@"password"];
        _password_New.delegate = self;
        _password_New.placeholder = @"设置8-20位数字和字母组合";
        _password_New.secureTextEntry = YES;
        _password_New.block = ^(NSString *text) {
            if (text.length > 0 && _password_Original.text.length > 0) {
                _alterButton.backgroundColor = COR29;
                _alterButton.userInteractionEnabled = YES;
            } else {
                _alterButton.backgroundColor = kHXBColor_FF7055_40;
                _alterButton.userInteractionEnabled = NO;
            }
        };
    }
    return _password_New;
}

- (HXBCustomTextField *)password_Original
{
    if (!_password_Original) {
        _password_Original = [[HXBCustomTextField alloc] init];
        _password_Original.leftImage = [UIImage imageNamed:@"password"];
        _password_Original.delegate = self;
        _password_Original.placeholder = @"原登录密码";
        _password_Original.secureTextEntry = YES;
        _password_Original.block = ^(NSString *text) {
            if (text.length > 0 && _password_New.text.length > 0) {
                _alterButton.backgroundColor = COR29;
                _alterButton.userInteractionEnabled = YES;
            } else {
                _alterButton.backgroundColor = kHXBColor_FF7055_40;
                _alterButton.userInteractionEnabled = NO;
            }
        };
    }
    return _password_Original;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.alterButton.backgroundColor = kHXBColor_FF7055_40;
    self.alterButton.userInteractionEnabled = NO;
    return YES;
}

@end
