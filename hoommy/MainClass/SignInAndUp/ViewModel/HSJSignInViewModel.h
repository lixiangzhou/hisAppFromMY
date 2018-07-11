//
//  HSJSignInViewModel.h
//  hoommy
//
//  Created by HXB-C on 2018/7/11.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"

@interface HSJSignInViewModel : HSJBaseViewModel

/**
 登录或注册的手机号
 */
@property (nonatomic, copy) NSString *phoneNumber;

/**
 校验手机号是否注册

 @param mobile 手机号
 @param resultBlock 返回
 */
- (void)checkExistMobile:(NSString *)mobile resultBlock:(void(^)(BOOL isSuccess, NYBaseRequest *request))resultBlock;

/**
 登录请求
 @param resultBlock 是否成功，是否需要弹图验
 */
- (void)loginRequetWithMobile: (NSString *)mobile password: (NSString *)password resultBlock:(void(^)(BOOL isSuccess))resultBlock;


@end
