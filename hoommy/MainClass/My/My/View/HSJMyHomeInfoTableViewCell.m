//
//  HSJMyHomeInfoTableViewCell.m
//  hoommy
//
//  Created by hxb on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJMyHomeInfoTableViewCell.h"
#import <ReactiveObjC.h>

static NSUInteger const DESC_BASE_TAG = 500;
static NSUInteger const BG_BASE_TAG = 600;

@implementation HSJMyHomeInfoModel
@end

@implementation HSJMyHomeInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    kWeakSelf
    for (int i=0; i<2; i++) {
        UIImageView *bg = [UIImageView new];
        [self.contentView addSubview:bg];
        
        bg.userInteractionEnabled = YES;
        bg.tag = BG_BASE_TAG + i;
        
        NSUInteger spacing = kScrAdaptationW750(30);
        NSUInteger width = kScrAdaptationW750(330);
        [bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(spacing+i*(spacing+width));
            make.top.equalTo(weakSelf.contentView).offset(kScrAdaptationH750(50));
            make.bottom.equalTo(weakSelf.contentView).offset(-kScrAdaptationH750(40));
            make.width.mas_equalTo(width);
        }];
        
        UIImageView *leftIcon = [UIImageView new];
        [bg addSubview:leftIcon];
        [leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(bg).offset(kScrAdaptationW750(54));
            make.width.height.equalTo(@kScrAdaptationW750(78));
        }];
        
        UILabel *titleLab = [UILabel new];
        [bg addSubview:titleLab];
        
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.font = kHXBFont_PINGFANGSC_REGULAR_750(28);
        titleLab.text = @"--";
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftIcon.mas_right).offset(kScrAdaptationW750(32));
            make.height.equalTo(@kScrAdaptationH750(40));
            make.right.equalTo(bg).offset(-kScrAdaptationW750(15));
            make.top.mas_equalTo(bg).offset(kScrAdaptationH750(50));
        }];
        
        UILabel *desc = [UILabel new];
        [bg addSubview:desc];
        desc.tag = DESC_BASE_TAG+i;
        desc.textAlignment = NSTextAlignmentLeft;
        desc.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
        desc.text = @"--";
        
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(titleLab);
            make.height.equalTo(@kScrAdaptationH750(34));
            make.top.equalTo(titleLab.mas_bottom).offset(kScrAdaptationH750(6));
        }];
        
        if (i == 0) {
            bg.backgroundColor = RGB(252, 247, 246);
            titleLab.text = @"银行卡";
            leftIcon.image = [UIImage imageNamed:@"my_Bank"];
            [titleLab setTextColor:RGB(236, 133, 114)];
            [desc setTextColor:RGB(236, 133, 114)];
        } else {
            bg.backgroundColor = RGB(245, 248, 255);
            titleLab.text = @"风险测评";
            leftIcon.image = [UIImage imageNamed:@"my_Evaluating"];
            [titleLab setTextColor:RGB(142, 154, 196)];
            [desc setTextColor:RGB(142, 154, 196)];
        }
    }
}

- (void)setInfoModelArr:(NSArray<HSJMyHomeInfoModel *> *)infoModelArr {
    _infoModelArr = infoModelArr;
    
    if (infoModelArr.count < 2) {
        return;
    }
    self.accessoryType = UITableViewCellAccessoryNone;
    
    for (int i=0; i<2; i++) {
        HSJMyHomeInfoModel *model = _infoModelArr[i];
        UILabel * descLab = (UILabel *)[self viewWithTag:DESC_BASE_TAG+i];
        descLab.text = model.desc;
        
        UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
        [tap addTarget:self action:@selector(clickBlock:)];
        [[self viewWithTag:BG_BASE_TAG+i] addGestureRecognizer:tap];
    }
}

- (void)clickBlock:(UITapGestureRecognizer *)tap {
    NSInteger type = tap.view.tag - BG_BASE_TAG;
    if (_infoModelArr[type].infoBlock) {
        _infoModelArr[type].infoBlock(type);
    }
}

@end
