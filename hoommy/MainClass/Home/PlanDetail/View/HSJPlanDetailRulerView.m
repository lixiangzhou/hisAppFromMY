//
//  HSJPlanDetailRulerView.m
//  hoommy
//
//  Created by lxz on 2018/7/13.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJPlanDetailRulerView.h"

@interface HSJPlanDetailRulerView ()
/// 锁定期
@property (nonatomic, weak) UILabel *lockLabel;
/// 开始计息
@property (nonatomic, weak) UILabel *startLabel;
/// 可解锁日期
@property (nonatomic, weak) UILabel *exitLockLabel;
@end

@implementation HSJPlanDetailRulerView

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
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"产品投资回报规则";
    titleLabel.font = kHXBFont_32;
    titleLabel.textColor = kHXBColor_564727_100;
    [self addSubview:titleLabel];
    
    UIImageView *leftLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_left_line"]];
    [self addSubview:leftLine];
    
    UIImageView *rightLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_right_line"]];
    [self addSubview:rightLine];
    
    UIImageView *bgLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_ruler_lock_bg"]];
    [self addSubview:bgLineView];
    
    UILabel *lockLabel = [UILabel new];
    lockLabel.font = kHXBFont_22;
    lockLabel.textColor = kHXBColor_976A02_100;
    lockLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lockLabel];
    self.lockLabel = lockLabel;
    
    
    UILabel *lockRightTopLabel = [UILabel new];
    lockRightTopLabel.text = @"你的选择你做主";
    lockRightTopLabel.font = kHXBFont_22;
    lockRightTopLabel.textColor = kHXBColor_C5AB71_100;
    lockRightTopLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lockRightTopLabel];
    
    UILabel *startLabel = [UILabel new];
    startLabel.font = kHXBFont_22;
    startLabel.textColor = kHXBColor_C5AB71_100;
    startLabel.numberOfLines = 2;
    [self addSubview:startLabel];
    self.startLabel = startLabel;
    
    UILabel *exitLockLabel = [UILabel new];
    exitLockLabel.font = kHXBFont_22;
    exitLockLabel.textColor = kHXBColor_C5AB71_100;
    exitLockLabel.numberOfLines = 2;
    [self addSubview:exitLockLabel];
    self.exitLockLabel = exitLockLabel;
    
    UILabel *lockRightBottomLabel = [UILabel new];
    lockRightBottomLabel.text = @"可继续持有\n可随时退出";
    lockRightBottomLabel.font = kHXBFont_22;
    lockRightBottomLabel.textColor = kHXBColor_C5AB71_100;
    lockRightBottomLabel.numberOfLines = 2;
    [self addSubview:lockRightBottomLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@kScrAdaptationW(30));
        make.centerX.equalTo(self);
    }];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.right.equalTo(titleLabel.mas_left).offset(-kScrAdaptationW(10));
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.left.equalTo(titleLabel.mas_right).offset(kScrAdaptationW(10));
    }];
    
    [bgLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@kScrAdaptationW(30));
        make.right.equalTo(@kScrAdaptationW(-30));
        make.top.equalTo(titleLabel.mas_bottom).offset(kScrAdaptationW(25));
        make.height.equalTo(@kScrAdaptationW(24));
    }];
    
    [lockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(bgLineView);
        make.width.equalTo(bgLineView).multipliedBy(128.0/315.0);
    }];
    
    [lockRightTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(bgLineView);
        make.left.equalTo(lockLabel.mas_right);
    }];
    
    [startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgLineView).offset(kScrAdaptationW(2));
        make.top.equalTo(bgLineView.mas_bottom).offset(kScrAdaptationW(4));
        make.height.equalTo(@(startLabel.font.lineHeight * 2 + 1));
        make.bottom.equalTo(self);
    }];
    
    [exitLockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(lockLabel.mas_right);
        make.top.height.equalTo(startLabel);
    }];
    
    [lockRightBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(lockRightTopLabel);
        make.top.height.equalTo(startLabel);
    }];
}

#pragma mark - Setter / Getter / Lazy
- (void)setViewModel:(HSJPlanDetailViewModel *)viewModel {
    _viewModel = viewModel;
    
    self.lockLabel.text = [NSString stringWithFormat:@"锁定%@", viewModel.lockString];
    self.startLabel.text = [NSString stringWithFormat:@"%@\n开始计息", viewModel.startDateString];
    self.exitLockLabel.text = [NSString stringWithFormat:@"%@\n解除锁定", viewModel.endLockDateString];
}

@end
