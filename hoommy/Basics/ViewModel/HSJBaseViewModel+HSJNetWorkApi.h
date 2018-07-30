//
//  HSJBaseViewModel+HSJNetWorkApi.h
//  HSFrameProject
//
//  Created by caihongji on 2018/4/27.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"

@interface HSJBaseViewModel (HSJNetWorkApi)

- (void)checkVersionUpdate:(NetWorkResponseBlock)resultBlock;

- (void)downLoadUserInfo:(BOOL)isShowHud resultBlock:(NetWorkResponseBlock)resultBlock;

- (void)verifyCodeRequestWithResultBlock:(void(^)(NYBaseRequest* request)) requestBlock resultBlock:(void(^)(id responseObject, NSError *error))resultBlock;
//产品详情
- (void)getDataWithId:(NSString *)planId showHug:(BOOL)isShow resultBlock:(NetWorkResponseBlock)resultBlock;

/**
 登出
 
 @param isShowHud 是否显示loading
 @param resultBlock 结果回调
 */
- (void)userLogOut:(BOOL)isShowHud resultBlock:(NetWorkResponseBlock)resultBlock;
@end
