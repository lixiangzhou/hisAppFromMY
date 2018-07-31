//
//  HSJPlanDetailViewModel.h
//  hoommy
//
//  Created by lxz on 2018/7/13.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSJBaseViewModel.h"
#import "HSJPlanModel.h"

@interface HSJPlanDetailViewModel : HSJBaseViewModel

@property (nonatomic, strong) HSJPlanModel *planModel;

/// 基础利率 + 加息利率
@property (nonatomic, copy) NSString *interestString;
/// 是否新手
@property (nonatomic, assign) BOOL isNew;
/// 基础年利率
@property (nonatomic, copy) NSString *baseInterestString;
/// 锁定期
@property (nonatomic, copy) NSString *lockString;
/// 开始计息时间
@property (nonatomic, copy) NSString *startDateString;
/// 锁定期结束时间，解除锁定时间
@property (nonatomic, copy) NSString *endLockDateString;
/// 利率 用于计算器计算用
@property (nonatomic, assign) double interest;
/// 是否投资过
@property (nonatomic, assign) BOOL hasBuy;

/// 转入的属性
@property (nonatomic, strong) UIColor *inTextColor;
@property (nonatomic, strong) UIImage *inBackgroundImage;
@property (nonatomic, copy) NSString *inText;
@property (nonatomic, assign) BOOL inEnabled;

@property (nonatomic, copy) void (^timerBlock)(void);


- (void)getDataWithId:(NSString *)planId resultBlock:(void(^)(BOOL isSuccess))resultBlock;
- (void)riskTypeAssementFrom:(UIViewController *)controller;
@end
