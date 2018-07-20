//
//  HSJHomePlanView.m
//  hoommy
//
//  Created by HXB-C on 2018/7/19.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJHomePlanView.h"

@interface HSJHomePlanView()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *segmentLineView;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIImageView *planBackgroundImageView;

@property (nonatomic, strong) UILabel *expectedRateLabel;

@property (nonatomic, strong) UILabel *annualizedTextLabel;

@property (nonatomic, strong) UILabel *depositoryLabel;

@property (nonatomic, strong) UILabel *refundableLabel;

@end

@implementation HSJHomePlanView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kHXBColor_FFFFFF_100;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.segmentLineView];
    [self addSubview:self.messageLabel];
    [self addSubview:self.planBackgroundImageView];
    [self addSubview:self.expectedRateLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kScrAdaptationW750(30));
        make.top.equalTo(self).offset(kScrAdaptationH750(40));
    }];
    [self.segmentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(kScrAdaptationW750(16));
        make.centerY.equalTo(self.titleLabel);
        make.height.offset(kScrAdaptationH750(21));
        make.width.offset(kHXBDivisionLineHeight);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.segmentLineView).offset(kScrAdaptationW750(16));
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.planBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kScrAdaptationW750(30));
        make.right.equalTo(self).offset(-kScrAdaptationW750(30));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(50);
    }];
    [self.expectedRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.planBackgroundImageView);
        make.top.equalTo(self.planBackgroundImageView).offset(kScrAdaptationH750(50));
        
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(34);
        _titleLabel.textColor = kHXBFontColor_333333_100;
        _titleLabel.text = @"存钱罐";
    }
    return _titleLabel;
}

- (UIView *)segmentLineView {
    if (!_segmentLineView) {
        _segmentLineView = [[UIView alloc] init];
        _segmentLineView.backgroundColor = kHXBColor_CBCBCB_100;
    }
    return _segmentLineView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
        _messageLabel.textColor = kHXBColor_CBCBCB_100;
        _messageLabel.text = @"存取灵活";
    }
    return _messageLabel;
}

- (UIImageView *)planBackgroundImageView {
    if (!_planBackgroundImageView) {
        _planBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_Invest_Plan_Bg"]];
    }
    return _planBackgroundImageView;
}

- (UILabel *)expectedRateLabel {
    if (!_expectedRateLabel) {
        _expectedRateLabel = [[UILabel alloc] init];
        _expectedRateLabel.text = @"6%";
        _expectedRateLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(100);
        _expectedRateLabel.textColor = kHXBColor_FF7055_100;
    }
    return _expectedRateLabel;
}

- (UILabel *)annualizedTextLabel {
    if (!_annualizedTextLabel) {
        _annualizedTextLabel = [[UILabel alloc] init];
        _annualizedTextLabel.text = @"今日预期年化";
        _annualizedTextLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
        _annualizedTextLabel.textColor = kHXBColor_7F85A1_100;
    }
    return _annualizedTextLabel;
}

@end
