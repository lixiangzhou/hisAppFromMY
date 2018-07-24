//
//  HSJRollOutCellViewModel.m
//  hoommy
//
//  Created by lxz on 2018/7/19.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJRollOutCellViewModel.h"
#import "NSString+HxbPerMilMoney.h"


@implementation HSJRollOutCellViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isEditing = NO;
        _isSelected = NO;
    }
    return self;
}

- (void)setModel:(HSJRollOutModel *)model {
    _model = model;

    NSString *leftAccountString = [NSString GetPerMilWithDouble:self.model.redProgressLeft.doubleValue];
    self.leftAccountString = [leftAccountString isEqualToString:@"0"] ? @"0.00" : leftAccountString;
    
    NSString *joinInString = [NSString GetPerMilWithDouble:self.model.finalAmount.doubleValue];
    joinInString = [joinInString isEqualToString:@"0"] ? @"0.00" : joinInString;
    self.joinInString = [NSString stringWithFormat:@"%@元", joinInString];
    
    NSString *earnInterestString = [NSString GetPerMilWithDouble:self.model.earnAmount.doubleValue];
    earnInterestString = [earnInterestString isEqualToString:@"0"] ? @"0.00" : earnInterestString;
    self.earnInterestString = [NSString stringWithFormat:@"%@元", earnInterestString];

    [self setStatus];
    
    [self updateData];
}

- (void)setStatus {
    if ([self.model.stepUpPlanStatus isEqualToString:@"QUIT"]) {
        self.stepupStatus = HSJStepUpStatusQUIT;
        self.statusString = @"转出";
    } else if ([self.model.stepUpPlanStatus isEqualToString:@"NOQUIT"]) {
        self.stepupStatus = HSJStepUpStatusNOQUIT;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.endLockingTime.doubleValue / 1000];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"MM月dd日";
        NSString *dateString = [df stringFromDate:date];
        self.statusString = [NSString stringWithFormat:@"%@\n可转", dateString];
    } else if ([self.model.stepUpPlanStatus isEqualToString:@"QUITING"]) {
        self.stepupStatus = HSJStepUpStatusQUITING;
        self.statusString = @"转出中";
    }
}

- (void)setIsEditing:(BOOL)isEditing {
    _isEditing = isEditing;
    [self updateData];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    [self updateData];
}

- (void)updateData {
    self.backgroundColor = [UIColor whiteColor];
    
    self.leftAccountColor = kHXBColor_FF7055_100;
    self.leftAccountDescColor = kHXBColor_999999_100;
    
    self.joinInColor = kHXBColor_333333_100;
    self.joinInDescColor = kHXBColor_999999_100;
    
    self.earnAccountColor = kHXBColor_333333_100;
    self.earnAccountDescColor = kHXBColor_999999_100;
    
    self.statusLineNum = self.stepupStatus == HSJStepUpStatusNOQUIT ? 2 : 1;
    
    self.selectBtnEnabled = NO;
    
    switch (self.stepupStatus) {
        case HSJStepUpStatusQUITING:
        {
            self.statusTextColor = kHXBColor_999999_100;
            self.statusFont = kHXBFont_28;
            self.statusBtnEnabled = NO;
        }
            break;
        case HSJStepUpStatusQUIT:
        {
            self.statusTextColor = kHXBColor_D1A666_100;
            self.statusFont = kHXBFont_28;
            self.statusBtnEnabled = YES;
        }
            break;
        case HSJStepUpStatusNOQUIT:
        {
            self.statusTextColor = kHXBColor_999999_100;
            self.statusFont = kHXBFont_24;
            self.statusBtnEnabled = NO;
        }
            break;
    }
    
    if (self.isEditing) {
        self.statusBtnEnabled = NO;
        if (self.stepupStatus == HSJStepUpStatusQUITING || self.stepupStatus == HSJStepUpStatusNOQUIT) {
            self.leftAccountColor = kHXBColor_FF7055_40;
            self.leftAccountDescColor = kHXBColor_999999_40;
            
            self.joinInColor = kHXBColor_333333_40;
            self.joinInDescColor = kHXBColor_999999_40;
            
            self.earnAccountColor = kHXBColor_333333_40;
            self.earnAccountDescColor = kHXBColor_999999_40;
            
            self.statusTextColor = kHXBColor_999999_40;
            self.statusFont = self.stepupStatus == HSJStepUpStatusNOQUIT ? kHXBFont_24 : kHXBFont_28;
            
            self.selectImage = [UIImage imageNamed:@"account_plan_list_disable"];
        } else {
            self.selectBtnEnabled = YES;
            
            self.statusTextColor = kHXBColor_D1A666_40;
            if (self.isSelected == NO) {
                self.statusFont = kHXBFont_28;
                
                self.selectImage = [UIImage imageNamed:@"account_plan_list_unselected"];
            } else {
                self.backgroundColor = UIColorFromRGB(0xFFF9F8);
                
                self.selectImage = [UIImage imageNamed:@"account_plan_list_selected"];
            }
        }
    }
    
}
@end
