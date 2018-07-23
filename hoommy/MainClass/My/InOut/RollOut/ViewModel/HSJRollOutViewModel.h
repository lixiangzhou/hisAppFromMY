//
//  HSJRollOutViewModel.h
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"
#import "HSJPlanAssetsModel.h"
#import "HSJRollOutModel.h"
#import "HSJRollOutCellViewModel.h"

@interface HSJRollOutViewModel : HSJBaseViewModel
@property (nonatomic, strong) HSJPlanAssetsModel *assetsModel;
@property (nonatomic, strong) NSMutableArray<HSJRollOutCellViewModel *> *dataSource;
@property (nonatomic, assign) HSJRefreshFooterType footerType;

/// 是否处于编辑状态
@property (nonatomic, assign) BOOL editing;

/// 是否有可转出的计划
@property (nonatomic, assign) BOOL hasQuitPlans;
/// 待转让金额
@property (nonatomic, copy) NSString *amount;

@property (nonatomic, strong) NSMutableArray *selectedViewModels;
@property (nonatomic, strong) NSMutableArray *selectedIds;

/// 资产统计
- (void)getAssets:(void(^)(BOOL isSuccess))resultBlock;
/// 计划列表
- (void)getPlans:(BOOL)isNew resultBlock:(void(^)(BOOL isSuccess))resultBlock;

/// 计算金额
- (void)calAmount;
@end
