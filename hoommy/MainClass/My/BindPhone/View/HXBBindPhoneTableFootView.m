//
//  HXBBindPhoneTableFootView.m
//  hoomxb
//
//  Created by caihongji on 2018/7/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HXBBindPhoneTableFootView.h"

@interface HXBBindPhoneTableFootView()

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
    
    self.checkButton = [[UIButton alloc] init];
    [self addSubview:self.checkButton];
}

- (void)addConstraints {
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
