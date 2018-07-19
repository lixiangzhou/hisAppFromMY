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

@implementation HXBAccountSecureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = kHXBFont_PINGFANGSC_REGULAR(15);
        self.textLabel.textColor = COR6;
    }
    return self;
}

- (void)setModel:(HXBAccountSecureModel *)model {
    _model = model;
    self.textLabel.text = model.title;
    
    if (model.type == HXBAccountSecureTypeGesturePwdSwitch) {
        self.accessoryType = UITableViewCellAccessoryNone;
        UISwitch *switchView = [UISwitch new];
        NSString *skip = KeyChain.skipGesture;
        BOOL isOn = NO;
        if (skip != nil) {
            isOn = ![skip isEqualToString:kHXBGesturePwdSkipeYES];
        }
        switchView.on = isOn;
        [[switchView rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UISwitch * _Nullable x) {
            model.switchBlock(x.isOn);
        }];
        self.accessoryView = switchView;
    } else if (model.type == HXBAccountSecureTypeAboutUs || model.type == HXBAccountSecureTypeCommonProblems) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.accessoryView = nil;
    } else {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:lab];
        lab.textAlignment = NSTextAlignmentRight;
        lab.font = kHXBFont_PINGFANGSC_REGULAR(14);
        lab.textColor = [UIColor colorWithRed:146/255.0f green:149/255.0f blue:162/255.0f alpha:1] ;
        if (model.type == HXBAccountSecureTypeModifyPhone) {
            lab.text = [KeyChain.mobile hxb_hiddenPhonNumberWithMid];
        } else {
            lab.text = @"修改";
        }
        
        kWeakSelf
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.left).offset(kScrAdaptationW(250));
            make.centerY.equalTo(weakSelf);
            make.height.equalTo(@kScrAdaptationH(18));
            make.width.equalTo(@kScrAdaptationW(80));
        }];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.accessoryView = nil;
    }
}

@end
