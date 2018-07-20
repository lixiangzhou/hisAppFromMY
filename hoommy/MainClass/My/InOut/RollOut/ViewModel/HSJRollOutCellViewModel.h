//
//  HSJRollOutCellViewModel.h
//  hoommy
//
//  Created by lxz on 2018/7/19.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"
#import "HSJRollOutModel.h"

@interface HSJRollOutCellViewModel : HSJBaseViewModel
@property (nonatomic, strong) HSJRollOutModel *model;

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL isSelected;

/// 待转金额
@property (nonatomic, copy) NSString *leftAccountString;
/// 加入金额
@property (nonatomic, copy) NSString *joinInString;
/// 累计收益
@property (nonatomic, copy) NSString *earnInterestString;
/// 状态
@property (nonatomic, copy) NSString *statusString;

@property (nonatomic, assign) HSJStepUpStatus stepupStatus;
@property (nonatomic, assign) BOOL statusBtnEnabled;
@property (nonatomic, assign) NSInteger statusLineNum;

/// Cell 背景色
@property (nonatomic, strong) UIColor *backgroundColor;
/// 状态颜色
@property (nonatomic, strong) UIColor *statusTextColor;
/// 状态字体
@property (nonatomic, strong) UIFont *statusFont;

/// 待转金额颜色
@property (nonatomic, strong) UIColor *leftAccountColor;
/// 待转金额描述颜色
@property (nonatomic, strong) UIColor *leftAccountDescColor;

/// 加入金额颜色
@property (nonatomic, strong) UIColor *joinInColor;
/// 加入金额颜色
@property (nonatomic, strong) UIColor *joinInDescColor;

/// 累计收益颜色
@property (nonatomic, strong) UIColor *earnAccountColor;
/// 累计收益描述颜色
@property (nonatomic, strong) UIColor *earnAccountDescColor;
@end
