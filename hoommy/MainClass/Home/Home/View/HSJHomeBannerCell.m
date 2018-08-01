//
//  HSJHomeBannerCell.m
//  hoommy
//
//  Created by lxz on 2018/8/1.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJHomeBannerCell.h"
#import "UIImageView+WebCache.h"

NSString *const HSJHomeBannerCellIdentifier = @"HSJHomeBannerCellIdentifier";

@interface HSJHomeBannerCell ()
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation HSJHomeBannerCell

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark - UI

- (void)setUI {
    UIImageView *imageView = [UIImageView new];
    imageView.layer.cornerRadius = 10;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - Action


#pragma mark - Setter / Getter / Lazy
- (void)setImage:(NSString *)image {
    _image = image;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:nil];
}

#pragma mark - Helper


#pragma mark - Other


#pragma mark - Public

@end
