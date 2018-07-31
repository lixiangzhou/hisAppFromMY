//
//  NYNetworkConfig.m
//  NYNetwork
//
//  Created by 牛严 on 16/6/28.
//  Copyright © 2016年 NYNetwork. All rights reserved.
//

#import "NYNetworkConfig.h"
#import <AdSupport/AdSupport.h>
#import <UIKit/UIKit.h>
#import "NSDate+HXB.h"
#import "HXBDeviceVersion.h"

///通用接口Header必传字段 userAgent
static NSString *const User_Agent = @"X-Hxb-User-Agent";
///通用接口Header必传字段 token
static NSString *const X_HxbAuth_Token = @"X-Hxb-Auth-Token";
//
static NSString *HXBBaseUrlKey = @"HXBBaseUrlKey";

///网络数据的基本数据类
@interface NYNetworkConfig (){
    NSString *_baseUrl;
}

@property (nonatomic, strong, readwrite) NSDictionary *additionalHeaderFields;

@property (nonatomic, strong) NSString *systemVision;

@property (nonatomic, strong) NSString *userAgent;

@end

@implementation NYNetworkConfig

+ (NYNetworkConfig *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        //网络实时监控
        [sharedInstance networkMonitoring];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.systemVision = [[UIDevice currentDevice] systemVersion] ?: @"";
        self.version = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"] ?: @"";
        self.userAgent = [NSString stringWithFormat:@"%@/IOS %@/v%@ iphone" ,[HXBDeviceVersion deviceVersion],self.systemVision,self.version] ?: @"";
        _additionalHeaderFields = @{};
        _defaultTimeOutInterval = 20;
        self.defaultAcceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
        self.defaultAcceptableContentTypes = [NSSet setWithObjects:@"text/json", @"text/html", @"text/javascript", @"application/json",@"application/x-www-form-urlencoded",@"image/png", @"text/plain",nil];
    }
    return self;
}

- (NSString *)baseUrl {
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
    
    return _baseUrl;
}

- (void)setBaseUrl:(NSString *)baseUrl {
    if (HXBShakeChangeBaseUrl == NO) {
        return;
    }
    _baseUrl = baseUrl;
    [[NSUserDefaults standardUserDefaults] setObject:baseUrl forKey:HXBBaseUrlKey];
}

//MARK: 设置请求基本信息
- (NSDictionary *)additionalHeaderFields
{
    NSDictionary *dict = @{
                           X_HxbAuth_Token:[KeyChain token],
                           User_Agent:self.userAgent,
                           @"IDFA":[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],
                           @"X-Request-Id":[[[UIDevice currentDevice] identifierForVendor] UUIDString],
                           @"X-Hxb-Auth-Timestamp": [NSDate milliSecondSince1970],
                           @"X-Hxb-App-Name" : @"BABY"
                           };

    return dict;
}

//MARK: 网络实时监控
- (void)networkMonitoring {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];//开启网络监控
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
//                NSLog(@"🐯未知网络");
                break;
            case 0:
//                NSLog(@"🐯网络不可达");
                break;
            case 1:
//                NSLog(@"🐯GPRS网络");
                break;
            case 2:
//                NSLog(@"🐯wifi网络");
                break;
            default:
                break;
        }
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            KeyChain.ishaveNet = YES;
            NSLog(@"🐯有网");
        }else
        {
            NSLog(@"🐯没有网");
            KeyChain.ishaveNet = NO;
            [HxbHUDProgress showTextWithMessage:kNoNetworkText];
        }
    }];
}
@end
