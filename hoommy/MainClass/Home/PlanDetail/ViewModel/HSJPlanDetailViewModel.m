//
//  HSJPlanDetailViewModel.m
//  hoommy
//
//  Created by lxz on 2018/7/13.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJPlanDetailViewModel.h"

@implementation HSJPlanDetailViewModel

- (void)getDataWithId:(NSString *)planId resultBlock:(void (^)(BOOL))resultBlock {
    [self loadData:^(NYBaseRequest *request) {
        request.modelType = [HSJPlanModel class];
        request.requestUrl = kHXBFinanc_PlanDetaileURL(planId.integerValue);
        request.showHud = YES;
    } responseResult:^(id responseData, NSError *erro) {
        self.planModel = responseData;
        resultBlock(responseData != nil);
    }];
}

- (void)setPlanModel:(HSJPlanModel *)planModel {
    _planModel = planModel;
    
    if (planModel == nil) {
        return;
    }
    self.isNew = [self.planModel.novice isEqualToString:@"1"];
    
    self.interestString = [self getInterestString];
    self.baseInterestString = [self getBaseInterestString];
    self.lockString = [self getLockString];
    self.startDateString = [self getStartDateString];
    self.endLockDateString = [self getEndLockDateString];
}

- (NSString *)getInterestString {
    if (self.isNew && self.planModel.expectedRate.length > 0) {
        return [NSString stringWithFormat:@"%@%%+%@%%", self.planModel.expectedRate, self.planModel.subsidyInterestRate];
    } else {
        return [NSString stringWithFormat:@"%@%%+%@%%", self.planModel.baseInterestRate, self.planModel.extraInterestRate];
    }
}

- (NSString *)getBaseInterestString {
    if (self.isNew && self.planModel.expectedRate.length > 0) {
        return self.planModel.expectedRate;
    } else {
        return self.planModel.baseInterestRate;
    }
}

- (NSString *)getLockString {
    if (self.planModel.lockPeriod.length) {
        return [NSString stringWithFormat:@"%@个月", self.planModel.lockPeriod];
    }
    
    if (self.planModel.lockDays) {
        return [NSString stringWithFormat:@"%d天", self.planModel.lockDays];
    }
    
    return  @"--";
}

- (NSString *)getStartDateString {
    NSString *dateString = [self.planModel.financeEndTime componentsSeparatedByString:@" "].firstObject;
    NSArray *ymd = [dateString componentsSeparatedByString:@"-"];
    NSString *month = ymd[1];
    NSString *day = ymd[2];
    return [NSString stringWithFormat:@"%zd.%zd", [month integerValue], [day integerValue]];
}

- (NSString *)getEndLockDateString {
    NSString *dateString = [self.planModel.endLockingTime componentsSeparatedByString:@" "].firstObject;
    NSArray *ymd = [dateString componentsSeparatedByString:@"-"];
    NSString *month = ymd[1];
    NSString *day = ymd[2];
    return [NSString stringWithFormat:@"%zd.%zd", [month integerValue], [day integerValue]];
}

@end
