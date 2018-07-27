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
#import "HXBFinModel_BuyResoult_PlanModel.h"

typedef enum : NSUInteger {
    HSJBUYBUTTON_BINDCARD,
    HSJBUYBUTTON_NOMONEY,
    HSJBUYBUTTON_WITHMONEY,
    HSJBUYBUTTON_TIMER,
    HSJBUYBUTTON_JOIN,
    HSJBUYBUTTON_EXITED
} HSJBUYBUTTON_TYPE;

@interface HSJBuyViewModel : HSJBaseViewModel
//网络数据

@property (nonatomic, strong) HSJPlanModel *planModel;
@property (nonatomic, strong) HXBUserInfoModel *userInfoModel;
@property (nonatomic, strong) HXBFinModel_BuyResoult_PlanModel *resultModel;
@property (nonatomic, assign) NSInteger buyErrorCode;
@property (nonatomic, copy) NSString *buyErrorMessage;

//逻辑处理数据

//cell数据源
@property (nonatomic, strong) NSArray *cellDataList;
@property (nonatomic, copy) NSString *inputMoney;
//是否显示风险提示
@property (nonatomic, assign, readonly) BOOL isShowRiskAgeement;
//按钮显示文本
@property (nonatomic, strong, readonly) NSString *buttonShowContent;
//按钮类型
@property (nonatomic, assign, readonly) HSJBUYBUTTON_TYPE buttonType;
///加入条件加入金额%@元起，%@元的整数倍递增
@property (nonatomic,strong, readonly) NSString *addCondition;
//购买类型（balance：余额购买；recharge：银行卡充值购买）
@property (nonatomic, strong, readonly) NSString *buyType;
//加入上线
@property (nonatomic, assign, readonly) float addUpLimit;

//构建cell数据源
- (void)buildCellDataList;
//校验数据
- (BOOL)checkMoney:(void (^)(BOOL isLess))lessthanStartMoneyBLock;
//校验协议勾选
- (BOOL)checkAgreement:(BOOL)isAgreementGroup agreeRiskApplyAgreement:(BOOL)isAgreeRiskApplyAgreement;
//开启倒计时
- (BOOL)startCountDownTimer:(void (^)(void)) timerBlock;

#pragma mark 网络接口
//购买
- (void)planBuyReslutWithPlanID: (NSString *)planID
                     parameter : (NSDictionary *)parameter
                    resultBlock: (void(^)(BOOL isSuccess))resultBlock;
/**
 获取充值短验
 @param amount 充值金额
 @param action 判断是否为提现或者充值
 @param type 短信验证码或是语言验证码
 @param resultBlock 请求回调
 */
- (void)getVerifyCodeRequesWithRechargeAmount:(NSString *)amount andWithType:(NSString *)type  andWithAction:(NSString *)action resultBlock:(NetWorkResponseBlock)resultBlock;
@end
