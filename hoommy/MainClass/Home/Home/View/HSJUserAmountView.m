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
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    
    [self addSubview:self.amountLabel];
    [self addSubview:self.tipLabel];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kScrAdaptationH750(40));
        make.centerX.equalTo(self);
        make.height.offset(kScrAdaptationH750(64));
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.amountLabel);
        make.height.offset(kScrAdaptationH750(32));
        make.top.equalTo(self.amountLabel.mas_bottom).offset(kScrAdaptationH750(20));
    }];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewClick {
    if (self.viewClickBlock) {
        self.viewClickBlock();
    }
}


- (void)setAmountText:(NSString *)amountText andWithAmountTextUnit:(NSString *)amountTextUnit {
    amountText = amountText? : @"--";
    amountTextUnit = amountTextUnit? : @"--";
    NSRange rangeAmountText = [amountText rangeOfString:amountText];
    NSRange rangeAmountTextUnit = [amountTextUnit rangeOfString:amountTextUnit];
    self.amountLabel.attributedText = [NSMutableAttributedString setupAttributeStringWithBeforeString:amountText WithBeforeRange:rangeAmountText andAttributeColor:kHXBFontColor_7F85A1_100 andAttributeFont:kHXBFont_DINCondensed_BOLD_750(64) afterString:amountTextUnit WithAfterRange:rangeAmountTextUnit andAttributeColor:kHXBFontColor_7F85A1_100 andAttributeFont:kHXBFont_30];
}

- (void)setDescribeStr:(NSString *)describeStr {
    _describeStr = describeStr;
    self.tipLabel.text = describeStr;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textColor = [UIColor redColor];//kHXBFontColor_7F85A1_100;
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
