//
//  HSJBaseViewModel+HSJNetWorkApi.h
//  HSFrameProject
//
//  Created by caihongji on 2018/4/27.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"
#import "HXBUserInfoModel.h"

@interface HSJBaseViewModel (HSJNetWorkApi)

- (void)checkVersionUpdate:(NetWorkResponseBlock)resultBlock;

- (void)downLoadUserInfo:(BOOL)isShowHud resultBlock:(void(^)(HXBUserInfoModel *userInfoModel, NSError* erro))resultBlock;

- (void)verifyCodeRequestWithResultBlock:(void(^)(NYBaseRequest* request)) requestBlock resultBlock:(void(^)(id responseObject, NSError *error))resultBlock;

//产品详情
- (void)getDataWithId:(NSString *)planId showHug:(BOOL)isShow resultBlock:(NetWorkResponseBlock)resultBlock;

/**
 登出
 
 @param isShowHud 是否显示loading
 @param resultBlock 结果回调
 */
- (void)userLogOut:(BOOL)isShowHud resultBlock:(NetWorkResponseBlock)resultBlock;

/// 先判断登录，没有登录就去登录
/// 在判断是否开户
/// 然后判断是否有交易密码，否则去完善信息
/// 再然后判断是否绑卡，否则去绑卡
/// 最后判断是否有风险评测
/// 都通过之后就执行 finishBlock
///  checkBank: 是否检查绑卡
- (void)checkDepositoryAndRiskFromController:(UIViewController *)controller checkBank:(BOOL)checkBank finishBlock:(void (^)(void))finishBlock;

/// 做风险评测 需要回调结果
- (void)riskTypeAssementFrom:(UIViewController *)controller resultBlock:(void (^)(void))finishBlock;

@end
