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

static const char kMBProgressHUDKey = '\0';
static const char kNetRequestListKey = '\0';

@implementation NSObject (HSJNetRequestDelegate)

#pragma mark 属性设置

- (UIView*)getHugView {
    return [HXBRootVCManager manager].topVC.view;
}

- (void)setNetRequestList:(NSMutableArray *)netRequestList {
    [self willChangeValueForKey:@"userInfoModel"]; // KVO
    objc_setAssociatedObject(self, &kNetRequestListKey,
                             netRequestList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"userInfoModel"]; // KVO
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
    MBProgressHUD* hudView = objc_getAssociatedObject(self, &kMBProgressHUDKey);
    if (!hudView) {
        hudView = [[MBProgressHUD alloc] initWithView:parentV];
        hudView.removeFromSuperViewOnHide = YES;
        hudView.contentColor = [UIColor whiteColor];
        hudView.bezelView.backgroundColor = [UIColor blackColor];
        hudView.label.textColor = [UIColor whiteColor];
        objc_setAssociatedObject(self, &kMBProgressHUDKey,
                                 hudView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    hudView.label.text = hudContent;
    [parentV addSubview:hudView];
    if(isShow){
        [parentV bringSubviewToFront:hudView];
        [hudView showAnimated:NO];
    }
    else{
        [hudView hideAnimated:YES];
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

- (void)hideProgress {
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
    
    return NO;
}

#pragma mark - 部分页面用到Page++ 的处理

/**
 错误的响应码处理
 
 @param request 请求对象
 @return 是否已经做了处理
 */
- (BOOL)erroResponseCodeDeal:(NYBaseRequest *)request error:(NSError *)error{
    
    return NO;
}

@end
