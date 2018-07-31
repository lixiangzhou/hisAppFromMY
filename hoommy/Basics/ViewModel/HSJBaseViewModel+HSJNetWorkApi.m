//
//  HSJBaseViewModel+HSJNetWorkApi.m
//  HSFrameProject
//
//  Created by caihongji on 2018/4/27.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel+HSJNetWorkApi.h"

@implementation HSJBaseViewModel (HSJNetWorkApi)

- (void)checkVersionUpdate:(NetWorkResponseBlock)resultBlock {
    NSString *version = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBMY_VersionUpdateURL;
        request.requestMethod = NYRequestMethodPost;
        request.showHud = YES;
        request.modelType = NSClassFromString(@"HXBVersionUpdateModel");
        request.requestArgument = @{
                                    @"versionCode" : version
                                    };
    } responseResult:^(id responseData, NSError *erro) {
        if(resultBlock) {
            resultBlock(responseData, erro);
        }
    }];
}

- (void)downLoadUserInfo:(BOOL)isShowHud resultBlock:(void(^)(HXBUserInfoModel *userInfoModel, NSError* erro))resultBlock {
    if(!KeyChain.isLogin) {
        return;
    }
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.showHud= isShowHud;
        request.hudDelegate = weakSelf;
        request.requestUrl = kHXBUser_UserInfoURL;
        request.requestMethod = NYRequestMethodGet;
        request.modelType = NSClassFromString(@"HXBUserInfoModel");
    } responseResult:^(id responseData, NSError *erro) {
        if(resultBlock) {
            resultBlock(responseData, erro);
        }
    }];
}

/**
 获取短信验证码和语音验证码
 
 @param requestBlock 请求配置的block
 @param resultBlock 请求结果回调的block
 */
- (void)verifyCodeRequestWithResultBlock:(void(^)(NYBaseRequest* request)) requestBlock resultBlock:(void(^)(id responseObject, NSError *error))resultBlock {
    NYBaseRequest *versionUpdateAPI = [[NYBaseRequest alloc] initWithDelegate:self];
    versionUpdateAPI.requestUrl = kHXBUser_smscodeURL;
    versionUpdateAPI.requestMethod = NYRequestMethodPost;
    if (requestBlock) {
        requestBlock(versionUpdateAPI);
    }
    [versionUpdateAPI loadData:^(NYBaseRequest *request, id responseObject) {
        if (resultBlock) {
            resultBlock(responseObject,nil);
        }
    } failure:^(NYBaseRequest *request, NSError *error) {
        if (resultBlock) {
            resultBlock(nil,error);
        }
    }];
}

- (void)getDataWithId:(NSString *)planId showHug:(BOOL)isShow resultBlock:(NetWorkResponseBlock)resultBlock {
    [self loadData:^(NYBaseRequest *request) {
        request.modelType = NSClassFromString(@"HSJPlanModel");
        request.requestUrl = kHXBFinanc_PlanDetaileURL(planId.integerValue);
        request.showHud = isShow;
    } responseResult:^(id responseData, NSError *erro) {
        if(resultBlock) {
            resultBlock(responseData, erro);
        }
    }];
}


/**
登出

 @param isShowHud 是否显示loading
 @param resultBlock 结果回调
 */
- (void)userLogOut:(BOOL)isShowHud resultBlock:(NetWorkResponseBlock)resultBlock {
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBUser_signOutURL;
        request.requestMethod = NYRequestMethodPost;
        request.showHud = isShowHud;
    } responseResult:^(id responseData, NSError *erro) {
        if(!erro) {
            [KeyChain signOut];
        }
        if(resultBlock) {
            resultBlock(resultBlock, erro);
        }
    }];
}
@end
