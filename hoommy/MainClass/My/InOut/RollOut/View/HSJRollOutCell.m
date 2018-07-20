//
//  HSJRollOutCell.m
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJRollOutCell.h"

NSString *const HSJRollOutCellIdentifier = @"HSJRollOutCellIdentifier";
const CGFloat HSJRollOutCellHeight = 85;

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

/// 转出
@property (nonatomic, weak) UIButton *statusBtn;

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
    earnAmountDescLabel.text = @"累计收益";
    earnAmountDescLabel.textColor = kHXBColor_999999_100;
    earnAmountDescLabel.font = kHXBFont_22;
    [self.infoView addSubview:earnAmountDescLabel];
    self.earnAmountDescLabel = earnAmountDescLabel;
    
    UILabel *earnAmountLabel = [UILabel new];
    earnAmountLabel.textColor = kHXBColor_333333_100;
    earnAmountLabel.font = kHXBFont_24;
    [self.infoView addSubview:earnAmountLabel];
    self.earnAmountLabel = earnAmountLabel;
    
    UIButton *statusBtn = [[UIButton alloc] init];
    statusBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.infoView addSubview:statusBtn];
    self.statusBtn = statusBtn;
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = kHXBColor_ECECEC_100;
    [infoView addSubview:bottomLine];
    
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.left.equalTo(self.contentView);
        make.width.equalTo(@0);//@45
    }];
    
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.bottom.right.equalTo(self.contentView);
    }];
    
    [leftAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@25);
        make.left.equalTo(infoView);
    }];
    
    [leftAccountDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftAccountLabel);
        make.bottom.equalTo(@-25);
    }];
    
    [joinInDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@26.5);
        make.right.equalTo(joinInLabel.mas_left).offset(-5);
    }];
    
    [joinInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(joinInDescLabel);
        make.left.equalTo(self.contentView.mas_centerX);
    }];
    
    [earnAmountDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-26.5);
        make.right.equalTo(joinInDescLabel);
    }];
    
    [earnAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(earnAmountDescLabel);
        make.left.equalTo(joinInLabel);
    }];
    
    [statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.equalTo(infoView);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.bottom.equalTo(infoView);
        make.right.equalTo(@-15);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - Action


#pragma mark - Setter / Getter / Lazy
- (void)setViewModel:(HSJRollOutCellViewModel *)viewModel {
    _viewModel = viewModel;
    
    self.selectBtn.backgroundColor = viewModel.backgroundColor;
    self.selectBtn.hidden = !viewModel.isEditing;
    self.infoView.backgroundColor = viewModel.backgroundColor;
    
    self.leftAccountLabel.text = viewModel.leftAccountString;
    self.leftAccountLabel.textColor = viewModel.leftAccountColor;
    self.leftAccountDescLabel.textColor = viewModel.leftAccountDescColor;
    
    self.joinInLabel.text = viewModel.joinInString;
    self.joinInLabel.textColor = viewModel.joinInColor;
    self.joinInDescLabel.textColor = viewModel.joinInDescColor;
    
    self.earnAmountLabel.text = viewModel.earnInterestString;
    self.earnAmountLabel.textColor = viewModel.earnAccountColor;
    self.earnAmountDescLabel.textColor = viewModel.earnAccountDescColor;
    
    self.statusBtn.enabled = viewModel.statusBtnEnabled;
    [self.statusBtn setTitle:viewModel.statusString forState:UIControlStateNormal];
    [self.statusBtn setTitleColor:viewModel.statusTextColor forState:UIControlStateNormal];
//    self.statusBtn.text = viewModel.statusString;
//    self.statusBtn.textColor = viewModel.statusTextColor;
    self.statusBtn.titleLabel.font = viewModel.statusFont;
    self.statusBtn.titleLabel.numberOfLines = viewModel.statusLineNum;
    
    [self.selectBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(viewModel.isEditing ? 45 : 0));
    }];
    [self.infoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(viewModel.isEditing ? 45 : 15));
    }];
}


#pragma mark - Helper


#pragma mark - Other


#pragma mark - Public

@end
