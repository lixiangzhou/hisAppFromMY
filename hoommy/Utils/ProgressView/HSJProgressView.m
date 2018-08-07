//
//  HSJProgressView.m
//  hoommy
//
//  Created by lxz on 2018/8/6.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJProgressView.h"
#import <IQKeyboardManager.h>

@interface HSJProgressView ()
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, strong) CABasicAnimation *animation;
@end

@implementation HSJProgressView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        anim.duration = 1.5;
        anim.repeatCount = MAXFLOAT;
        anim.fromValue = @0;
        anim.toValue = @(M_PI * 2);
        self.animation = anim;
    }
    return self;
}

#pragma mark - UI

- (void)setUI {
    self.backgroundColor = [UIColor clearColor];
    
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    contentView.layer.cornerRadius = 17.5;
    contentView.layer.masksToBounds = YES;
    self.contentView = contentView;
    
    UIImageView *iconView = [UIImageView new];
    iconView.image = [UIImage imageNamed:@"hsj_loading"];
    self.iconView = iconView;
    
    UILabel *loadingLabel = [UILabel new];
    loadingLabel.text = @"加载中...";
    loadingLabel.font = kHXBFont_28;
    loadingLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:contentView];
    [contentView addSubview:iconView];
    [contentView addSubview:loadingLabel];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-50);
        make.centerX.equalTo(self);
        make.height.equalTo(@35);
    }];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(@20);
    }];
    
    [loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(iconView.mas_right).offset(10);
        make.right.equalTo(@-20);
    }];
}

#pragma mark - Action


#pragma mark - Setter / Getter / Lazy


#pragma mark - Helper


#pragma mark - Other


#pragma mark - Public
- (void)show {
    BOOL hasTabbar = [self.viewController isKindOfClass:NSClassFromString(@"HSJHomeViewController")] || [self.viewController isKindOfClass:NSClassFromString(@"HSJMyViewController")];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-50 -(hasTabbar ? HXBBottomAdditionHeight : 0)));
    }];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.iconView.layer addAnimation:self.animation forKey:@"rotate_layer"];
    }];
}

- (void)hide {
    self.alpha = 1.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.layer removeAnimationForKey:@"rotate_layer"];
    }];
}
@end
