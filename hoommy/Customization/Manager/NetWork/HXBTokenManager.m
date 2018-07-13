//
//  HXBTokenManager.m
//  hoomxb
//
//  Created by HXB on 2017/6/3.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBTokenManager.h"
#import "HXBTokenModel.h"


@implementation HXBTokenManager
+ (void)downLoadTokenWithURL: (NSString *)urlStr andDownLoadTokenSucceedBlock: (void(^)(NSString *token))downLoadTokenSucceedBlock andFailureBlock: (void(^)(NSError *error))failureBlock {
    if (!urlStr) urlStr = kHXBTokenURL;
   ///创建session
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *tokenURL = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:tokenURL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:requestM.copy completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *dic = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] objectForKey:kHXBDownLoadTokenKey];
            HXBTokenModel *model = [[HXBTokenModel alloc] initWithDictionary:[dic dictAtPath:@"data"]];
            KeyChain.token = model.token;
            ///下载成功的回调
            if (downLoadTokenSucceedBlock) {
                downLoadTokenSucceedBlock(KeyChain.token);
            }
        }else if(error){
            ///失败的回调
            if (failureBlock) {
                failureBlock(error);
            }
        }
    }];
    ///开始执行
    [dataTask resume];
}
@end
