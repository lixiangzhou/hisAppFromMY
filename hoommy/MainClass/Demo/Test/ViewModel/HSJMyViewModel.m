//
//  HSJMyViewModel.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/17.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJMyViewModel.h"
#import "NSData+IDPExtension.h"

@implementation HSJMyViewModel

- (void)getBaiduData {
    
    NYBaseRequest *versionUpdateAPI = [[NYBaseRequest alloc] initWithDelegate:self];
    versionUpdateAPI.baseUrl = @"http://192.168.1.32:8039/gateway/personalRegisterExpand";
    versionUpdateAPI.showHud = YES;
    versionUpdateAPI.isReturnJsonData = NO;
    
    [versionUpdateAPI loadData:^(NYBaseRequest *request, id responseObject) {
        NSData* data = responseObject;
        NSString* test = [data UTF8String];
        IDPLogDebug(@"%@", test);
        int i = 0;
        i++;
    } failure:^(NYBaseRequest *request, NSError *error) {
        
    }];
}

- (void)checkVersionUpdate:(NetWorkResponseBlock)resultBlock {
    [super checkVersionUpdate:^(id responseData, NSError* erro) {
        if(!erro) {
            HXBVersionUpdateModel* model = responseData;
            int i = 0;
            i++;
        }
        resultBlock(responseData, erro);
    }];
}
@end
