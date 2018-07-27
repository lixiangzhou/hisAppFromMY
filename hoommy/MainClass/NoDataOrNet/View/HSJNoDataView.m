//
//  HSJNoDataView.m
//  hoommy
//
//  Created by lxz on 2018/7/27.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJNoDataView.h"

@interface HSJNoDataView ()
@property (nonatomic, strong) UIImageView *topImv;
@property (nonatomic, strong) UILabel *prompLb;
@end

@implementation HSJNoDataView

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
    UIView *contentView = [UIView new];
    [self addSubview:contentView];
    
    self.topImv = [[UIImageView alloc] init];
    self.topImv.image = [UIImage imageNamed:@"no_data"];
    [contentView addSubview:self.topImv];
    
    self.prompLb = [[UILabel alloc] init];
    self.prompLb.font = kHXBFont_36;
    self.prompLb.textColor = kHXBColor_666666_100;
    self.prompLb.textAlignment = NSTextAlignmentCenter;
    self.prompLb.text = @"暂无数据";
    [contentView addSubview:self.prompLb];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.greaterThanOrEqualTo(self);
        make.bottom.right.lessThanOrEqualTo(self);
    }];
    
    [self.topImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(contentView);
        make.width.equalTo(@(self.topImv.image.size.width));
        make.height.equalTo(@(self.topImv.image.size.height));
    }];
    
    [self.prompLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImv.mas_bottom).offset(kScrAdaptationH(60));
        make.left.right.bottom.equalTo(contentView);
    }];
}

#pragma mark - Action


#pragma mark - Setter / Getter / Lazy


#pragma mark - Helper


#pragma mark - Other


#pragma mark - Public

@end
