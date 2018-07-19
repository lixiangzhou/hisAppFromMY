//
//  HSJDepositoryOpenViewModel.m
//  hoommy
//
//  Created by lxz on 2018/7/9.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJDepositoryOpenViewModel.h"
#import "HXBGeneralAlertVC.h"

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
            [weakSelf inneropenDepositoryWithParam:dict resultBlock:resultBlock];
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
        NSInteger status =  [responseData[@"status"] integerValue];
        if (status == kHXBOpenAccount_Outnumber) {
            NSString *string = [NSString stringWithFormat:@"您今日开通存管错误次数已超限，请明日再试。如有疑问可联系客服 %@", kServiceMobile];
            
            HXBGeneralAlertVC *alertVC = [[HXBGeneralAlertVC alloc] initWithMessageTitle:@"" andSubTitle:string andLeftBtnName:@"取消" andRightBtnName:@"联系客服" isHideCancelBtn:YES isClickedBackgroundDiss:NO];
            alertVC.isCenterShow = YES;
            [alertVC setRightBtnBlock:^{
                NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", kServiceMobile];
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
                }
                
            }];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:NO completion:nil];
        } else {        
            resultBlock(responseData != nil);
        }
    }];
}

@end
