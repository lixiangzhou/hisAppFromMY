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

typedef enum : NSUInteger {
    HXBBindPhoneStepFirst, //第一步
    HXBBindPhoneStepSecond,
    HXBBindPhoneTransactionPassword //交易密码
    
} HXBBindPhoneStepType;

@interface HXBBindPhoneVCViewModel : HSJBaseViewModel

@property (nonatomic, strong) NSArray* cellDataList;

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
@end
