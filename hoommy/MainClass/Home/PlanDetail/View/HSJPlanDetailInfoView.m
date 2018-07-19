//
//  HSJPlanDetailInfoView.m
//  hoommy
//
//  Created by lxz on 2018/7/13.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJPlanDetailInfoView.h"
#import "HSJGlobalInfoManager.h"
@interface HSJPlanDetailInfoView ()
@property (nonatomic, weak) UILabel *totalNumLabel;
@property (nonatomic, weak) UILabel *totalMoneyLabel;
@end

@implementation HSJPlanDetailInfoView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        [self setData];
    }
    return self;
}

#pragma mark - UI

- (void)setUI {
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *descLabel = [UILabel new];
    descLabel.text = @"你离自信妈妈只差一步 马上开启宝贝计划吧";
    descLabel.font = kHXBFont_28;
    descLabel.textColor = kHXBColor_666666_100;
    [self addSubview:descLabel];
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = UIColorFromRGB(0xFFF7F5);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 2;
    [self addSubview:bgView];
    
    UILabel *totalNumLabel = [UILabel new];
    totalNumLabel.font = kHXBFont_24;
    totalNumLabel.textColor = kHXBColor_9B878B_100;
    [bgView addSubview:totalNumLabel];
    self.totalNumLabel = totalNumLabel;
    
    UILabel *totalMoneyLabel = [UILabel new];
    totalMoneyLabel.font = kHXBFont_24;
    totalMoneyLabel.textColor = kHXBColor_9B878B_100;
    [bgView addSubview:totalMoneyLabel];
    self.totalMoneyLabel = totalMoneyLabel;
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_pig"]];
    [bgView addSubview:iconView];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@kScrAdaptationW(17.5));
        make.left.equalTo(@kScrAdaptationW(15));
        make.right.equalTo(@kScrAdaptationW(-15));
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).offset(kScrAdaptationW(17.5));
        make.left.right.equalTo(descLabel);
        make.bottom.equalTo(@kScrAdaptationW(-37));
    }];
    
    [totalNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@kScrAdaptationW(20));
    }];
    
    [totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totalNumLabel);
        make.top.equalTo(totalNumLabel.mas_bottom).offset(kScrAdaptationW(14));
        make.bottom.equalTo(@kScrAdaptationW(-20));
    }];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.right.equalTo(@kScrAdaptationW(-20));
        make.width.equalTo(@kScrAdaptationW(80));
        make.height.equalTo(@kScrAdaptationW(50));
    }];
}

#pragma mark - Helper
- (void)setData {
    [self updateDataWithTotlaNum:0 totalMoney:0];
    
    kWeakSelf
    [[HSJGlobalInfoManager shared] getData:^(HSJGlobalInfoModel *infoModel) {
        [weakSelf updateDataWithTotlaNum:infoModel.financePlanSubPointCount
                          totalMoney:infoModel.financePlanEarnInterest];
    }];
}

- (void)updateDataWithTotlaNum:(NSInteger)totalNum totalMoney:(CGFloat)totalMoney {
    NSMutableAttributedString *totalNumAttr = [[NSMutableAttributedString alloc] initWithString:@"共计 "];
    [totalNumAttr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd", totalNum] attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:12]}]];
    [totalNumAttr appendAttributedString:[[NSAttributedString alloc] initWithString:@" 名妈妈开启豪妈小金库"]];
    
    NSMutableAttributedString *totalMoneyAttr = [[NSMutableAttributedString alloc] initWithString:@"累计为宝宝成功攒钱 "];
    [totalMoneyAttr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", totalMoney] attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:12]}]];
    [totalMoneyAttr appendAttributedString:[[NSAttributedString alloc] initWithString:@" 元"]];
    
    self.totalNumLabel.attributedText = totalNumAttr;
    self.totalMoneyLabel.attributedText = totalMoneyAttr;
}

@end
