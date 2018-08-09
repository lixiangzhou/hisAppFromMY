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

#pragma mark - Network
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
        request.showHud = YES;
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

- (void)getBankData:(void (^)(BOOL))resultBlock {
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBUserInfo_BankCard;
        request.showHud = YES;
        request.modelType = [HXBBankCardModel class];
    } responseResult:^(id responseData, NSError *erro) {
        weakSelf.bankCardModel = responseData;
        if(resultBlock) {
            resultBlock(responseData != nil);
        }
    }];
}

#pragma mark - Setter\Getter
- (void)setUserInfoModel:(HXBUserInfoModel *)userInfoModel {
    _userInfoModel = userInfoModel;
    
    self.isNew = userInfoModel == nil;
    
    if (self.isNew == NO) {
        self.userName = userInfoModel.userInfo.realName;
        self.idNo = userInfoModel.userInfo.idNo;
        
        self.hasBindCard = [userInfoModel.userInfo.hasBindCard isEqualToString:@"1"];
    }
}

- (void)setBankCardModel:(HXBBankCardModel *)bankCardModel {
    _bankCardModel = bankCardModel;
    if (bankCardModel) {
        self.bankNo = [self formatToBank:bankCardModel.cardId];
        self.bankName = bankCardModel.bankType;
        self.bankIcon = [UIImage imageNamed:bankCardModel.bankCode] ?: [UIImage imageNamed:@"bank_default"];
        self.mobile = bankCardModel.mobile;
    }
}

#pragma mark - Helper
- (NSString *)formatToBank:(NSString *)string {
    NSMutableString *newString = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@" " withString:@""]];
    if (newString.length > 4) {
        [newString insertString:@" " atIndex:4];
    }
    if (newString.length > 9) {
        [newString insertString:@" " atIndex:9];
    }
    if (newString.length > 14) {
        [newString insertString:@" " atIndex:14];
    }
    if (newString.length > 19) {
        [newString insertString:@" " atIndex:19];
    }
    if (newString.length > 24) {
        [newString insertString:@" " atIndex:24];
    }
    if (newString.length > 29) {
        [newString insertString:@" " atIndex:29];
    }
    return newString;
}
@end
