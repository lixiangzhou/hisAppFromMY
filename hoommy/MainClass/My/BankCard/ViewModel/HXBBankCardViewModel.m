//
//  HXBBankCardViewModel.m
//  hoomxb
//
//  Created by lxz on 2017/11/29.
//Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBankCardViewModel.h"
#import "HXBGeneralAlertVC.h"

@interface HXBBankCardViewModel()

@property (nonatomic, strong) NYBaseRequest *cardBinrequest;

@property (nonatomic, assign) BOOL cardBinIsShowTost;

@end

@implementation HXBBankCardViewModel

- (BOOL)erroStateCodeDeal:(NYBaseRequest *)request response:(NSDictionary *)responseObject{
    if ([request.requestUrl isEqualToString:kHXBAccount_Bindcard]) {
        NSInteger status =  [responseObject[@"status"] integerValue];
        if (status == kHXBOpenAccount_Outnumber) {
            return NO;
        }
    }
    else if ([request.requestUrl isEqualToString:kHXBUser_checkCardBin] && !self.cardBinIsShowTost) {
        return NO;
    }
    else if([request.requestUrl isEqualToString:kHXBUserInfo_UnbindBankCard]){
        return NO;
    }
    
    return [super erroStateCodeDeal:request response:responseObject];
}

- (BOOL)erroResponseCodeDeal:(NYBaseRequest *)request error:(NSError *)error{
    if ([request.requestUrl isEqualToString:kHXBUser_checkCardBin] && !self.cardBinIsShowTost) {
        return NO;
    }
    else if([request.requestUrl isEqualToString:kHXBUserInfo_UnbindBankCard]){
        return NO;
    }
    
    return [super erroResponseCodeDeal:request error:error];
}

- (void)setBankCardModel:(HXBBankCardModel *)bankCardModel {
    _bankCardModel = bankCardModel;
    
    _bankImageString = bankCardModel.bankCode;
    
    _bankName = bankCardModel.bankType;
    
    _bankNoStarFormat = [bankCardModel.cardId hxb_hiddenBankCard];
    
    _bankNoLast4 = [bankCardModel.cardId substringFromIndex:bankCardModel.cardId.length - 4];
    
    _bankNameNo4 = [NSString stringWithFormat:@"%@（尾号%@）", _bankName, _bankNoLast4];
    
    _userNameOnlyLast = [bankCardModel.name replaceStringWithStartLocation:0 lenght:bankCardModel.name.length - 1];
}

- (void)requestBankDataResultBlock:(NetWorkResponseBlock)resultBlock {
    
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBUserInfo_BankCard;
        request.showHud = YES;
        request.modelType = [HXBBankCardModel class];
    } responseResult:^(id responseData, NSError *erro) {
        weakSelf.bankCardModel = responseData;
        if(resultBlock) {
            resultBlock(responseData, erro);
        }
    }];
}

- (void)requestUnBindWithParam:(NSDictionary *)param finishBlock:(void (^)(BOOL, NSString *, BOOL))finishBlock
{
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBUserInfo_UnbindBankCard;
        request.requestMethod = NYRequestMethodPost;
        request.requestArgument = param;
        request.showHud = YES;
    } responseResult:^(id responseData, NSError *erro) {
        if(!erro) {
            if (finishBlock) {
                finishBlock(YES, [weakSelf getErroMessage:responseData], YES);
            }
        }
        else {
            if(erro.code == HSJNetStateCodeCommonInterfaceErro){
                NSDictionary *responseObject = erro.userInfo;
                if ([weakSelf getStateCode:responseObject] == kHXBCode_UnBindCardFail) {
                    if(finishBlock) {
                        finishBlock(NO, [weakSelf getErroMessage:responseObject], YES);
                    }
                } else {
                    [weakSelf showToast:[weakSelf getErroMessage:responseObject]];
                    if (finishBlock) {
                        finishBlock(NO, nil, NO);
                    }
                }
            }
            else{
                if (finishBlock) {
                    finishBlock(NO, nil, NO);
                }
            }
        }
    }];
}

- (void)bindBankCardRequestWithArgument:(NSDictionary *)requestArgument showHug:(BOOL)isShowHug andFinishBlock:(NetWorkResponseBlock)finishBlock
{
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBAccount_Bindcard;
        request.requestMethod = NYRequestMethodPost;
        request.requestArgument = requestArgument;
        request.showHud = isShowHug;
    } responseResult:^(id responseData, NSError *erro) {
        if(erro && erro.code==HSJNetStateCodeCommonInterfaceErro) {
            NSInteger status =  [self getStateCode:erro.userInfo];
            if (status == kHXBOpenAccount_Outnumber) {
                NSString *string = [NSString stringWithFormat:@"您今日绑卡错误次数已超限，请明日再试。如有疑问可联系客服 \n%@", kServiceMobile];
                HXBGeneralAlertVC *alertVC = [[HXBGeneralAlertVC alloc] initWithMessageTitle:@"" andSubTitle:string andLeftBtnName:@"取消" andRightBtnName:@"联系客服" isHideCancelBtn:YES isClickedBackgroundDiss:NO];
                alertVC.isCenterShow = YES;
                [alertVC setRightBtnBlock:^{
                    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", kServiceMobile];
                    NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0" options:NSNumericSearch];
                    if (compare == NSOrderedDescending || compare == NSOrderedSame) {
                        /// 大于等于10.0系统使用此openURL方法
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
                    } else {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
                    }
                }];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:NO completion:nil];
                return ;
            }
        }
        if(finishBlock) {
            finishBlock(responseData, erro);
        }
    }];
}

/**
 卡bin校验扩展
 
 @param bankNumber 银行卡号
 @param isToast 是否需要提示信息
 @param resultBlock 回调
 */
- (void)checkCardBinResultRequestWithBankNumberExtend:(NSString *)bankNumber andisToastTip:(BOOL)isToast showHug:(BOOL)isShowHug andCallBack:(NetWorkResponseBlock)resultBlock {
    if (bankNumber == nil) bankNumber = @"";
    
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBUser_checkCardBin;
        request.requestMethod = NYRequestMethodPost;
        request.requestArgument = @{
                                    @"bankCard" : bankNumber
                                    };
        request.showHud = isShowHug;
        weakSelf.cardBinIsShowTost = isToast;
        request.modelType = [HXBCardBinModel class];
    } responseResult:^(id responseData, NSError *erro) {
        weakSelf.cardBinModel = responseData;
        if(resultBlock) {
            resultBlock(responseData, erro);
        }
    }];
}

/**
 卡bin校验
 
 @param bankNumber 银行卡号
 @param isToast 是否需要提示信息
 @param resultBlock 回调
 */
- (void)checkCardBinResultRequestWithBankNumber:(NSString *)bankNumber andisToastTip:(BOOL)isToast andCallBack:(NetWorkResponseBlock)resultBlock
{
    [self checkCardBinResultRequestWithBankNumberExtend:bankNumber andisToastTip:isToast showHug:isToast andCallBack:resultBlock];
}

- (NSString *)validateIdCardNo:(NSString *)cardNo
{
    if (!(cardNo.length > 0)) {
        return @"身份证号不能为空";
    }
    if (cardNo.length != 18)
    {
        return @"身份证号输入有误";
    }
    return nil;
}

- (NSString *)validateTransactionPwd:(NSString *)transactionPwd
{
    if(!(transactionPwd.length > 0))
    {
        return @"交易密码不能为空";
    }
    if (transactionPwd.length != 6) {
        return @"交易密码为6位数字";
    }
    return nil;
}
@end
