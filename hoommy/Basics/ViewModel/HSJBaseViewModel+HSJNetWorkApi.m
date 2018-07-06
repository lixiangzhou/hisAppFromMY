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

@end
