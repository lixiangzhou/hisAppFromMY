//
//  HXBAccountSecureCell.m
//  hoomxb
//
//  Created by lxz on 2017/12/11.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBAccountSecureCell.h"
#import "NSString+HXBPhonNumber.h"
#import <ReactiveObjC.h>
@implementation HXBAccountSecureModel
@end
@interface HXBAccountSecureCell ()
@property (nonatomic,strong) UILabel *descLab;
@property (nonatomic,strong) UIImageView *arrowView;
@end

@implementation HXBAccountSecureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.textLabel.font = kHXBFont_PINGFANGSC_REGULAR(15);
        self.textLabel.textColor = COR6;
        [self.contentView addSubview:self.descLab];
        [self.contentView addSubview:self.arrowView];
        kWeakSelf
        [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.descLab);
            make.right.equalTo(weakSelf).offset(kScrAdaptationW(-15));
        }];
    }
    return self;
}

- (void)setModel:(HXBAccountSecureModel *)model {
    _model = model;
    self.textLabel.text = model.title;
    
    if (model.type == HXBAccountSecureTypeGesturePwdSwitch) {
        
        self.arrowView.hidden = YES;
        UISwitch *switchView = [UISwitch new];
        NSString *skip = KeyChain.skipGesture;
        BOOL isOn = NO;
        if (![skip isEqual:kHXBGesturePwdSkipeNONE]) {
            isOn = ![skip isEqualToString:kHXBGesturePwdSkipeYES];
        }
        switchView.on = isOn;
        [[switchView rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UISwitch * _Nullable x) {
            model.switchBlock(x.isOn);
        }];
        
        self.accessoryView = switchView;
    } else if (model.type == HXBAccountSecureTypeAboutUs || model.type == HXBAccountSecureTypeCommonProblems) {
        self.arrowView.hidden = YES;
        self.accessoryView = nil;
    } else {
        self.descLab.hidden = NO;
        self.descLab.textAlignment = NSTextAlignmentRight;
        self.descLab.font = kHXBFont_PINGFANGSC_REGULAR(14);
        self.descLab.textColor = [UIColor colorWithRed:146/255.0f green:149/255.0f blue:162/255.0f alpha:1] ;
        self.arrowView.hidden = model.type == HXBAccountSecureTypeExitAccount;
        if (model.type == HXBAccountSecureTypeModifyPhone) {
            self.descLab.text = [KeyChain.mobile hxb_hiddenPhonNumberWithMid];
        } else {
            self.descLab.text = @"修改";
        }
        
        kWeakSelf
        [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.left).offset(kScrAdaptationW(263));
            make.centerY.equalTo(weakSelf);
            make.height.equalTo(@kScrAdaptationH(18));
            make.width.equalTo(@kScrAdaptationW(80));
        }];
        self.accessoryView = nil;
    }
}

- (UILabel *)descLab {
    if (!_descLab) {
        _descLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _descLab.hidden = YES;
    }
    return _descLab;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [UIImageView new];
        _arrowView.image = [UIImage imageNamed:@"next_arrow"];
    }
    return _arrowView;
}

@end
