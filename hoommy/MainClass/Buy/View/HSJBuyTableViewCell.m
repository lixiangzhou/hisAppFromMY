//
//  HSJBuyTableViewCell.m
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBuyTableViewCell.h"

@interface HSJBuyTableViewCell()

@property (nonatomic, strong) UIImageView *iconImv;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *descripLb;
@property (nonatomic, strong) UIImageView *arrowImv;
@property (nonatomic, strong) UILabel *arrowLb;
@property (nonatomic, strong) UIImageView *lineImv;

@property (nonatomic, strong) HSJBuyCellModel *cellModel;
@end

@implementation HSJBuyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        [self setupUI];
        [self setupConstraints];
    }
    
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.iconImv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImv];
    
    self.titleLb = [[UILabel alloc] init];
    self.titleLb.numberOfLines = 0;
    [self.contentView addSubview:self.titleLb];
    
    self.descripLb = [[UILabel alloc] init];
    self.descripLb.textColor = kHXBFontColor_333333_100;
    self.descripLb.font = kHXBFont_28;
    self.descripLb.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.descripLb];
    
    self.arrowLb = [[UILabel alloc] init];
    self.arrowLb.textColor = kHXBFontColor_4C7BFE_100;
    self.arrowLb.font = kHXBFont_26;
    self.arrowLb.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.arrowLb];
    
    self.arrowImv = [[UIImageView alloc] init];
    self.arrowImv.image = [UIImage imageNamed:@"next"];
    [self.contentView addSubview:self.arrowImv];
    
    self.lineImv = [[UIImageView alloc] init];
    self.lineImv.backgroundColor = kHXBColor_ECECEC_100;
    [self.contentView addSubview:self.lineImv];
}

- (void)setupConstraints {
    [self.iconImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kScrAdaptationW(15));
        make.width.height.mas_equalTo(kScrAdaptationW(24));
        make.centerY.equalTo(self.contentView);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImv.mas_right).offset(kScrAdaptationW(10.5));
        make.top.bottom.equalTo(self.contentView);
    }];
    [self.descripLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kScrAdaptationW(15));
        make.top.bottom.equalTo(self.contentView);
    }];
    [self.arrowImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kScrAdaptationW(15));
        make.width.mas_equalTo(kScrAdaptationW(6.3));
        make.height.mas_equalTo(kScrAdaptationH(11));
        make.centerY.equalTo(self.contentView);
    }];
    [self.arrowLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImv.mas_left).offset(-kScrAdaptationW(9.5));
        make.top.bottom.equalTo(self.contentView);
    }];
    [self.lineImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.right.bottom.equalTo(self.contentView);
    }];
}

- (void)bindData:(BOOL)isLastItem cellDataModel:(HSJBuyCellModel*)model {
    if(isLastItem) {
        [self.lineImv mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
        }];
    }
    else {
        [self.lineImv mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kScrAdaptationW(49));
        }];
    }
    
    self.cellModel = model;
}

- (void)setCellModel:(HSJBuyCellModel *)cellModel {
    _cellModel = cellModel;
    
    if(cellModel.isDisable){
        self.contentView.alpha = 0.4;
    }
    else {
        self.contentView.alpha = 1;
    }
    
    if(cellModel.isSvnImage) {
        self.iconImv.svgImageString = cellModel.iconName;
    }
    else{
        self.iconImv.image = [UIImage imageNamed:cellModel.iconName];
    }
    
    self.titleLb.attributedText = cellModel.title;
    self.descripLb.text = cellModel.descripText;
    self.arrowLb.text = cellModel.arrowText;
    
    if(cellModel.isShowArrow) {
        self.arrowImv.hidden = NO;
        self.descripLb.hidden = YES;
        self.arrowLb.hidden = NO;
        self.userInteractionEnabled = YES;
    }
    else {
        self.arrowImv.hidden = YES;
        self.descripLb.hidden = NO;
        self.arrowLb.hidden = YES;
        self.userInteractionEnabled = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
