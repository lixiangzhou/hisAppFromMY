//
//  HSJHomeCustomNavbarView.m
//  hoommy
//
//  Created by HXB-C on 2018/7/17.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJHomeCustomNavbarView.h"

@interface HSJHomeCustomNavbarView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *noticeBtn;

@end

@implementation HSJHomeCustomNavbarView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, HXBStatusBarAndNavigationBarHeight)];
    if (self) {
        [self setUI];
    }
    return self;
}



#pragma mark - UI

- (void)setUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.noticeBtn];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kScrAdaptationW750(40));
        make.bottom.equalTo(self).offset(-kScrAdaptationW750(20));
    }];
    [self.noticeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self.titleLabel);
        make.height.width.offset(HXBNavigationBarHeight);
    }];
}

#pragma mark - Action
- (void)noticeBtnClick
{
    if (self.noticeBlock) {
        self.noticeBlock();
    }
}

#pragma mark - Setter / Getter / Lazy

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setNavAlpha:(CGFloat)navAlpha {
    _navAlpha = navAlpha;
    self.alpha = navAlpha;
}

- (void)setNavBackgroundColor:(UIColor *)navBackgroundColor {
    _navBackgroundColor = navBackgroundColor;
    self.backgroundColor = navBackgroundColor;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setTitleFount:(UIFont *)titleFount {
    _titleFount = titleFount;
    self.titleLabel.font = titleFount;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(18);
    }
    return _titleLabel;
}

- (UIButton *)noticeBtn {
    if (!_noticeBtn) {
        _noticeBtn = [[UIButton alloc] init];
        [_noticeBtn setImage:[UIImage imageNamed:@"home_message"] forState:(UIControlStateNormal)];
        [_noticeBtn addTarget:self action:@selector(noticeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _noticeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _noticeBtn;
}

#pragma mark - Helper


#pragma mark - Other


#pragma mark - Public

@end
