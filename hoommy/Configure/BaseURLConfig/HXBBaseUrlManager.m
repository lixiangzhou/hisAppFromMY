//
//  HXBBaseUrlManager.m
//  hoomxb
//
//  Created by lxz on 2017/11/16.
//Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBaseUrlManager.h"
#import <ReactiveObjC.h>
#define HXBBaseUrlKey @"HXBBaseUrlKey"

@interface HXBBaseUrlManager ()

@end

@implementation HXBBaseUrlManager

+ (instancetype)manager {
    static HXBBaseUrlManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [HXBBaseUrlManager new];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (HXBShakeChangeBaseUrl == NO) {
            // 线上环境
            _baseUrl = @"https://api.hoomxb.com";
        } else {
            NSString *storedBaseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:HXBBaseUrlKey];
            // http://192.168.1.36:3100 长度24
            if (storedBaseUrl.length > 0) {
                _baseUrl = storedBaseUrl;
            } else {
                _baseUrl = @"http://192.168.1.31:3100";
            }
        }
    }
    return self;
}

- (void)setBaseUrl:(NSString *)baseUrl {
    if (HXBShakeChangeBaseUrl == NO) {
        return;
    }
    _baseUrl = baseUrl;
    [[NSUserDefaults standardUserDefaults] setObject:baseUrl forKey:HXBBaseUrlKey];
}

- (void)startObserve {
    NYNetworkConfig *config = [NYNetworkConfig sharedInstance];
    config.baseUrl = [HXBBaseUrlManager manager].baseUrl;
    
    if (HXBShakeChangeBaseUrl == YES) {
        // 当baseUrl 改变的时候，需要更新 config.baseUrl
        [RACObserve(self, baseUrl) subscribeNext:^(id  _Nullable x) {
            config.baseUrl = x;
        }];
    }
}

@end
