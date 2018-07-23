//
//  HSJRollOutConfirmViewModel.m
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJRollOutConfirmViewModel.h"

@implementation HSJRollOutConfirmViewModel
- (void)quitConfrim:(NSArray *)ids resultBlock:(void(^)(BOOL isSuccess))resultBlock {
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.requestArgument = @{@"action": @"confirm", @"id": ids};
        request.requestUrl = kHXBMY_PlanQuit;
        request.requestMethod = NYRequestMethodPost;
        request.modelType = [HSJRollOutConfirmModel class];
    } responseResult:^(id responseData, NSError *erro) {
        weakSelf.model = responseData;
        resultBlock(responseData != nil);
    }];
}

- (void)sendSms:(void(^)(BOOL isSuccess))resultBlock {
    [self loadData:^(NYBaseRequest *request) {
        request.requestArgument = @{@"action": @"planquit"};
        request.requestUrl = kHXBUser_smscodeURL;
        request.requestMethod = NYRequestMethodPost;
    } responseResult:^(id responseData, NSError *erro) {
        resultBlock(resultBlock != nil);
    }];
}

- (void)quit:(NSArray *)ids smsCode:(NSString *)smsCode resultBlock:(void (^)(BOOL))resultBlock {
    [self loadData:^(NYBaseRequest *request) {
        request.requestArgument = @{@"action": @"confirm", @"id": ids, @"smscode": smsCode};
        request.requestUrl = kHXBMY_PlanQuit;
        request.requestMethod = NYRequestMethodPost;
    } responseResult:^(id responseData, NSError *erro) {
        resultBlock(responseData != nil);
    }];
}

- (void)setModel:(HSJRollOutConfirmModel *)model {
    _model = model;
    NSString *amountAndTotalEarnInterest = [NSString GetPerMilWithDouble:model.amountAndTotalEarnInterest.doubleValue];
    self.amountAndTotalEarnInterest = [amountAndTotalEarnInterest isEqualToString:@"0"] ? @"0.00" : amountAndTotalEarnInterest;
}

@end
