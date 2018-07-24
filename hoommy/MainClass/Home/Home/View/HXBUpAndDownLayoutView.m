//
//  HXBUpAndDownLayoutView.m
//  hoomxb
//
//  Created by HXB-C on 2018/7/4.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HXBUpAndDownLayoutView.h"

@interface HXBUpAndDownLayoutView()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HXBUpAndDownLayoutView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.titleLabel.mas_top).offset(-kScrAdaptationH(5));
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.titleLabel);
    }];
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(13);
        _titleLabel.textColor = kHXBFontColor_333333_100;
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}



@end
