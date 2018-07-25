//
//  HSJBuyViewModel.m
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBuyViewModel.h"

@interface HSJBuyViewModel()
@property (nonatomic, assign, readonly) BOOL isAbleleftMoneyCellItem;
@property (nonatomic, assign, readonly) BOOL isAbleBankCellItem;
@end

@implementation HSJBuyViewModel
#pragma mark 数据请求处理
- (instancetype)init {
    self = [super init];
    if(self) {
        self.isFilterHugHidden = NO;
    }
    return self;
}

- (void)hideProgress:(NYBaseRequest *)request {
    if(!self.isLoadingData) {
        [super hideProgress:request];
    }
}

#pragma  mark 逻辑处理

- (BOOL)isAbleBankCellItem {
    double money = self.inputMoney.doubleValue;
    BOOL isAble = YES;
    if(self.userInfoModel.userAssets.availablePoint.doubleValue > money) {
        isAble = NO;
    }
    return isAble;
}

- (BOOL)isIsAbleleftMoneyCellItem {
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
    NSString *content = @"添加银行卡";
    if(self.userInfoModel.userInfo.hasBindCard.boolValue) {
        double money = self.inputMoney.doubleValue;
        content = @"立即转入";
        if(money > 0) {
            content = [NSString stringWithFormat:@"%@%.2lf元", content, money];
        }
    }
    return content;
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

- (void)buildCellDataList {
    [self buildLeftMoneyCellItem];
    [self buildBankCellItem];
}

- (void)buildLeftMoneyCellItem {
    //余额信息
    HSJBuyCellModel *cellModel = [self.cellDataList safeObjectAtIndex:0];
    cellModel.iconName = @"leftMoneyNormal";
    NSString *str1 = @"可用余额";
    NSString *str2 = [NSString stringWithFormat:@"\n%.2f元", self.userInfoModel.userAssets.availablePoint.floatValue];
    if(self.isAbleleftMoneyCellItem) {
        cellModel.iconName = @"leftMoneySelect";
    }
    cellModel.title = [self buildAttributedString:str1 secondString:str2 state:self.isAbleleftMoneyCellItem];
    
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
    if(!self.userInfoModel.userInfo.hasBindCard.boolValue) {//绑卡
        cellModel.iconName = @"bindBankCard";
        cellModel.isShowArrow = YES;
        cellModel.isSvnImage = NO;
        NSString *str1 = @"绑定银行卡";
        NSString *str2 = @"";
        cellModel.title = [self buildAttributedString:str1 secondString:str2 state:YES];
    }
    else{
        //描述信息
        cellModel.iconName = self.userInfoModel.userBank.bankCode;
        cellModel.isSvnImage = YES;
        NSString *tempStr = [self.userInfoModel.userBank.cardId substringFromIndex:self.userInfoModel.userBank.cardId.length-4];
        NSString *str1 = [NSString stringWithFormat:@"%@", self.userInfoModel.userBank.name];
        NSString *str2 = [NSString stringWithFormat:@" (**%@)\n%@", tempStr, self.userInfoModel.userBank.quota];
        cellModel.title = [self buildAttributedString:str1 secondString:str2 state:self.isAbleBankCellItem];
        
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
- (BOOL)checkMoney:(void (^)(BOOL isLess))LessthanStartMoneyBLock {
    BOOL result = YES;
    double money = self.inputMoney.doubleValue;
    NSString *erroInfo = @"";
    
    //校验金额
    if(money > 0) {
        if(money < self.planModel.minRegisterAmount.doubleValue) {
            erroInfo = [NSString stringWithFormat:@"起投金额需为%@", [NSString hxb_getPerMilWithIntegetNumber:self.planModel.minRegisterAmount.doubleValue]];
        }
        else if(money > self.addUpLimit) {
            erroInfo = @"转入金额已超上限";
        }
        else {
            int leftValue = money-self.planModel.minRegisterAmount.doubleValue;
            if(leftValue % self.planModel.registerMultipleAmount.intValue != 0) {
                erroInfo = [NSString stringWithFormat:@"转入金额需%@起投，%@倍数递增；", [NSString hxb_getPerMilWithIntegetNumber:self.planModel.minRegisterAmount.doubleValue], [NSString hxb_getPerMilWithIntegetNumber:self.planModel.registerMultipleAmount.doubleValue]];
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
    else if(self.isShowRiskAgeement && !isAgreeRiskApplyAgreement) {
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
@end
