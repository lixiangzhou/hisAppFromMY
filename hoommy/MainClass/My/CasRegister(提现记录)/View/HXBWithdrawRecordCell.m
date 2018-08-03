//
//  HXBWithdrawRecordCell.m
//  hoomxb
//
//  Created by HXB-C on 2017/10/27.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBWithdrawRecordCell.h"
#import "HXBWithdrawRecordModel.h"
@interface HXBWithdrawRecordCell ()

/**
 提现金额
 */
@property (nonatomic, strong) UILabel *cashAmountLabel;
/**
 银行名称
 */
@property (nonatomic, strong) UILabel *bankNameLabel;
/*
 提现状态描述
 */
@property (nonatomic, strong) UILabel *logDescLabel;
/**
 提现申请日期
 */
@property (nonatomic, strong) UILabel *applyDateLabel;
/**
 提现申请时间
 */
@property (nonatomic, strong) UILabel *applyTimeLabel;

/**
 分割线
 */
@property (nonatomic, strong) UIView *partingLineView;
/**
 圆点
 */
@property (nonatomic, strong) UIView *circularPointView;
@end


@implementation HXBWithdrawRecordCell

#pragma mark - Life Cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubView];
        [self setupSubViewFrame];
    }
    return self;
}

#pragma mark - Private
- (void)setupSubView {
    [self.contentView addSubview:self.cashAmountLabel];
    [self.contentView addSubview:self.bankNameLabel];
    [self.contentView addSubview:self.logDescLabel];
    [self.contentView addSubview:self.applyDateLabel];
    [self.contentView addSubview:self.applyTimeLabel];
    [self.contentView addSubview:self.partingLineView];
    [self.contentView addSubview:self.circularPointView];
}

- (void)setupSubViewFrame {
    
    kWeakSelf
    [self.applyDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@kScrAdaptationW(15));
        make.top.equalTo(@kScrAdaptationH(30));
        make.width.equalTo(@kScrAdaptationW(40));
        make.height.equalTo(@kScrAdaptationH(20));
    }];
    [self.applyTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@kScrAdaptationH(17));
        make.top.equalTo(weakSelf.applyDateLabel.mas_bottom).offset(kScrAdaptationH(5));
        make.left.width.equalTo(weakSelf.applyDateLabel);
    }];
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@kScrAdaptationW(65));
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@1.0f);
    }];
    [self.circularPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@kScrAdaptationW(9));
        make.centerY.equalTo(weakSelf.contentView);
        make.centerX.equalTo(weakSelf.partingLineView);
    }];
    [self.cashAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.circularPointView);
        make.left.equalTo(weakSelf.circularPointView.mas_right).offset(kScrAdaptationW(15));
        make.height.equalTo(@kScrAdaptationH(20));
    }];
    [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.cashAmountLabel.mas_right).offset(kScrAdaptationW(15));
        make.centerY.equalTo(weakSelf.cashAmountLabel);
        make.right.offset(kScrAdaptationW(-15));
        make.height.equalTo(@kScrAdaptationH(17));
    }];
    [self.logDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.cashAmountLabel);
        make.top.equalTo(self.cashAmountLabel.mas_bottom).offset(kScrAdaptationH(10));
        make.height.equalTo(@kScrAdaptationH(17));
        make.right.offset(kScrAdaptationW(15));
    }];
}

#pragma mark - Getters and Setters

- (void)setWithdrawRecordModel:(HXBWithdrawRecordModel *)withdrawRecordModel {
    
    _withdrawRecordModel = withdrawRecordModel;
    self.circularPointView.backgroundColor = withdrawRecordModel.stateColor;
    self.cashAmountLabel.text = [NSString stringWithFormat:@"%@元",withdrawRecordModel.cashAmount];
    self.bankNameLabel.text = [NSString stringWithFormat:@"%@%@",withdrawRecordModel.bankName,withdrawRecordModel.bankLastNum];
    
    NSArray *descArr = [withdrawRecordModel.logText componentsSeparatedByString:@"："];
    NSString *logDesc = [NSString stringWithFormat:@" %@",descArr[1]];
    self.logDescLabel.attributedText = [NSAttributedString setupAttributeStringWithBeforeString:withdrawRecordModel.statusText  WithBeforeRange:NSMakeRange(0, withdrawRecordModel.statusText.length) andAttributeColor:withdrawRecordModel.stateColor andAttributeFont:kHXBFont_PINGFANGSC_REGULAR(12) afterString:logDesc WithAfterRange:NSMakeRange(0, logDesc.length) andAttributeColor:RGB(21, 21, 21) andAttributeFont:kHXBFont_PINGFANGSC_REGULAR(12)];
    NSArray *arr = [withdrawRecordModel.applyTimeStr componentsSeparatedByString:@" "]; // 2017-09-28,12:04
    NSArray *arr1 = [arr[0] componentsSeparatedByString:@"-"]; // 2017,09,28
    self.applyDateLabel.text = [NSString stringWithFormat:@"%@日",arr1.lastObject];
    self.applyTimeLabel.text = arr.lastObject;
}

#pragma mark - Lazy
- (UILabel *)cashAmountLabel {
    if (!_cashAmountLabel) {
        _cashAmountLabel = [[UILabel alloc] init];
        _cashAmountLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
        _cashAmountLabel.textColor = COR6;
    }
    return _cashAmountLabel;
}
- (UILabel *)bankNameLabel {
    if (!_bankNameLabel) {
        _bankNameLabel = [[UILabel alloc] init];
        _bankNameLabel.textAlignment = NSTextAlignmentRight;
        _bankNameLabel.font = kHXBFont_PINGFANGSC_REGULAR(12);
        _bankNameLabel.textColor = COR10;
    }
    return _bankNameLabel;
}
- (UILabel *)logDescLabel {
    if (!_logDescLabel) {
        _logDescLabel = [[UILabel alloc] init];
        _logDescLabel.textAlignment = NSTextAlignmentLeft;
        _logDescLabel.font = kHXBFont_PINGFANGSC_REGULAR(12);
        _logDescLabel.textColor = RGB(21, 21, 21);
    }
    return _logDescLabel;
}
- (UILabel *)applyDateLabel {
    if (!_applyDateLabel) {
        _applyDateLabel = [[UILabel alloc] init];
        _applyDateLabel.textAlignment = NSTextAlignmentLeft;
        _applyDateLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
        _applyDateLabel.textColor = kHXBColor_333333_100;
    }
    return _applyDateLabel;
}
- (UILabel *)applyTimeLabel {
    if (!_applyTimeLabel) {
        _applyTimeLabel = [[UILabel alloc] init];
        _applyTimeLabel.textAlignment = NSTextAlignmentLeft;
        _applyTimeLabel.font = kHXBFont_PINGFANGSC_REGULAR(12);
        _applyTimeLabel.textColor = RGB(146, 149, 162);
    }
    return _applyTimeLabel;
}

-(UIView *)partingLineView {
    if (!_partingLineView) {
        _partingLineView = [[UIView alloc] init];
        _partingLineView.backgroundColor = RGB(245, 245, 249);
    }
    return _partingLineView;
}
-(UIView *)circularPointView {
    if (!_circularPointView) {
        _circularPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScrAdaptationW(9), kScrAdaptationW(9))];
        _circularPointView.layer.masksToBounds = YES;
        _circularPointView.layer.cornerRadius = _circularPointView.frame.size.width/2;
        _circularPointView.backgroundColor = COR12;
    }
    return _circularPointView;
}
@end
