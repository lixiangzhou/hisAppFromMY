
//
//  HSJTitleCollectionViewCell.m
//  hoommy
//
//  Created by HXB-C on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJTitleCollectionViewCell.h"
@interface HSJTitleCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HSJTitleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        self.backgroundColor = kHXBColor_FFFFFF_100;
    }
    return self;
}

- (void)setupViews
{
    self.contentView.backgroundColor = kHXBColor_FB7F67_10;
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kScrAdaptationH750(18));
        make.top.equalTo(self.contentView).offset(kScrAdaptationH750(18));
        make.bottom.equalTo(self.contentView).offset(-kScrAdaptationH750(18));
        make.width.offset(kScrAdaptationH750(59));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(kScrAdaptationH750(30));
        make.top.bottom.equalTo(self.contentView);
        make.width.offset(kScrAdaptationH(50));
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
        _titleLabel.textColor = kHXBColor_FB7F67_100;
        _titleLabel.text = @"母婴APP";
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_message"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}


@end
