//
//  HSJBuyViewModel.h
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"
#import "HSJBuyCellModel.h"
#import "HSJPlanModel.h"

@interface HSJBuyViewModel : HSJBaseViewModel
//网络数据

@property (nonatomic, strong) HSJPlanModel *planModel;
@property (nonatomic, strong) HXBUserInfoModel *userInfoModel;
//逻辑处理数据

//cell数据源
@property (nonatomic, strong) NSArray *cellDataList;
@property (nonatomic, copy) NSString *inputMoney;
//是否显示风险提示
@property (nonatomic, assign, readonly) BOOL isShowRiskAgeement;
//按钮显示文本
@property (nonatomic, strong, readonly) NSString *buttonShowContent;
///加入条件加入金额%@元起，%@元的整数倍递增
@property (nonatomic,strong, readonly) NSString *addCondition;

//加入上线
@property (nonatomic, assign, readonly) float addUpLimit;

//构建cell数据源
- (void)buildCellDataList;
//校验数据
- (BOOL)checkMoney:(void (^)(BOOL isLess))LessthanStartMoneyBLock;
//校验协议勾选
- (BOOL)checkAgreement:(BOOL)isAgreementGroup agreeRiskApplyAgreement:(BOOL)isAgreeRiskApplyAgreement;

@end
