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
    
    // 可推出、不可推出
    self.dataSource = @[
                        [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"转入金额" right:model.finalAmount protocol:nil className:nil],
                        [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"已赚收益" right:model.earnAmount protocol:nil className:nil],
                        [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"今日预期年化" right:model.totalInterest protocol:nil className:nil],
                        [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"转入时间" right:model.registerTime protocol:nil className:nil],
                        [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"状态" right:@"可转出" protocol:nil className:nil],
                        [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeAction left:@"投标记录" right:nil protocol:nil className:@""],
                        [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeProtocol left:@"产品服务协议" right:nil protocol:nil className:nil],
                        ];
        
    
    // 转出中
    self.dataSource = @[
                        [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"转入金额" right:model.finalAmount protocol:nil className:nil],
                        [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"待转出金额" right:model.redProgressLeft protocol:nil className:nil],
                        [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"今日预期年化" right:model.totalInterest protocol:nil className:nil],
                        [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"转入时间" right:model.registerTime protocol:nil className:nil],
                        [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"转出时间" right:model.quitDate protocol:nil className:nil],
                        [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeNormal left:@"状态" right:@"转出中" protocol:nil className:nil],
                        [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeAction left:@"投标记录" right:nil protocol:nil className:@""],
                        [[HSJRollOutPlanDetailRowModel alloc] initWithType:HSJRollOutPlanDetailRowTypeProtocol left:@"产品服务协议" right:nil protocol:nil className:nil],
                        ];
    
}
@end
