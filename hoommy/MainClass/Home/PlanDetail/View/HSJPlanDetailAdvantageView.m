//
//  HSJPlanDetailAdvantageView.m
//  hoommy
//
//  Created by lxz on 2018/7/13.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJPlanDetailAdvantageView.h"

@interface HSJPlanDetailAdvantageView ()
/// 收益更高
@property (nonatomic, weak) UILabel *moreLabel;
@property (nonatomic, weak) UILabel *moreDescLabel;
/// 退出
@property (nonatomic, weak) UILabel *exitLabel;
@property (nonatomic, weak) UILabel *exitDescLabel;
/// 银行存管
@property (nonatomic, weak) UILabel *bankLabel;
@property (nonatomic, weak) UILabel *bankDescLabel;
@end

@implementation HSJPlanDetailAdvantageView

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
    titleLabel.text = @"产品优势";
    titleLabel.font = kHXBFont_32;
    titleLabel.textColor = kHXBColor_564727_100;
    [self addSubview:titleLabel];
    
    UIImageView *leftLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_left_line"]];
    [self addSubview:leftLine];
    
    UIImageView *rightLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_right_line"]];
    [self addSubview:rightLine];
    
    NSArray *array1 = [self rowViewWithImage:[UIImage imageNamed:@"detail_ad_more"] title:@"收益更高" desc:@"平均历史年化收益率--，更多零花钱任你花"];
    UIView *rowView1 = array1.firstObject;
    [self addSubview:rowView1];
    self.moreLabel = array1[2];
    self.moreDescLabel = array1[3];
    
    NSArray *array2 = [self rowViewWithImage:[UIImage imageNamed:@"detail_ad_exit"] title:@"退出灵活" desc:@"持有-天后，可随时申请退出"];
    UIView *rowView2 = array2.firstObject;
    [self addSubview:rowView2];
    self.exitLabel = array2[2];
    self.exitDescLabel = array2[3];
    
    NSArray *array3 = [self rowViewWithImage:[UIImage imageNamed:@"detail_ad_bank"] title:@"银行存管" desc:@"恒丰银行资金存管，确保妈妈资金安全"];
    UIView *rowView3 = array3.firstObject;
    [self addSubview:rowView3];
    self.bankLabel = array3[2];
    self.bankDescLabel = array3[3];
    
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
        make.left.equalTo(titleLabel.mas_right).offset(-kScrAdaptationW(10));
    }];
    
    [rowView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(kScrAdaptationW(25));
        make.left.equalTo(@kScrAdaptationW(30));
        make.right.equalTo(@kScrAdaptationW(-30));
    }];
    
    [rowView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rowView1.mas_bottom).offset(kScrAdaptationW(30));
        make.left.equalTo(rowView1);
        make.right.equalTo(rowView1);
    }];
    
    [rowView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rowView2.mas_bottom).offset(kScrAdaptationW(30));
        make.left.equalTo(rowView1);
        make.right.equalTo(rowView1);
        make.bottom.equalTo(@kScrAdaptationW(-25));
    }];
}

- (NSArray *)rowViewWithImage:(UIImage *)image title:(NSString *)title desc:(NSString *)desc {
    UIView *view = [UIView new];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:image];
    [view addSubview:iconView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = title;
    titleLabel.font = kHXBFont_30;
    titleLabel.textColor = kHXBColor_C5AB71_100;
    [view addSubview:titleLabel];
    
    UILabel *descLabel = [UILabel new];
    descLabel.text = desc;
    descLabel.font = kHXBFont_26;
    descLabel.textColor = kHXBColor_999999_100;
    [view addSubview:descLabel];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(view);
        make.width.height.equalTo(@kScrAdaptationW(40));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView);
        make.left.equalTo(iconView.mas_right).offset(kScrAdaptationW(15));
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(iconView);
        make.left.equalTo(titleLabel);
    }];
    
    return @[view, iconView, titleLabel, descLabel];
}

#pragma mark - Setter / Getter / Lazy
- (void)setViewModel:(HSJPlanDetailViewModel *)viewModel {
    _viewModel = viewModel;
    
    self.moreLabel.text = @"收益更高";
    self.moreDescLabel.text = [NSString stringWithFormat:@"平均历史年化收益率%@%%，更多零花钱任你花", viewModel.baseInterestString];
    
    self.exitLabel.text = @"退出灵活";
    self.exitDescLabel.text = [NSString stringWithFormat:@"持有%@后，可随时申请退出", viewModel.lockString];
    
    self.bankLabel.text = @"银行存管";
    self.bankDescLabel.text = @"恒丰银行资金存管，确保妈妈资金安全";
    
}

@end
