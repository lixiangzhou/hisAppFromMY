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
@end
