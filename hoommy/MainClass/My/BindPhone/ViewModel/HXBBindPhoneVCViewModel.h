//
//  HXBBindPhoneVCViewModel.h
//  hoomxb
//
//  Created by caihongji on 2018/7/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HSJBaseViewModel.h"
#import "HXBBindPhoneCellModel.h"
#import "HXBUserInfoModel.h"
#import "HXBModifyPhoneModel.h"

typedef enum : NSUInteger {
    HXBBindPhoneStepFirst, //第一步
    HXBBindPhoneStepSecond,
    HXBBindPhoneTransactionPassword //交易密码
    
} HXBBindPhoneStepType;

@interface HXBBindPhoneVCViewModel : HSJBaseViewModel

@property (nonatomic, strong) NSArray* cellDataList;
//
@property (nonatomic, strong) HXBModifyPhoneModel *modifyPhoneModel;

- (void)buildCellDataList:(HXBBindPhoneStepType)bindPhoneStepType userInfoModel:(HXBUserInfoModel*)model;

//短信验证码
- (void)myTraderPasswordGetverifyCodeWithAction:(NSString *)action
                                    resultBlock:(NetWorkResponseBlock)resultBlock;
//验证身份信息
- (void)modifyTransactionPasswordWithIdCard:(NSString *)idCard resultBlock:(NetWorkResponseBlock)resultBlock;
//修改绑定手机
- (void)modifyBindPhone:(NSString *)idCard code:(NSString *)code resultBlock:(NetWorkResponseBlock)resultBlock;
//获取文本
- (NSString*)getTextAtIndex:(int)index;

////////////////////////////////////////////////

/**
 修改手机号
 
 @param newPhoneNumber 新的手机号码
 @param newsmscode 短信验证码
 @param captcha 图验
 */
- (void)mobifyPhoneNumberWithNewPhoneNumber:(NSString *)newPhoneNumber andWithNewsmscode:(NSString *)newsmscode  andWithCaptcha:(NSString *)captcha resultBlock: (void(^)(BOOL isSuccess))resultBlock;

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
                     andCallbackBlock: (void(^)(BOOL isSuccess,NSError *error))callbackBlock;
@end
