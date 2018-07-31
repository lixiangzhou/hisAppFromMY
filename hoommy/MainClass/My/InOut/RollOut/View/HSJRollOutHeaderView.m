//
//  HSJRollOutHeaderView.m
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJRollOutHeaderView.h"
#import "NSString+HxbPerMilMoney.h"

@interface HSJRollOutHeaderView ()
/// 持有中
@property (nonatomic, weak) UILabel *holdAssetsLabel;
/// 可转出
@property (nonatomic, weak) UILabel *rollOutAssetsLabel;
@end

@implementation HSJRollOutHeaderView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, kScrAdaptationW(15.5), kScreenWidth, kScrAdaptationW(135))];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark - UI

- (void)setUI {
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"account_plan_list_top_bg"];
    bgView.layer.cornerRadius = 2;
    bgView.layer.masksToBounds = YES;
    [self addSubview:bgView];
    
    UILabel *holdDescAssetsLabel = [UILabel new];
    holdDescAssetsLabel.text = @"持有中资产(元)";
    holdDescAssetsLabel.font = kHXBFont_24;
    holdDescAssetsLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:holdDescAssetsLabel];
    
    UILabel *holdAssetsLabel = [UILabel new];
    holdAssetsLabel.text = @"0.00";
    holdAssetsLabel.font = kHXBFont_40;
    holdAssetsLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:holdAssetsLabel];
    self.holdAssetsLabel = holdAssetsLabel;
    
    UILabel *rollOutDescAssetsLabel = [UILabel new];
    rollOutDescAssetsLabel.text = @"可转出资产(元)";
    rollOutDescAssetsLabel.font = kHXBFont_24;
    rollOutDescAssetsLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:rollOutDescAssetsLabel];
    
    UILabel *rollOutAssetsLabel = [UILabel new];
    rollOutAssetsLabel.text = @"0.00";
    rollOutAssetsLabel.font = kHXBFont_40;
    rollOutAssetsLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:rollOutAssetsLabel];
    self.rollOutAssetsLabel = rollOutAssetsLabel;
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@kScrAdaptationW(15));
        make.right.equalTo(@kScrAdaptationW(-15));
        make.bottom.equalTo(self);
        make.height.equalTo(@kScrAdaptationW(120));
    }];
    
    
    [holdDescAssetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@kScrAdaptationW(41.5));
        make.centerX.equalTo(self.mas_left).offset(self.width * 0.25);
    }];
    
    [holdAssetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(holdDescAssetsLabel);
        make.bottom.equalTo(@kScrAdaptationW(-41.5));
    }];
    
    [rollOutDescAssetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@kScrAdaptationW(41.5));
        make.centerX.equalTo(self.mas_left).offset(self.width * 0.75);
    }];
    
    [rollOutAssetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rollOutDescAssetsLabel);
        make.bottom.equalTo(@kScrAdaptationW(-41.5));
    }];
}

#pragma mark - Public
- (void)setAssetsModel:(HSJPlanAssetsModel *)assetsModel {
    _assetsModel = assetsModel;
    
    self.holdAssetsLabel.text = [NSString hsj_simpleMoneyValue:assetsModel.currentStepupAmount];
    self.rollOutAssetsLabel.text = [NSString hsj_simpleMoneyValue:assetsModel.stepUpCanSaleAmount];
}

@end
