//
//  HSJRollOutHistoryViewModel.h
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"
#import "HSJRollOutViewModel.h"

typedef enum : NSUInteger {
    HSJRollOutPlanTypeExiting = 1,
    HSJRollOutPlanTypeExited,
} HSJRollOutPlanType;

@interface HSJRollOutHistoryViewModel : HSJBaseViewModel
@property (nonatomic, strong) NSMutableArray<HSJRollOutModel *> *exitedDataSource;
@property (nonatomic, strong) NSMutableArray<HSJRollOutModel *> *exitingDataSource;

/// 计划列表 HSJRollOutPlanTypeExiting: 转出中 HSJRollOutPlanTypeExited: 已转出
- (void)getPlansWithType:(HSJRollOutPlanType)type isNew:(BOOL)isNew resultBlock:(void(^)(BOOL isSuccess))resultBlock;
@end
