//
//  HXBBankCardViewModel.h
//  hoomxb
//
//  Created by lxz on 2017/11/29.
//Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HSJBaseViewModel.h"
#import "HXBBankCardModel.h"
#import "HXBCardBinModel.h"

@class HXBCardBinModel;
@interface HXBBankCardViewModel : HSJBaseViewModel
@property (nonatomic, strong) HXBBankCardModel *bankCardModel;

@property (nonatomic, strong) HXBCardBinModel *cardBinModel;
/// 银行图片
@property (nonatomic, copy, readonly) NSString *bankImageString;
/// 银行名
@property (nonatomic, copy, readonly) NSString *bankName;
/// 银行卡号码: **** **** **** 1234
@property (nonatomic, copy, readonly) NSString *bankNoStarFormat;
/// 银行卡后4位
@property (nonatomic, copy, readonly) NSString *bankNoLast4;
/// 银行名(1234)
@property (nonatomic, copy, readonly) NSString *bankNameNo4;
/// 持卡人名字, 只显示最后一个字: **子
@property (nonatomic, copy, readonly) NSString *userNameOnlyLast;


#pragma mark - Method


/**
 用户获取绑定银行卡信息

 @param resultBlock 结果回调
 */
- (void)requestBankDataResultBlock:(NetWorkResponseBlock)resultBlock;

/**
 解绑银行卡

 @param param 参数
 @param finishBlock 完成回调，canPush 在成功或者是 statusCode == kHXBCode_UnBindCardFail 时为 YES，否则为NO，需要toast errorMessage
 */
- (void)requestUnBindWithParam:(NSDictionary *)param finishBlock:(void (^)(BOOL, NSString *, BOOL))finishBlock;

/**
 单独绑卡
 
 @param requestArgument 绑卡的字典数据
 */
- (void)bindBankCardRequestWithArgument:(NSDictionary *)requestArgument andFinishBlock:(NetWorkResponseBlock)finishBlock;

/**
 验证身份证号
 
 @return 若不通过，返回验证信息；若通过，返回nil
 */
- (NSString *)validateIdCardNo:(NSString *)cardNo;

/**
 验证交易密码
 
 @return 若不通过，返回验证信息；若通过，返回nil
 */
- (NSString *)validateTransactionPwd:(NSString *)transactionPwd;

/**
 卡bin校验
 
 @param bankNumber 银行卡号
 @param isToast 是否需要提示信息
 @param callBackBlock 回调
 */
- (void)checkCardBinResultRequestWithBankNumber:(NSString *)bankNumber andisToastTip:(BOOL)isToast andCallBack:(NetWorkResponseBlock)resultBlock;
@end
