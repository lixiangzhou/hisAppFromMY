//
//  HSJUserAmountView.m
//  hoommy
//
//  Created by HXB-C on 2018/7/23.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJUserAmountView.h"

@interface HSJUserAmountView()

@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation HSJUserAmountView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.amountLabel];
    [self addSubview:self.tipLabel];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kScrAdaptationH750(46));
        make.centerX.equalTo(self);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.amountLabel);
        make.top.equalTo(self.amountLabel.mas_bottom).offset(kScrAdaptationH750(6));
    }];
}

- (void)setAmountStr:(NSString *)amountStr {
    _amountStr = amountStr;
    NSRange range = NSMakeRange(amountStr.length - 2, 2);
    self.amountLabel.attributedText = [NSMutableAttributedString setupAttributeStringWithString:amountStr WithRange:(NSRange)range andAttributeColor:kHXBFontColor_7F85A1_100 andAttributeFont:kHXBFont_PINGFANGSC_REGULAR_750(30)];
}

- (void)setDescribeStr:(NSString *)describeStr {
    _describeStr = describeStr;
    self.tipLabel.text = describeStr;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textColor = kHXBFontColor_7F85A1_100;
        _amountLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(64);
    }
    return _amountLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = kHXBFontColor_7F85A1_100;
        _tipLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
    }
    return _tipLabel;
}

@end
