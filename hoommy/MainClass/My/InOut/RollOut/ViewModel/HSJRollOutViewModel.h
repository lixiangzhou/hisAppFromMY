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

@interface HSJRollOutViewModel : HSJBaseViewModel
@property (nonatomic, strong) HSJPlanAssetsModel *assetsModel;
@property (nonatomic, strong) NSMutableArray<HSJRollOutModel *> *dataSource;

/// 资产统计
- (void)getAssets:(void(^)(BOOL isSuccess))resultBlock;
/// 计划列表
- (void)getPlans:(BOOL)isNew resultBlock:(void(^)(BOOL isSuccess))resultBlock;
@end
