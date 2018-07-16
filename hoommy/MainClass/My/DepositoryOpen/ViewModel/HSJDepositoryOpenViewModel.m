//
//  HSJDepositoryOpenViewModel.m
//  hoommy
//
//  Created by lxz on 2018/7/9.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJDepositoryOpenViewModel.h"

@interface HSJDepositoryOpenViewModel()
@property (nonatomic, strong) NYBaseRequest *cardBinrequest;
@property (nonatomic, assign) BOOL cardBinIsShowTost;
@end

@implementation HSJDepositoryOpenViewModel

- (BOOL)erroStateCodeDeal:(NYBaseRequest *)request response:(NSDictionary *)responseObject {
    if ([request.requestUrl isEqualToString:kHXBOpenDepositAccount_Escrow]) {
        NSInteger status =  [responseObject[@"status"] integerValue];
        if (status == kHXBOpenAccount_Outnumber) {
            return NO;
        }
    } else if ([request.requestUrl isEqualToString:kHXBUser_checkCardBin] && !self.cardBinIsShowTost) {
        return NO;
    }
    return [super erroStateCodeDeal:request response:responseObject];
}

- (void)checkCardBinResultRequestWithBankNumber:(NSString *)bankNumber andisToastTip:(BOOL)isToast andCallBack:(void(^)(BOOL isSuccess))callBackBlock
{
    [self.cardBinrequest cancelRequest];
    if (bankNumber == nil) bankNumber = @"";
    
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBUser_checkCardBin;
        request.requestMethod = NYRequestMethodPost;
        request.modelType = [HXBCardBinModel class];
        request.requestArgument = @{@"bankCard": bankNumber};
        
        weakSelf.cardBinIsShowTost = isToast;
        weakSelf.cardBinrequest = request;
    } responseResult:^(id responseData, NSError *erro) {
        self.cardBinModel = responseData;
        callBackBlock(responseData != nil);
    }];
}

- (void)openDepositoryWithParam:(NSDictionary *)param resultBlock:(void (^)(BOOL))resultBlock {
    kWeakSelf
    [self checkCardBinResultRequestWithBankNumber:param[@"bankCard"] andisToastTip:YES andCallBack:^(BOOL isSuccess) {
        if (isSuccess) {
            NSMutableDictionary *dict = [param mutableCopy];
            dict[@"bankCode"] = weakSelf.cardBinModel.bankCode;
            [weakSelf inneropenDepositoryWithParam:param resultBlock:resultBlock];
        } else {
        }
    }];
}

- (void)inneropenDepositoryWithParam:(NSDictionary *)param resultBlock:(void(^)(BOOL))resultBlock {
    
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBOpenDepositAccount_Escrow;
        request.requestMethod = NYRequestMethodPost;
        request.requestArgument = param;
        request.showHud = NO;
    } responseResult:^(id responseData, NSError *erro) {
        resultBlock(responseData != nil);
    }];
}

@end
