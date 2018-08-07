//
//  NSObject+HSJNetRequestDelegate.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/17.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "NSObject+HSNetRequestDelegate.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SGInfoAlert.h"
#import "HSJTokenManager.h"
#import "HSJProgressView.h"

static const char kNetRequestListKey = '\0';
static const char kHSJProgressViewKey = '\0';

@implementation NSObject (HSJNetRequestDelegate)

#pragma mark 属性设置

- (UIView*)getHugView {
    return nil;
}

- (void)setNetRequestList:(NSMutableArray *)netRequestList {
    [self willChangeValueForKey:@"netRequestList"]; // KVO
    objc_setAssociatedObject(self, &kNetRequestListKey,
                             netRequestList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"netRequestList"]; // KVO
}

- (NSMutableArray *)netRequestList {
    NSMutableArray* requestList = objc_getAssociatedObject(self, &kNetRequestListKey);
    if(!requestList){
        requestList = [[NSMutableArray alloc] init];
        self.netRequestList = requestList;
    }
    return requestList;
}

#pragma mark 自定义弹窗

- (void)showMBP:(BOOL)isShow withHudContent:(NSString*)hudContent{
    UIView* parentV = [self getHugView];
    HSJProgressView *progressView = objc_getAssociatedObject(self, &kHSJProgressViewKey);
    if (progressView == nil) {
        progressView = [HSJProgressView new];
        objc_setAssociatedObject(self, &kHSJProgressViewKey, progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [parentV addSubview:progressView];
    if (isShow) {
        [parentV bringSubviewToFront:progressView];
        [progressView show];
    } else {
        [progressView hide];
    }
}

#pragma mark 弹框显示
- (void)showProgress:(NSString*)hudContent {
    [self showMBP:YES withHudContent:hudContent];
}

- (void)showToast:(NSString *)toast {
    if([toast containsString:@"failure"]) {
        return;
    }
    UIView* parentView = [self getHugView];
    if(parentView) {
        [SGInfoAlert showInfo:toast bgColor:[UIColor blackColor].CGColor inView:parentView vertical:0.3];
    }
}

- (void)hideProgress:(NYBaseRequest *)request {
    [self showMBP:NO withHudContent:nil];
}

#pragma mark在委托者中操作请求对象

/**
 添加请求到委托者
 
 @param request 请求对象
 */
- (void)addRequestObject:(NYBaseRequest *)request {
    [self.netRequestList addObject:request];
}

/**
 移除请求从委托者
 
 @param request 请求对象
 */
- (void)removeRequestObject:(NYBaseRequest *)request {
    [self.netRequestList removeObject:request];
}

/**
 从委托者获取其中的请求列表
 
 @return 请求列表
 */
- (NSArray*)getRequestObjectList {
    return self.netRequestList;
}

#pragma mark 错误码处理
/**
 错误的状态码处理
 
 @param request 请求对象
 @return 是否已经做了处理
 */
- (BOOL)erroStateCodeDeal:(NYBaseRequest *)request response:(NSDictionary *)responseObject{
    
    if([self handlingSpecialRequests:request]){
        return NO;
    }
    
    if ([responseObject[kResponseStatus] integerValue]) {
        NSLog(@" ---------- %@",responseObject[kResponseStatus]);
        
        //当errorType字段不存在或者其值等于“TOAST”的时候， 才做错误处理
        NSString *errorType = [[responseObject valueForKey:kResponseErrorData] valueForKey:@"errorType"];
        if (!errorType || [errorType isEqualToString:@"TOAST"]) {
            NSString *status = responseObject[kResponseStatus];
            if (status.integerValue == kHXBCode_Enum_ProcessingField) {
                NSDictionary *dic = responseObject[kResponseData];
                __block NSString *error = @"";
                [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    NSArray *arr = obj;
                    if([arr isKindOfClass:[NSArray class]] && arr.count>0) {
                        error = arr[0];
                        *stop = YES;
                    }
                }];
                [self showToast:error];
                return YES;
            } else if(status.integerValue == kHXBCode_Enum_RequestOverrun){
                if (![self handlingSpecialErrorCodes:request]) {
                    [self showToast:responseObject[kResponseMessage]];
                    return YES;
                }
            } else{
                [self showToast:responseObject[kResponseMessage]];
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - 部分页面用到Page++ 的处理

/**
 错误的响应码处理
 
 @param request 请求对象
 @return 是否已经做了处理
 */
- (BOOL)erroResponseCodeDeal:(NYBaseRequest *)request error:(NSError *)error{
    
    if([self handlingSpecialRequests:request]){
        return NO;
    }
    
    switch (request.responseStatusCode) {
        case kHXBCode_Enum_NotSigin:/// 没有登录
        {
            [[HSJTokenManager sharedInstance] processTokenInvidate];
            return YES;
        }
        case kHXBCode_Enum_NoServerFaile:
        {
            [self showToast:@"网络连接失败，请稍后再试"];
            return YES;
        }
        default:
            break;
    }
    
    if (!KeyChain.ishaveNet) {
        [self showToast:@"暂无网络，请稍后再试"];
        return YES;
    }
    
    NSString *str = error.userInfo[@"NSLocalizedDescription"];
    if (str.length > 0) {
        if ([[str substringFromIndex:str.length - 1] isEqualToString:@"。"]) {
            str = [str substringToIndex:str.length - 1];
            if ([str containsString:@"请求超时"]) {
                [self showToast:str];
                return YES;
            }
        } else {
            if (error.code != kHXBPurchase_Processing) { // 请求任务取消
                [self showToast:str];
                return YES;
            }
        }
    }
    return NO;
}

/**
 闪屏、升级和首页弹窗 不处理异常返回结果
 */
- (BOOL)handlingSpecialRequests:(NYBaseRequest *)request{
    //闪屏、升级和首页弹窗 不处理异常返回结果
//    if ([request.requestUrl isEqualToString:kHXBSplash] || [request.requestUrl isEqualToString:kHXBHome_PopView]||[request.requestUrl isEqualToString:kHXBMY_VersionUpdateURL]) {
//        return YES;
//    }
    return NO;
}

/**
 处理不需要提示412问题
 */
- (BOOL)handlingSpecialErrorCodes:(NYBaseRequest *)request {
    if ([request.requestUrl isEqualToString:kHXBUser_checkCardBin]) {
        return YES;
    }
//    if ([request.requestUrl isEqualToString:kHXB_Coupon_Best]) {
//        return YES;
//    }
    return NO;
}

@end
