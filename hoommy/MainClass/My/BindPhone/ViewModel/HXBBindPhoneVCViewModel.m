//
//  HXBBindPhoneVCViewModel.m
//  hoomxb
//
//  Created by caihongji on 2018/7/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HXBBindPhoneVCViewModel.h"
#import "HXBBindPhoneCellModel.h"
#import "NSString+HXBPhonNumber.h"
#import "HXBOpenDepositAccountAgent.h"

@implementation HXBBindPhoneVCViewModel

- (void)buildCellDataList:(HXBBindPhoneStepType)bindPhoneStepType userInfoModel:(HXBUserInfoModel*)model {
    switch (bindPhoneStepType) {
        case HXBBindPhoneStepFirst:
            self.cellDataList = [self buildFirstDataList:model];
            break;
        case HXBBindPhoneStepSecond:
            self.cellDataList = [self buildSecondDataList:model];
            break;
            
        default:
            break;
    }
}

- (NSArray*)buildFirstDataList:(HXBUserInfoModel*)userModel {
    NSMutableArray *dataList = [NSMutableArray array];
    NSString *realName = [userModel.userInfo.realName replaceStringWithStartLocation:0 lenght:userModel.userInfo.realName.length - 1];
    NSString *phoneNo = [userModel.userInfo.mobile replaceStringWithStartLocation:3 lenght:userModel.userInfo.mobile.length - 7];
    if(userModel.userInfo.idNo.length > 0) {
        HXBBindPhoneCellModel *cellModel = [[HXBBindPhoneCellModel alloc] initModel:@"身份验证" placeText:@"" isLastItem:NO text:realName];
        [dataList addObject:cellModel];
        cellModel = [[HXBBindPhoneCellModel alloc] initModel:@"身份证号" placeText:@"请输入您的身份证号码" isLastItem:NO text:@""];
        cellModel.keyboardType = UIKeyboardTypeNumberPad;
        cellModel.limtTextLenght = 18;
        cellModel.isCanEdit = YES;
        [dataList addObject:cellModel];
        cellModel = [[HXBBindPhoneCellModel alloc] initModel:@"原手机号" placeText:@"" isLastItem:NO text:phoneNo];
        [dataList addObject:cellModel];
        cellModel = [[HXBBindPhoneCellModel alloc] initModel:@"验证码" placeText:@"请输入验证码" isLastItem:YES text:@""];
        cellModel.isCanEdit = YES;
        cellModel.limtTextLenght = 6;
        cellModel.isShowCheckCodeView = YES;
        [dataList addObject:cellModel];
    }
    else{
        HXBBindPhoneCellModel *cellModel = [[HXBBindPhoneCellModel alloc] initModel:@"原手机号" placeText:@"" isLastItem:NO text:phoneNo];
        [dataList addObject:cellModel];
        cellModel = [[HXBBindPhoneCellModel alloc] initModel:@"验证码" placeText:@"请输入验证码" isLastItem:YES text:@""];
        cellModel.keyboardType = UIKeyboardTypeNumberPad;
        cellModel.isCanEdit = YES;
        cellModel.limtTextLenght = 6;
        cellModel.isShowCheckCodeView = YES;
        [dataList addObject:cellModel];
    }
    return dataList;
}

- (NSArray*)buildSecondDataList:(HXBUserInfoModel*)userModel {
    NSMutableArray *dataList = [NSMutableArray array];
    
    HXBBindPhoneCellModel *cellModel = [[HXBBindPhoneCellModel alloc] initModel:@"新手机号" placeText:@"请输入新的手机号码" isLastItem:NO text:@""];
    cellModel.keyboardType = UIKeyboardTypeNumberPad;
    cellModel.isCanEdit = YES;
    cellModel.limtTextLenght = 11;
    [dataList addObject:cellModel];
    cellModel = [[HXBBindPhoneCellModel alloc] initModel:@"验证码" placeText:@"请输入验证码" isLastItem:YES text:@""];
    cellModel.keyboardType = UIKeyboardTypeNumberPad;
    cellModel.isCanEdit = YES;
    cellModel.limtTextLenght = 6;
    cellModel.isShowCheckCodeView = YES;
    [dataList addObject:cellModel];
    
    return dataList;
}

//获取文本
- (NSString*)getTextAtIndex:(int)index {
    HXBBindPhoneCellModel *cellModel = [self.cellDataList safeObjectAtIndex:index];
    
    return cellModel.text ?: @"";
}
#pragma  网络处理

- (BOOL)erroResponseCodeDeal:(NYBaseRequest *)request error:(NSError *)error{
    if ([request.requestUrl isEqual:kHXBSetTransaction_MobifyPassword_CheckIdentityAuthURL]) {
        return NO;
    }
    return [super erroResponseCodeDeal:request error:error];
}

- (BOOL)erroStateCodeDeal:(NYBaseRequest *)request response:(NSDictionary *)responseObject{
    if ([request.requestUrl isEqual:kHXBSetTransaction_MobifyPassword_CheckIdentityAuthURL]) {
        return NO;
    }
    return [super erroStateCodeDeal:request response:responseObject];
}

- (void)myTraderPasswordGetverifyCodeWithAction:(NSString *)action
                                     resultBlock:(NetWorkResponseBlock)resultBlock {
    
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBUser_smscodeURL;
        request.requestMethod = NYRequestMethodPost;
        request.requestArgument = @{@"action" : action};
    } responseResult:^(id responseData, NSError *erro) {
        if(resultBlock) {
            resultBlock(responseData, erro);
        }
    }];
}

- (void)modifyTransactionPasswordWithIdCard:(NSString *)idCard resultBlock:(NetWorkResponseBlock)resultBlock {
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBSetTransaction_MobifyPassword_CheckIdentityAuthURL;
        request.requestArgument =  @{ @"identity" : idCard };
    } responseResult:^(id responseData, NSError *erro) {
        if (erro) {
            NSDictionary *respObj = erro.userInfo;
            
            if ([respObj isKindOfClass:[NSDictionary class]]) {
                
                if ([weakSelf getStateCode:respObj] != kHXBCode_Enum_RequestOverrun) {
                    [weakSelf showToast:@"请输入正确的身份证号"];
                }
            } else {
                [weakSelf showToast:@"请输入正确的身份证号"];
            }
        }
        if(resultBlock) {
            resultBlock(responseData, erro);
        }
    }];
}

//修改绑定手机
- (void)modifyBindPhone:(NSString *)idCard code:(NSString *)code resultBlock:(NetWorkResponseBlock)resultBlock {
    
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBSetTransaction_MobifyPassword_CheckIdentitySmsURL;
        request.showHud = YES;
        request.requestMethod = NYRequestMethodPost;
        request.requestArgument =  @{ @"identity" : idCard,
                                      @"action" : kTypeKey_tradpwd,
                                      @"smscode" : code };
    } responseResult:^(id responseData, NSError *erro) {
        if(resultBlock) {
            resultBlock(responseData, erro);
        }
    }];
}

#pragma mark 修改手机号第二步的协议
/**
 修改手机号
 
 @param newPhoneNumber 新的手机号码
 @param newsmscode 短信验证码
 @param captcha 图验
 */
- (void)mobifyPhoneNumberWithNewPhoneNumber:(NSString *)newPhoneNumber andWithNewsmscode:(NSString *)newsmscode  andWithCaptcha:(NSString *)captcha resultBlock: (void(^)(BOOL isSuccess))resultBlock
{
    kWeakSelf
    NYBaseRequest *alterLoginPasswordAPI = [[NYBaseRequest alloc] initWithDelegate:self];
    alterLoginPasswordAPI.requestUrl = kHXBSetTransaction_MobifyPhoneNumber_CashMobileEditURL;
    alterLoginPasswordAPI.requestMethod = NYRequestMethodPost;
    if (!(newPhoneNumber.length && newsmscode.length)) return;
    alterLoginPasswordAPI.requestArgument = @{
                                              @"mobile" : newPhoneNumber,
                                              @"newsmscode" : newsmscode,
                                              @"captcha" : captcha,
                                              @"action" : kTypeKey_newmobile
                                              };
    [alterLoginPasswordAPI loadData:^(NYBaseRequest *request, NSDictionary *responseObject) {
        
        [HxbHUDProgress showTextWithMessage:responseObject[@"message"]];
        weakSelf.modifyPhoneModel = [[HXBModifyPhoneModel alloc] initWithDictionary:[responseObject dictAtPath:@"data"]];
        if (resultBlock) {
            resultBlock(YES);
        }
    } failure:^(NYBaseRequest *request, NSError *error) {
        if (resultBlock) {
            resultBlock(NO);
        }
    }];
}

/**
 获取充值短验
 @param mobile 手机号
 @param action 获取短信的事件
 @param captcha 图验(只有在登录错误超过3次才需要输入图验)
 @param callbackBlock 请求回调
 */
- (void)getVerifyCodeRequesWithMobile: (NSString *)mobile
                            andAction: (HXBSignUPAndLoginRequest_sendSmscodeType)action
                           andCaptcha: (NSString *)captcha
                              andType: (NSString *)type
                     andCallbackBlock: (void(^)(BOOL isSuccess,NSError *error))callbackBlock {
                         
    kWeakSelf
    [HXBOpenDepositAccountAgent verifyCodeRequestWithResultBlock:^(NYBaseRequest *request) {
        NSString *actionStr = [HXBSignUPAndLoginRequest_EnumManager getKeyWithHXBSignUPAndLoginRequest_sendSmscodeType:action];
        request.requestArgument = @{
                                    @"mobile":mobile ?: @"",///     是    string    用户名
                                    @"action":actionStr ?: @"",///     是    string    signup(参照通用短信发送类型)
                                    @"captcha":captcha ?: @"",///    是    string    校验图片二维码
                                    @"type":type ?: @""
                                    };
        request.hudDelegate = weakSelf;
        request.showHud = YES;
    } resultBlock:^(id responseObject, NSError *error) {
        if (error) {
            callbackBlock(NO,error);
        }
        else {
            callbackBlock(YES,nil);
        }
    }];
}

@end
