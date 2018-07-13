//
//  HXBBindPhoneTableFootView.m
//  hoomxb
//
//  Created by caihongji on 2018/7/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HXBBindPhoneTableFootView.h"

@interface HXBBindPhoneTableFootView()

@property (nonatomic, strong) UILabel *phoneLb;
@property (nonatomic, strong) UIButton *checkButton;
@end

@implementation HXBBindPhoneTableFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self addConstraints];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    self.phoneLb = [[UILabel alloc] init];
    self.phoneLb.textColor = kHXBFontColor_9295A2_100;
    self.phoneLb.font = kHXBFont_PINGFANGSC_REGULAR(12);
    [self addSubview:self.phoneLb];
    
    self.checkButton = [[UIButton alloc] init];
    self.checkButton.layer.cornerRadius = 2;
    self.checkButton.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(15);
    [self.checkButton addTarget:self action:@selector(checkButtonAct:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.checkButton];
}

- (void)addConstraints {
    [self.phoneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kScrAdaptationW(15));
        make.top.equalTo(self).offset(kScrAdaptationW(10));
    }];
    
    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kScrAdaptationW(20));
        make.right.equalTo(self).offset(-kScrAdaptationW(20));
        make.height.mas_equalTo(kScrAdaptationH(40));
        make.bottom.mas_equalTo(self);
    }];
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle = buttonTitle;
    
    [self.checkButton setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)setButtonBackGroundColor:(UIColor *)buttonBackGroundColor {
    _buttonBackGroundColor = buttonBackGroundColor;
    
    [self.checkButton setBackgroundColor:buttonBackGroundColor];
}

- (void)setButtonBackGroundImage:(UIImage *)buttonBackGroundImage {
    _buttonBackGroundImage = buttonBackGroundImage;
    
    [self.checkButton setBackgroundImage:buttonBackGroundImage forState:UIControlStateNormal];
}

- (void)setPhoneInfo:(NSString *)phoneInfo {
    _phoneInfo = [NSString stringWithFormat:@"短信验证码会发送至手机号%@", phoneInfo];
    
    self.phoneLb.text = _phoneInfo;
}

- (void)checkButtonAct:(UIButton *)button {
    if(self.checkAct) {
        self.checkAct();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
