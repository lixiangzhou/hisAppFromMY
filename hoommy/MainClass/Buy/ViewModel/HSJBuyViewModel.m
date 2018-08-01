//
//  HSJBuyViewModel.m
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBuyViewModel.h"
#import "HXBNsTimerManager.h"

@interface HSJBuyViewModel()
@property (nonatomic, assign, readonly) BOOL isAbleleftMoneyCellItem;
@property (nonatomic, assign, readonly) BOOL isAbleBankCellItem;

@property (nonatomic, strong) HXBNsTimerManager *timerManager;
//倒计时,对应的文本变化
@property (nonatomic, strong) NSString *timerContent;
@end

@implementation HSJBuyViewModel
- (void)dealloc
{
    [self.timerManager stopTimer];
}

#pragma mark 数据请求处理
- (instancetype)init {
    self = [super init];
    if(self) {
        self.isFilterHugHidden = NO;
    }
    return self;
}

- (BOOL)erroStateCodeDeal:(NYBaseRequest *)request response:(NSDictionary *)responseObject {
    if([request.requestUrl containsString:@"/result"]) {
        return NO;
    }
    
    return [super erroStateCodeDeal:request response:responseObject];
}

- (void)hideProgress:(NYBaseRequest *)request {
    if(!self.isLoadingData) {
        [super hideProgress:request];
    }
}

/**
 计划购买
 
 @param planID 计划id
 @param parameter 请求参数
 @param resultBlock 返回数据
 */
- (void)planBuyReslutWithPlanID: (NSString *)planID
                     parameter : (NSDictionary *)parameter
                    resultBlock: (void(^)(BOOL isSuccess))resultBlock {
    NYBaseRequest *request = [[NYBaseRequest alloc] initWithDelegate:self];
    request.requestMethod = NYRequestMethodPost;
    request.requestUrl = kHXBFin_Plan_ConfirmBuyReslutURL(planID);
    request.requestArgument = parameter;
    request.showHud = YES;
    request.hudShowContent = @"安全支付";
    kWeakSelf
    [request loadData:^(NYBaseRequest *request, NSDictionary *responseObject) {
        NSDictionary *data = responseObject[kResponseData];
        weakSelf.resultModel = [[HXBFinModel_BuyResoult_PlanModel alloc] initWithDictionary:data];
        if (resultBlock) resultBlock(YES);
    } failure:^(NYBaseRequest *request, NSError *error) {
        NSDictionary *responseObject = error.userInfo;
        if (responseObject) {
            NSInteger status = [responseObject[kResponseStatus] integerValue];
            weakSelf.buyErrorMessage = responseObject[kResponseMessage];
            NSString *errorType = responseObject[kResponseErrorData][@"errorType"];
            if (status) {
                if ([errorType isEqualToString:@"TOAST"]) {
                    UINavigationController *navVC = [HXBRootVCManager manager].mainTabbarVC.selectedViewController;
                    [HxbHUDProgress showTextInView:navVC.topViewController.view text:responseObject[@"message"]];
                    status = kBuy_Toast;
                } else if ([errorType isEqualToString:@"RESULT"]) {
                    status = kBuy_Result;
                } else if ([errorType isEqualToString:@"PROCESSING"]) {
                    status = kBuy_Processing;
                }
                weakSelf.buyErrorCode = status;
            }
        }
        if (resultBlock) resultBlock(NO);
    }];
}

/**
 获取充值短验
 @param amount 充值金额
 @param action 判断是否为提现或者充值
 @param type 短信验证码或是语言验证码
 @param resultBlock 请求回调
 */
- (void)getVerifyCodeRequesWithRechargeAmount:(NSString *)amount andWithType:(NSString *)type  andWithAction:(NSString *)action resultBlock:(NetWorkResponseBlock)resultBlock {
    [self verifyCodeRequestWithResultBlock:^(NYBaseRequest *request) {
        request.requestArgument = @{
                                    @"amount" : amount,
                                    @"action":action,
                                    @"type":type
                                    };
        request.showHud = YES;
    } resultBlock:^(id responseObject, NSError *error) {
        if(resultBlock) {
            resultBlock(responseObject, error);
        }
    }];
}

#pragma  mark 逻辑处理

- (BOOL)isAbleBankCellItem {
    double money = self.inputMoney.doubleValue;
    BOOL isAble = YES;
    if(self.userInfoModel.userAssets.availablePoint.doubleValue >= money) {
        isAble = NO;
    }
    return isAble;
}

- (BOOL)isAbleleftMoneyCellItem {
    BOOL isAble = YES;
    if(0 == self.userInfoModel.userAssets.availablePoint.doubleValue) {
        isAble = NO;
    }
    return isAble;
    
}

- (BOOL)isShowRiskAgeement {
    double money = self.inputMoney.doubleValue;
    return (money > self.userInfoModel.userAssets.userRiskAmount.doubleValue - self.userInfoModel.userAssets.holdingAmount);
}

- (NSString *)addCondition {
    NSString *addCondition = nil;
    if (self.planModel.isFirst.boolValue) {
        addCondition = [NSString stringWithFormat:@"%@起投，%@递增",[NSString hxb_getPerMilWithIntegetNumber:self.planModel.minRegisterAmount.doubleValue],[NSString hxb_getPerMilWithIntegetNumber:self.planModel.registerMultipleAmount.doubleValue]];
    } else {
        addCondition = [NSString stringWithFormat:@"%@的倍数递增",[NSString hxb_getPerMilWithIntegetNumber:self.planModel.registerMultipleAmount.doubleValue]];
        
    }
    return addCondition;
}

- (NSString *)buttonShowContent {
    NSString *content = @"";
    switch (self.buttonType) {
        case HSJBUYBUTTON_WITHMONEY:
        {
            double money = self.inputMoney.doubleValue;
            content = [NSString stringWithFormat:@"立即转入%.2lf元", money];
            break;
        }
        case HSJBUYBUTTON_NOMONEY:
            content = @"立即转入";
            break;
        case HSJBUYBUTTON_TIMER:
            content = self.timerContent;
            break;
        case HSJBUYBUTTON_BINDCARD:
            content = @"添加银行卡";;
            break;
        case HSJBUYBUTTON_EXITED:
            content = @"销售结束";
            break;
            
        default:
            content = @"立即转入";
            break;
    }
    
    return content;
}

- (HSJBUYBUTTON_TYPE)buttonType {
    HSJBUYBUTTON_TYPE buttonType;
    if(self.timerManager.isTimerWorking) {
        buttonType = HSJBUYBUTTON_TIMER;
    }
    else {
        buttonType = [self buttonTypeByPlanState];
        if(buttonType == HSJBUYBUTTON_JOIN) {
            buttonType = HSJBUYBUTTON_BINDCARD;
            if(self.userInfoModel.userInfo.hasBindCard.boolValue) {
                double money = self.inputMoney.doubleValue;
                buttonType = HSJBUYBUTTON_NOMONEY;
                if(money > 0) {
                    buttonType = HSJBUYBUTTON_WITHMONEY;
                }
            }
        }
    }
    return buttonType;
}

- (HSJBUYBUTTON_TYPE)buttonTypeByPlanState {
    HSJBUYBUTTON_TYPE type;
    switch ([self.planModel.unifyStatus integerValue]) {
        case 0://等待预售开始超过30分
        case 1://等待预售开始小于30分钟
        case 2://预定
        case 3://预定满额
        case 4://等待开放购买大于30分钟
        case 5://等待开放购买小于30分钟
            type = HSJBUYBUTTON_EXITED;
            break;
        case 6:
            type = HSJBUYBUTTON_JOIN;
            break;
        case 7://销售结束
        case 8://收益中
        case 9://开放期
        case 10://已退出
            type = HSJBUYBUTTON_EXITED;
            break;
        default:
            type = HSJBUYBUTTON_JOIN;
            break;
    }
    
    return type;
}

- (NSArray *)cellDataList {
    if(!_cellDataList) {
        NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:2];
        _cellDataList = dataList;
        
        HSJBuyCellModel *cellModel = [[HSJBuyCellModel alloc] initCellModel:NO showArrow:NO];
        [dataList addObject:cellModel];
        
        cellModel = [[HSJBuyCellModel alloc] initCellModel:NO showArrow:NO];
        [dataList addObject:cellModel];
    }
    
    return _cellDataList;
}

- (float)addUpLimit {
    float remainAmount = self.planModel.remainAmount.floatValue;
    float userRemainAmount = self.planModel.userRemainAmount.floatValue;
    float creditor = MIN(remainAmount, userRemainAmount);
    
    return creditor;
}

- (NSString *)buyType {
    NSString *buyType = @"balance";//余额购买
    if(self.isAbleBankCellItem) {
        buyType = @"recharge";
    }
    return buyType;
}

- (void)buildCellDataList {
    [self buildLeftMoneyCellItem];
    [self buildBankCellItem];
}

- (void)buildLeftMoneyCellItem {
    //余额信息
    HSJBuyCellModel *cellModel = [self.cellDataList safeObjectAtIndex:0];
//    cellModel.iconName = @"leftMoneyNormal";
    cellModel.iconName = @"leftMoneySelect";
    NSString *str1 = @"可用余额";
    NSString *str2 = [NSString stringWithFormat:@"\n%.2f元", self.userInfoModel.userAssets.availablePoint.floatValue];
    cellModel.isDisable = !self.isAbleleftMoneyCellItem;
    
//    cellModel.title = [self buildAttributedString:str1 secondString:str2 state:self.isAbleleftMoneyCellItem];
    cellModel.title = [self buildAttributedString:str1 secondString:str2 state:YES];
    
    //描述信息
    double money = self.inputMoney.doubleValue;
    if(money>0 && self.isAbleleftMoneyCellItem) {
        double inputmoney = self.userInfoModel.userAssets.availablePoint.floatValue>money? money:self.userInfoModel.userAssets.availablePoint.floatValue;
        cellModel.descripText = [NSString stringWithFormat:@"转入%.2lf元", inputmoney];
    }
    else{
        cellModel.descripText = @"";
    }
}

- (void)buildBankCellItem {
    HSJBuyCellModel *cellModel = [self.cellDataList safeObjectAtIndex:1];
    cellModel.arrowText = @"";
    cellModel.isDisable = NO;
    if(!self.userInfoModel.userInfo.hasBindCard.boolValue) {//绑卡
        cellModel.iconName = @"bindBankCard";
        cellModel.isShowArrow = YES;
        cellModel.isSvnImage = NO;
        NSString *str1 = @"绑定银行卡";
        NSString *str2 = @"";
        cellModel.title = [self buildAttributedString:str1 secondString:str2 state:YES];
    }
    else{
        cellModel.isDisable = !self.isAbleBankCellItem;
        //描述信息
        cellModel.iconName = self.userInfoModel.userBank.bankCode;
        cellModel.isSvnImage = YES;
        NSString *tempStr = [self.userInfoModel.userBank.cardId substringFromIndex:self.userInfoModel.userBank.cardId.length-4];
        NSString *str1 = [NSString stringWithFormat:@"%@", self.userInfoModel.userBank.bankType];
        NSString *str2 = [NSString stringWithFormat:@" (**%@)\n%@", tempStr, self.userInfoModel.userBank.quota];
//        cellModel.title = [self buildAttributedString:str1 secondString:str2 state:self.isAbleBankCellItem];
        cellModel.title = [self buildAttributedString:str1 secondString:str2 state:YES];
        
        if(self.userInfoModel.userBank.quotaStatus) {//银行卡可用
            cellModel.isShowArrow = NO;
            double money = self.inputMoney.doubleValue;
            if(money > self.userInfoModel.userAssets.availablePoint.floatValue) {
                double inputmoney = money-self.userInfoModel.userAssets.availablePoint.floatValue;
                cellModel.descripText = [NSString stringWithFormat:@"转入%.2lf元", inputmoney];
            }
            else{
                cellModel.descripText = @"";
            }
        }
        else {//换卡
            cellModel.isShowArrow = YES;
            cellModel.arrowText = @"换卡";
        }
    }
    
}

- (NSAttributedString*)buildAttributedString:(NSString*)str1 secondString:(NSString*)str2 state:(BOOL)isCanSelected {
    NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:[NSMutableString stringWithFormat:@"%@%@", str1, str2]];
    if(isCanSelected) {
        [tempStr setAttributes:@{NSFontAttributeName:kHXBFont_28, NSForegroundColorAttributeName:kHXBFontColor_333333_100} range:NSMakeRange(0, str1.length)];
        [tempStr setAttributes:@{NSFontAttributeName:kHXBFont_26, NSForegroundColorAttributeName:kHXBFontColor_9295A2_100} range:NSMakeRange(str1.length, str2.length)];
    }
    else {
        [tempStr setAttributes:@{NSFontAttributeName:kHXBFont_28, NSForegroundColorAttributeName:kHXBFontColor_9295A2_100} range:NSMakeRange(0, str1.length)];
        [tempStr setAttributes:@{NSFontAttributeName:kHXBFont_26, NSForegroundColorAttributeName:kHXBFontColor_9295A2_100} range:NSMakeRange(str1.length, str2.length)];
    }
    
    return tempStr;
}

//校验数据
- (BOOL)checkMoney:(void (^)(BOOL isLess))lessthanStartMoneyBLock {
    BOOL result = YES;
    double money = self.inputMoney.doubleValue;
    NSString *erroInfo = @"";
    
    //校验金额
    if(money > 0) {
        if(money > self.addUpLimit) {
            erroInfo = @"转入金额已超上限";
        }
        else{
            if(money<self.planModel.minRegisterAmount.doubleValue && self.addUpLimit>=self.planModel.minRegisterAmount.doubleValue) {
                erroInfo = [NSString stringWithFormat:@"起投金额需为%@", [NSString hxb_getPerMilWithIntegetNumber:self.planModel.minRegisterAmount.doubleValue]];
                if(lessthanStartMoneyBLock) {
                    lessthanStartMoneyBLock(YES);
                }
            }
            if(self.addUpLimit>=self.planModel.registerMultipleAmount.doubleValue) {
                int leftValue = money-self.planModel.minRegisterAmount.doubleValue;
                if(leftValue % self.planModel.registerMultipleAmount.intValue != 0) {
                    erroInfo = [NSString stringWithFormat:@"转入金额需%@起投，%@倍数递增；", [NSString hxb_getPerMilWithIntegetNumber:self.planModel.minRegisterAmount.doubleValue], [NSString hxb_getPerMilWithIntegetNumber:self.planModel.registerMultipleAmount.doubleValue]];
                }
            }
        }
    }
    else {
        erroInfo = @"请输入转入金额";
    }
    
    //显示错误提示
    if(erroInfo.length > 0) {
        result = NO;
        [self showToast:erroInfo];
    }
    return result;
}

//校验协议勾选
- (BOOL)checkAgreement:(BOOL)isAgreementGroup agreeRiskApplyAgreement:(BOOL)isAgreeRiskApplyAgreement {
    BOOL result = YES;
    NSString *erroInfo = @"";
    
    if(!isAgreementGroup) {
        result = NO;
        erroInfo = @"请同意协议组";
    }
    if(self.isShowRiskAgeement && !isAgreeRiskApplyAgreement) {
        result = NO;
        erroInfo = @"请同意风险承受说明";
    }
    
    //显示错误提示
    if(erroInfo.length > 0) {
        result = NO;
        [self showToast:erroInfo];
    }
    return result;
}

//开启倒计时
- (BOOL)startCountDownTimer:(void (^)(void)) timerBlock {
    BOOL result = NO;
    if(self.planModel.diffTime.longLongValue > 0) {
        if(!_timerManager) {
            kWeakSelf
            self.timerManager = [HXBNsTimerManager createTimer:1 startSeconds:0 countDownTime:NO notifyCall:^(NSString *times) {
                if(timerBlock) {
                    weakSelf.timerContent = [weakSelf makeTimerContent:times.intValue];
                    timerBlock();
                }
            }];
            [self.timerManager startTimer];
        }
    }
    return result;
}

- (NSString *)makeTimerContent:(int)diffSecond{
    double temp = self.planModel.diffTime.longLongValue-diffSecond*1000;
    if(temp < 0) {
        temp = 0;
        [self.timerManager stopTimer];
    }
    
    NSString *content = @"";
    if (temp > 3600000){//1小时
        content = [[HXBBaseHandDate sharedHandleDate] millisecond_StringFromDate:self.planModel.beginSellingTime andDateFormat:@"MM月dd日 HH:mm开售"];
    }else
    {
        NSString *tempStr = [NSString stringWithFormat:@"%lf", temp];
        content = [[HXBBaseHandDate sharedHandleDate] millisecond_StringFromDate:tempStr andDateFormat:@"mm分ss秒后开始加入"];
    }
    
    return content;
}
@end
