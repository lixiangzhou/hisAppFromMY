//
//  HSJRollOutCell.m
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJRollOutCell.h"

NSString *const HSJRollOutCellIdentifier = @"HSJRollOutCellIdentifier";

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
    [selectBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
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
    joinInLabel.text = @"0.00元";
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
    earnAmountLabel.text = @"0.00元";
    [self.infoView addSubview:earnAmountLabel];
    self.earnAmountLabel = earnAmountLabel;
    
    UIButton *statusBtn = [[UIButton alloc] init];
    statusBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [statusBtn addTarget:self action:@selector(statusAction) forControlEvents:UIControlEventTouchUpInside];
    [statusBtn setTitle:@" " forState:UIControlStateNormal];
    [self.infoView addSubview:statusBtn];
    self.statusBtn = statusBtn;
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = kHXBColor_ECECEC_100;
    [infoView addSubview:bottomLine];
    
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@kScrAdaptationW(10));
        make.bottom.equalTo(@kScrAdaptationW(-10));
        make.left.equalTo(self.contentView);
        make.width.equalTo(@0);//@45
    }];
    
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@kScrAdaptationW(15));
        make.top.bottom.right.equalTo(self.contentView);
    }];
    
    [leftAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@kScrAdaptationW(25));
        make.left.equalTo(infoView);
    }];
    
    [leftAccountDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftAccountLabel);
        make.bottom.equalTo(@kScrAdaptationW(-25));
    }];
    
    [joinInDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@kScrAdaptationW(26.5));
        make.right.equalTo(joinInLabel.mas_left).offset(kScrAdaptationW(-5));
    }];
    
    [joinInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(joinInDescLabel);
        make.left.equalTo(self.contentView.mas_centerX).offset(0);
    }];
    
    [earnAmountDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@kScrAdaptationW(-26.5));
        make.right.equalTo(joinInDescLabel);
    }];
    
    [earnAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(earnAmountDescLabel);
        make.left.equalTo(joinInLabel);
    }];
    
    [statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@kScrAdaptationW(-15));
        make.centerY.equalTo(infoView);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(infoView);
        make.right.equalTo(@kScrAdaptationW(-15));
        make.height.equalTo(@kScrAdaptationW(0.5));
    }];
    
    [self layoutIfNeeded];
}

#pragma mark - Action
- (void)selectAction {
    self.viewModel.isSelected = !self.viewModel.isSelected;
    [self updateViews];
    
    if (self.selectBlock) {
        self.selectBlock(self.viewModel);
    }
}

- (void)statusAction {
    if (self.rollOutBlock) {
        self.rollOutBlock(self.viewModel);
    }
}

#pragma mark - Setter / Getter / Lazy
- (void)setViewModel:(HSJRollOutCellViewModel *)viewModel {
    _viewModel = viewModel;
    
    [self updateViews];
}


#pragma mark - Helper
- (void)updateViews {
    self.contentView.backgroundColor = self.viewModel.backgroundColor;
    self.selectBtn.hidden = !self.viewModel.isEditing;
    [self.selectBtn setImage:self.viewModel.selectImage forState:UIControlStateNormal];
    self.selectBtn.enabled = self.viewModel.selectBtnEnabled;
    
    self.leftAccountLabel.text = self.viewModel.leftAccountString;
    self.leftAccountLabel.textColor = self.viewModel.leftAccountColor;
    self.leftAccountDescLabel.textColor = self.viewModel.leftAccountDescColor;
    
    self.joinInLabel.text = self.viewModel.joinInString;
    self.joinInLabel.textColor = self.viewModel.joinInColor;
    self.joinInDescLabel.textColor = self.viewModel.joinInDescColor;
    
    self.earnAmountLabel.text = self.viewModel.earnInterestString;
    self.earnAmountLabel.textColor = self.viewModel.earnAccountColor;
    self.earnAmountDescLabel.textColor = self.viewModel.earnAccountDescColor;
    
    self.statusBtn.enabled = self.viewModel.statusBtnEnabled;
    [self.statusBtn setTitle:self.viewModel.statusString forState:UIControlStateNormal];
    [self.statusBtn setTitleColor:self.viewModel.statusTextColor forState:UIControlStateNormal];
    self.statusBtn.titleLabel.font = self.viewModel.statusFont;
    self.statusBtn.titleLabel.numberOfLines = self.viewModel.statusLineNum;
    self.statusBtn.enabled = self.viewModel.statusBtnEnabled;
    
    [self.selectBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.viewModel.isEditing ? 45 : 0));
    }];
    
    [self.infoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(self.viewModel.isEditing ? 45 : 15));
    }];
    
    [self.joinInLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(self.viewModel.isEditing ? 20 : 0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - Other


#pragma mark - Public

@end
