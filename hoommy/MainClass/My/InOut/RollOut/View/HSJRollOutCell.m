//
//  HSJRollOutCell.m
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJRollOutCell.h"

NSString *const HSJRollOutCellIdentifier = @"HSJRollOutCellIdentifier";
const CGFloat HSJRollOutCellHeight = 84;

@interface HSJRollOutCell ()
/// 待转金额
@property (nonatomic, weak) UILabel *leftAccountLabel;
@property (nonatomic, weak) UILabel *leftAccountDescLabel;
/// 加入金额
@property (nonatomic, weak) UILabel *joinInLabel;
@property (nonatomic, weak) UILabel *joinInDescLabel;
/// 累计收益
@property (nonatomic, weak) UILabel *earnAmountLabel;
@property (nonatomic, weak) UILabel *earnAmountDescLabel;

/// 转出按钮
@property (nonatomic, weak) UIButton *rollOutBtn;

@property (nonatomic, weak) UIButton *selectBtn;
@property (nonatomic, weak) UIView *infoView;

@end

@implementation HSJRollOutCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setUI];
    }
    return self;
}

#pragma mark - UI

- (void)setUI {
    UIButton *selectBtn = [[UIButton alloc] init];
    [self.contentView addSubview:selectBtn];
    self.selectBtn = selectBtn;
    
    UIView *infoView = [UIView new];
    [self.contentView addSubview:infoView];
    self.infoView = infoView;
    
    UILabel *leftAccountLabel = [UILabel new];
    leftAccountLabel.text = @"0.00";
    leftAccountLabel.textColor = kHXBColor_FF7055_100;
    leftAccountLabel.font = kHXBFont_34;
    [self.infoView addSubview:leftAccountLabel];
    self.leftAccountLabel = leftAccountLabel;
    
    UILabel *leftAccountDescLabel = [UILabel new];
    leftAccountDescLabel.text = @"待转金额(元)";
    leftAccountDescLabel.textColor = kHXBColor_999999_100;
    leftAccountDescLabel.font = kHXBFont_22;
    [self.infoView addSubview:leftAccountDescLabel];
    self.leftAccountDescLabel = leftAccountDescLabel;
    
    UILabel *joinInDescLabel = [UILabel new];
    joinInDescLabel.text = @"加入金额";
    joinInDescLabel.textColor = kHXBColor_999999_100;
    joinInDescLabel.font = kHXBFont_22;
    [self.infoView addSubview:joinInDescLabel];
    self.joinInDescLabel = joinInDescLabel;
    
    UILabel *joinInLabel = [UILabel new];
    joinInLabel.textColor = kHXBColor_333333_100;
    joinInLabel.font = kHXBFont_24;
    [self.infoView addSubview:joinInLabel];
    self.joinInLabel = joinInLabel;
    
    UILabel *earnAmountDescLabel = [UILabel new];
    earnAmountDescLabel.text = @"加入金额";
    earnAmountDescLabel.textColor = kHXBColor_999999_100;
    earnAmountDescLabel.font = kHXBFont_22;
    [self.infoView addSubview:earnAmountDescLabel];
    self.earnAmountDescLabel = earnAmountDescLabel;
    
    UILabel *earnAmountLabel = [UILabel new];
    earnAmountLabel.textColor = kHXBColor_333333_100;
    earnAmountLabel.font = kHXBFont_24;
    [self.infoView addSubview:earnAmountLabel];
    self.earnAmountLabel = earnAmountLabel;
    
    UIButton *rollOutBtn = [[UIButton alloc] init];
    [self.infoView addSubview:rollOutBtn];
    self.rollOutBtn = rollOutBtn;
    
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.left.equalTo(infoView);
        make.width.equalTo(@0);//@45
    }];
    
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectBtn.mas_right);
        make.top.bottom.right.equalTo(self.contentView);
    }];
}

#pragma mark - Action


#pragma mark - Setter / Getter / Lazy


#pragma mark - Helper


#pragma mark - Other


#pragma mark - Public

@end
