//
//  HSJPlanDetailTopView.m
//  hoommy
//
//  Created by lxz on 2018/7/13.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJPlanDetailTopView.h"
#import "HSJGlobalInfoManager.h"
#import "HXBUserInfoModel.h"
#import "NSString+HxbPerMilMoney.h"

@interface HSJPlanDetailTopView ()
@property (nonatomic, weak) UILabel *topLabel;
@property (nonatomic, weak) UILabel *topDescLabel;
@property (nonatomic, weak) UILabel *leftLabel;
@property (nonatomic, weak) UILabel *leftDescLabel;
@property (nonatomic, weak) UILabel *centerLabel;
@property (nonatomic, weak) UILabel *centerDescLabel;
@property (nonatomic, weak) UILabel *rightLabel;
@property (nonatomic, weak) UILabel *rightDescLabel;
@end

@implementation HSJPlanDetailTopView

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
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_top_bg"]];
    [self addSubview:bgView];
    
    // Top
    UILabel *topLabel = [UILabel new];
    topLabel.font = kHXBFont_40;
    topLabel.textColor = kHXBColor_976A02_100;
    [self addSubview:topLabel];
    self.topLabel = topLabel;
    
    UILabel *topDescLabel = [UILabel new];
    topDescLabel.font = kHXBFont_24;
    topDescLabel.textColor = kHXBColor_C5AB71_100;
    [self addSubview:topDescLabel];
    self.topDescLabel = topDescLabel;
    
    // Left
    UILabel *leftLabel = [UILabel new];
    leftLabel.font = kHXBFont_28;
    leftLabel.textColor = kHXBColor_976A02_100;
    [self addSubview:leftLabel];
    self.leftLabel = leftLabel;
    
    UILabel *leftDescLabel = [UILabel new];
    leftDescLabel.font = kHXBFont_24;
    leftDescLabel.textColor = kHXBColor_C5AB71_100;
    [self addSubview:leftDescLabel];
    self.leftDescLabel = leftDescLabel;
    
    // Center
    UILabel *centerLabel = [UILabel new];
    centerLabel.font = kHXBFont_28;
    centerLabel.textColor = kHXBColor_976A02_100;
    [self addSubview:centerLabel];
    self.centerLabel = centerLabel;
    
    UILabel *centerDescLabel = [UILabel new];
    centerDescLabel.font = kHXBFont_24;
    centerDescLabel.textColor = kHXBColor_C5AB71_100;
    [self addSubview:centerDescLabel];
    self.centerDescLabel = centerDescLabel;
    
    // Right
    UILabel *rightLabel = [UILabel new];
    rightLabel.font = kHXBFont_28;
    rightLabel.textColor = kHXBColor_976A02_100;
    [self addSubview:rightLabel];
    self.rightLabel = rightLabel;
    
    UILabel *rightDescLabel = [UILabel new];
    rightDescLabel.font = kHXBFont_24;
    rightDescLabel.textColor = kHXBColor_C5AB71_100;
    [self addSubview:rightDescLabel];
    self.rightDescLabel = rightDescLabel;
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kScrAdaptationW(90) + HXBStatusBarAdditionHeight));
        make.centerX.equalTo(self);
//        make.height.equalTo(@kScrAdaptationW(20));
    }];
    
    [topDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLabel.mas_bottom).offset(kScrAdaptationW(4));
        make.centerX.equalTo(self);
    }];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerLabel);
        make.left.greaterThanOrEqualTo(@15);
        make.centerX.equalTo(leftDescLabel);
    }];
    
    [leftDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftLabel.mas_bottom).offset(kScrAdaptationW(4));
        make.left.greaterThanOrEqualTo(@15);
    }];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerLabel);
        make.right.lessThanOrEqualTo(@-15);
        make.centerX.equalTo(rightDescLabel);
    }];
    
    [rightDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightLabel.mas_bottom).offset(kScrAdaptationW(4));
        make.right.greaterThanOrEqualTo(@-15);
    }];
    
    [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topDescLabel.mas_bottom).offset(kScrAdaptationW(44));
        make.centerX.equalTo(self);
    }];
    
    [centerDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerLabel.mas_bottom).offset(kScrAdaptationW(4));
        make.centerX.equalTo(centerLabel);
        make.bottom.equalTo(@kScrAdaptationW(-38));
    }];
}

#pragma mark - Setter / Getter / Lazy
- (void)setViewModel:(HSJPlanDetailViewModel *)viewModel {
    _viewModel = viewModel;
    
    if (viewModel.planModel.hasBuy) {
        self.topLabel.text = @"0.00";
        self.topDescLabel.text = @"昨日收益(元)";
        
        self.leftLabel.text = @"0.00";
        self.leftDescLabel.text = @"总资产(元）";
        
        self.centerLabel.text = @"0.00";
        self.centerDescLabel.text = @"累计收益(元)";
        
        self.rightLabel.text = viewModel.interestString;
        self.rightDescLabel.text = @"今日预期年化";
        
        kWeakSelf
        [self.viewModel downLoadUserInfo:NO resultBlock:^(id responseData, NSError *erro) {
            if (responseData) {
                HXBUserInfoModel *infoModel = (HXBUserInfoModel *)responseData;
                
                weakSelf.topLabel.text = [NSString stringWithFormat:@"%.2f", infoModel.userAssets.yesterdayInterest];
                
                NSString *assetsTotal = [NSString GetPerMilWithDouble: infoModel.userAssets.stepUpAssets];
                weakSelf.leftLabel.text = [assetsTotal isEqualToString:@"0"] ? @"0.00" : assetsTotal;
                
                NSString *earnTotal = [NSString GetPerMilWithDouble: infoModel.userAssets.stepUpSumPlanInterest];
                weakSelf.centerLabel.text = [earnTotal isEqualToString:@"0"] ? @"0.00" : earnTotal;
            }
        }];
    } else {
        self.topLabel.text = viewModel.interestString;
        self.topDescLabel.text = @"今日预期年化";
        
        self.leftLabel.text = [NSString stringWithFormat:@"%@元", viewModel.planModel.tenThousandExceptedIncome];
        self.leftDescLabel.text = @"万元日预期收益";
        
        self.centerLabel.text = [NSString stringWithFormat:@"%@后可退", viewModel.lockString];
        self.centerDescLabel.text = @"期限灵活";
        
        self.rightLabel.text = @"0人";
        self.rightDescLabel.text = @"近7日加入宝妈";
        
        // 更新近7日人数
        kWeakSelf
        [[HSJGlobalInfoManager shared] getData:^(HSJGlobalInfoModel *infoModel) {
            weakSelf.rightLabel.text = [NSString stringWithFormat:@"%zd人", infoModel.financePlanSubPointCountIn7Days];
        }];
        
    }
    
}


@end
