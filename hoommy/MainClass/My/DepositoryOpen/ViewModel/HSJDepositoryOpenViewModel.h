//
//  HSJDepositoryOpenViewModel.h
//  hoommy
//
//  Created by lxz on 2018/7/9.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"
#import "HXBCardBinModel.h"
#import "HXBBankCardModel.h"

@interface HSJDepositoryOpenViewModel : HSJBaseViewModel

@property (nonatomic, strong) HXBCardBinModel *cardBinModel;

@property (nonatomic, strong) HXBBankCardModel *bankCardModel;

/// 完善信息时使用
@property (nonatomic, strong) HXBUserInfoModel *userInfoModel;
/// YES 开户，NO 完善信息
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *idNo;
@property (nonatomic, assign) BOOL hasBindCard;
@property (nonatomic, copy) NSString *bankNo;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, strong) UIImage *bankIcon;
@property (nonatomic, copy) NSString *mobile;

/**
 卡bin校验
 
 @param bankNumber 银行卡号
 @param isToast 是否需要提示信息
 @param callBackBlock 回调
 */
- (void)checkCardBinResultRequestWithBankNumber:(NSString *)bankNumber andisToastTip:(BOOL)isToast andCallBack:(void(^)(BOOL isSuccess))callBackBlock;

/**
 懒猫—存管开户
 */
- (void)openDepositoryWithParam:(NSDictionary *)param resultBlock:(void(^)(BOOL isSuccess))resultBlock;
- (void)getBankData:(void(^)(BOOL isSuccess))resultBlock;
@end
