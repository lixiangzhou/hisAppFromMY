//
//  HSJTokenManager.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/17.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJTokenManager.h"
#import "HXBTokenModel.h"
#import "NYNetworkConfig.h"
#import "HXBBaseRequestManager.h"

static NSString *const kTokenUrl = @"/token";
@implementation HSJTokenManager

/**
 *  获取HSJTokenManager单例
 */
+ (instancetype)sharedInstance {
    static HSJTokenManager *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

/**
 获取令牌
 */
- (void)getAccessToken{
    
    KeyChain.token = nil;
    NSString *tokenURLString = [NSString stringWithFormat:@"%@%@",[NYNetworkConfig sharedInstance].baseUrl,kTokenUrl];
    NSURL *tokenURL =[NSURL URLWithString:tokenURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:tokenURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    kWeakSelf
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!data) {
                                          [weakSelf updateAccessToken:nil];
                                          return ;
                                      }
                                      NSDictionary *dict = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] objectForKey:@"data"];
                                      HXBTokenModel *model = [[HXBTokenModel alloc] initWithDictionary:dict];
                                      [weakSelf updateAccessToken:model.token];
                                  }];
    [task resume];
}

- (void)updateAccessToken:(NSString *)token {
    BOOL result = NO;
    if (token) {
        KeyChain.token = token;
        result = YES;
        
    }
    if(result) {
        [self processTokenInvidate];
    }
    [[HXBBaseRequestManager sharedInstance] sendFreshTokenNotify:result];
}
/**
 令牌失效处理
 */
- (void)processTokenInvidate {
    
}
@end
