//
//  HSJBottomPromptView.m
//  hoommy
//
//  Created by HXB-C on 2018/7/23.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBottomPromptView.h"

@interface HSJBottomPromptView()

@property (nonatomic, strong) UILabel *bankLabel;

@property (nonatomic, strong) UILabel *riskLabel;

@end

@implementation HSJBottomPromptView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kHXBBackgroundColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.bankLabel];
    [self addSubview:self.riskLabel];
    [self.bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_centerY).offset(-kScrAdaptationH750(4));
    }];
    [self.riskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_centerY).offset(kScrAdaptationH750(4));
    }];
}

- (UILabel *)bankLabel {
    if (!_bankLabel) {
        _bankLabel = [[UILabel alloc] init];
        _bankLabel.text = @"恒丰银行资金存管";
        _bankLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
        _bankLabel.textColor = kHXBColor_7F85A1_100;
    }
    return _bankLabel;
}

- (UILabel *)riskLabel {
    if (!_riskLabel) {
        _riskLabel = [[UILabel alloc] init];
        _riskLabel.text = @"-市场有风险 出借需谨慎-";
        _riskLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
        _riskLabel.textColor = kHXBColor_7F85A1_100;
    }
    return _riskLabel;
}

@end
