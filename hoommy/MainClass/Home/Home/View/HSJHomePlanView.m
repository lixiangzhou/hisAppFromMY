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

@end
