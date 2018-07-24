//
//  HSJRollOutDetailCell.m
//  hoommy
//
//  Created by lxz on 2018/7/23.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJRollOutDetailCell.h"

NSString *const HSJRollOutDetailCellIdentifier = @"HSJRollOutDetailCellIdentifier";

@interface HSJRollOutDetailCell ()
@property (nonatomic, weak) UILabel *leftLabel;
@property (nonatomic, weak) UILabel *rightLabel;

@property (nonatomic, weak) UIImageView *arrowView;
@property (nonatomic, weak) UIView *bottomLine;
@end

@implementation HSJRollOutDetailCell

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
    UILabel *leftLabel = [UILabel new];
    leftLabel.textColor = kHXBColor_333333_100;
    leftLabel.font = kHXBFont_28;
    [self.contentView addSubview:leftLabel];
    self.leftLabel = leftLabel;
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.textColor = kHXBColor_666666_100;
    rightLabel.font = kHXBFont_28;
    [self.contentView addSubview:rightLabel];
    self.rightLabel = rightLabel;
    
    UIImageView *arrowView = [UIImageView new];
    arrowView.image = [UIImage imageNamed:@"next"];
    [self.contentView addSubview:arrowView];
    self.arrowView = arrowView;
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = kHXBColor_ECECEC_100;
    [self.contentView addSubview:bottomLine];
    self.bottomLine = bottomLine;
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@kScrAdaptationW(15));
        make.centerY.equalTo(self.contentView);
    }];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@kScrAdaptationW(-15));
        make.centerY.equalTo(self.contentView);
    }];
    
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(rightLabel);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightLabel);
        make.left.equalTo(leftLabel);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@kScrAdaptationW(0.5));
    }];
}

#pragma mark - Setter / Getter / Lazy
- (void)setModel:(HSJRollOutPlanDetailRowModel *)model {
    _model = model;
    
    self.leftLabel.text = model.left;
    self.rightLabel.text = model.right;
    
    self.rightLabel.textColor = model.rightLabelColor;
    self.rightLabel.hidden = model.type != HSJRollOutPlanDetailRowTypeNormal;
    self.arrowView.hidden = model.type == HSJRollOutPlanDetailRowTypeNormal;
}

- (void)setHideBottomLine:(BOOL)hideBottomLine {
    _hideBottomLine = hideBottomLine;
    
    self.bottomLine.hidden = hideBottomLine;
}

@end
