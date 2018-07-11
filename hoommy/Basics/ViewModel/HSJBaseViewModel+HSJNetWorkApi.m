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

- (void)downLoadUserInfo:(BOOL)isShowHud resultBlock:(NetWorkResponseBlock)resultBlock {
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.showHud= isShowHud;
        request.hudDelegate = weakSelf;
        request.requestUrl = [NSString stringWithFormat:@"http://192.168.1.31:3100%@",kHXBUser_UserInfoURL];//kHXBUser_UserInfoURL;//http://192.168.1.31:3100/transfer?page=1
        request.requestMethod = NYRequestMethodGet;
        request.modelType = NSClassFromString(@"HXBUserInfoModel");
    } responseResult:^(id responseData, NSError *erro) {
        if(resultBlock) {
            resultBlock(responseData, erro);
        }
    }];
}
@end
