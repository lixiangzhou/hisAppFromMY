//
//  HSJRollOutPlanDetailViewModel.m
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJRollOutPlanDetailViewModel.h"
#import "HSJRollOutPlanDetailRowModel.h"

@implementation HSJRollOutPlanDetailViewModel
- (void)getPlanDetail:(NSString *)planId resultBlock:(void(^)(BOOL isSuccess))resultBlock {
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBMY_PlanDetaileURL(planId);
        request.modelType = [HSJRollOutModel class];
    } responseResult:^(id responseData, NSError *erro) {
        weakSelf.model = responseData;
        resultBlock(responseData != nil);
    }];
}

- (void)setModel:(HSJRollOutModel *)model {
    _model = model;
    
    if (model == nil) {
        return;
    }
    
    if ([self.model.stepUpPlanStatus isEqualToString:@"QUIT"]) {
        self.stepupStatus = HSJStepUpStatusQUIT;
    } else if ([self.model.stepUpPlanStatus isEqualToString:@"NOQUIT"]) {
        self.stepupStatus = HSJStepUpStatusNOQUIT;
    } else if ([self.model.stepUpPlanStatus isEqualToString:@"QUITING"]) {
        self.stepupStatus = HSJStepUpStatusQUITING;
    }
    
    self.hideBottomView = self.stepupStatus != HSJStepUpStatusQUIT;
    
    // 转入金额
    NSString *joinInString = [NSString GetPerMilWithDouble:self.model.finalAmount.doubleValue];
    joinInString = [joinInString isEqualToString:@"0"] ? @"0.00" : joinInString;
    joinInString = [NSString stringWithFormat:@"%@元", joinInString];
    
    // 待转出金额
    NSString *leftAccountString = [NSString GetPerMilWithDouble:self.model.redProgressLeft.doubleValue];
    leftAccountString = [leftAccountString isEqualToString:@"0"] ? @"0.00" : leftAccountString;
    leftAccountString = [NSString stringWithFormat:@"%@元", leftAccountString];
    
    // 已赚收益
    NSString *earnAmount = [NSString GetPerMilWithDouble:model.earnAmount.doubleValue];
    earnAmount = [joinInString isEqualToString:@"0"] ? @"0.00" : earnAmount;
    earnAmount = [NSString stringWithFormat:@"%@元", earnAmount];
    
    // 今日预期年化
    NSString *totalInterest = [NSString stringWithFormat:@"%.2f%%", model.totalInterest.doubleValue];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    // 转入时间
    NSDate *registerTime = [NSDate dateWithTimeIntervalSince1970:self.model.registerTime.doubleValue / 1000];
    NSString *registerTimeString = [df stringFromDate:registerTime];
    // 转出时间
    NSDate *endLockingRequestTime = [NSDate dateWithTimeIntervalSince1970:self.model.endLockingRequestTime.doubleValue / 1000];
    NSString *endLockingRequestTimeString = [df stringFromDate:endLockingRequestTime];
    
    if (self.stepupStatus == HSJStepUpStatusQUIT || self.stepupStatus == HSJStepUpStatusNOQUIT) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.endLockingTime.doubleValue / 1000];
        NSString *dateString = [df stringFromDate:date];
        NSString *statusString = self.stepupStatus == HSJStepUpStatusQUIT ? @"转出" : [NSString stringWithFormat:@"%@可转", dateString];
        
        HSJRollOutPlanDetailRowModel *model = [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"状态" right:statusString protocol:nil className:nil];
        model.rightLabelColor = kHXBColor_FF7055_100;
        // 可退出、不可退出
        self.dataSource = @[
                            @[[[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"转入金额" right:joinInString protocol:nil className:nil],
                            [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"已赚收益" right:earnAmount protocol:nil className:nil],
                            [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"今日预期年化" right:totalInterest protocol:nil className:nil],
                            [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"转入时间" right:registerTimeString protocol:nil className:nil],
                            model],
                            
                            @[[[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeAction left:@"投标记录" right:nil protocol:nil className:nil]],
                            
                            @[[[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeProtocol left:@"产品服务协议" right:nil protocol:nil className:nil]],
                            ];
    } else {
        HSJRollOutPlanDetailRowModel *model = [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"状态" right:@"转出中" protocol:nil className:nil];
        model.rightLabelColor = kHXBColor_FF7055_100;
        // 转出中
        self.dataSource = @[
                            @[[[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"转入金额" right:joinInString protocol:nil className:nil],
                            [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"待转出金额" right:leftAccountString protocol:nil className:nil],
                            [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"今日预期年化" right:totalInterest protocol:nil className:nil],
                            [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"转入时间" right:registerTimeString protocol:nil className:nil],
                            [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"转出时间" right:endLockingRequestTimeString protocol:nil className:nil],
                            model],
                            
                            @[[[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeAction left:@"投标记录" right:nil protocol:nil className:nil]],
                            
                            @[[[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeProtocol left:@"产品服务协议" right:nil protocol:nil className:nil]],
                            ];
    }
}
@end
