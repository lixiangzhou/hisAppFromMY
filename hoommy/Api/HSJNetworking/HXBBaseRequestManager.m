//
//  HXBBaseRequestManager.m
//  hoomxb
//
//  Created by caihongji on 2017/12/13.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBaseRequestManager.h"
#import "NYHTTPConnection.h"

@interface HXBBaseRequestManager()
// 线程锁
@property (nonatomic, strong) NSConditionLock* conditionLock;
// request列表
@property (nonatomic, strong) NSMutableArray* requestList;
//等待token获取结果的列表
@property (nonatomic, strong) NSMutableArray* waitTokenResultList;

@end

@implementation HXBBaseRequestManager

+ (instancetype)sharedInstance
{
    static HXBBaseRequestManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _conditionLock = [[NSConditionLock alloc] init];
        _requestList = [NSMutableArray array];
        _waitTokenResultList = [NSMutableArray array];
    }
    return self;
}

- (BOOL)isGettingToken
{
    BOOL result = NO;
    
    [self.conditionLock lock];
    
    if(self.waitTokenResultList.count > 0) {
        result = YES;
    }
    
    [self.conditionLock unlock];
    
    return result;
}

- (BOOL)isHasSendingRequest
{
    BOOL result = NO;
    
    [self.conditionLock lock];
    
    if(self.requestList.count > 0) {
        result = YES;
    }
    
    [self.conditionLock unlock];
    
    return result;
}

/**
 添加请求
 
 @param request 请求对象
 */
- (void)addRequest:(NYBaseRequest*)request
{
    [self.conditionLock lock];
    
    if(request.hudDelegate) {
        for(NYBaseRequest* base in self.requestList) {
            if(![base defferRequest:request]) {//同一个请求
                [base cancelRequest];
                [self.requestList removeObject:base];
                if([base.hudDelegate respondsToSelector:@selector(removeRequestObject:)]){
                    [base.hudDelegate removeRequestObject:base];
                }
                [self.waitTokenResultList removeObject:base];
                break;
            }
        }
    }
    [self.requestList addObject:request];
    if([request.hudDelegate respondsToSelector:@selector(addRequestObject:)]) {
        [request.hudDelegate addRequestObject:request];
    }
    
    [self.conditionLock unlock];
}

/**
 当前是否存在相同的请求实例，如果存在，则请求不能发出
 
 @param request 请求对象
 @return 是否存在
 */
- (BOOL)sameRequestInstance:(NYBaseRequest*)request
{
    BOOL result = NO;
    [self.conditionLock lock];
    
    for(NYBaseRequest* base in self.requestList) {
        if(base == request) {//同一个请求
            result = YES;
            break;
        }
    }
    
    [self.conditionLock unlock];
    
    return result;
}
/**
 删除请求
 
 @param request 请求对象
 @return 这个请求对象是否存在
 */
- (BOOL)deleteRequest:(NYBaseRequest*)request
{
    BOOL isFind = NO;
    
    [self.conditionLock lock];
    
    if([self.requestList containsObject:request]) {
        isFind = YES;
        [self.requestList removeObject:request];
        if([request.hudDelegate respondsToSelector:@selector(removeRequestObject:)]){
            [request.hudDelegate removeRequestObject:request];
        }
    }
    
    [self.conditionLock unlock];
    
    return isFind;
}

/**
 添加需要重新获取令牌的请求
 
 @param request 请求对象
 */
- (void)addTokenInvalidRequest:(NYBaseRequest*)request
{
    [self.conditionLock lock];
    
    [self.waitTokenResultList addObject:request];
    
    [self.conditionLock unlock];
}

/**
 
 发送刷新令牌后的通知
 
 @param isSuccess 令牌是否成功刷新
 */
- (void)sendFreshTokenNotify:(BOOL)isSuccess
{
    [self.conditionLock lock];
    
    for(NYBaseRequest *base in self.waitTokenResultList) {
        [base.connection tokenUpdateNotify:base updateState:isSuccess];
    }
    [self.waitTokenResultList removeAllObjects];
    
    [self.conditionLock unlock];
}

/**
 取消发送者发出的所有请求
 
 @param sender 请求发送者
 */
- (void)cancelRequest:(id)sender
{
    [self.conditionLock lock];
    NSArray* requestList = nil;
    if([sender respondsToSelector:@selector(getRequestObjectList)]) {
        requestList = [sender getRequestObjectList];
    }
    if(requestList.count > 0) {
        for(NYBaseRequest* base in self.requestList) {
            if([requestList containsObject:base]) {
                [base cancelRequest];
            }
        }
    }
    
    [self.conditionLock unlock];
}

/**
 sender是否正在发送请求
 
 @param sender 请求发送者
 */
- (BOOL)isSendingRequest:(id)sender
{
    BOOL result = NO;
    
    [self.conditionLock lock];
    
    for(NYBaseRequest* base in self.requestList) {
        if(base.hudDelegate && base.hudDelegate == sender) {
            result = YES;
            break;
        }
    }
    
    [self.conditionLock unlock];
    
    return result;
}

/**
 请求是否有效
 
 @param request 请求对象
 @return 判断结果
 */
- (BOOL)isValidRequest:(NYBaseRequest*)request {
    BOOL result = NO;
    
    [self.conditionLock lock];
    
    result = [self.requestList containsObject:request];
    
    [self.conditionLock unlock];
    
    return result;
}
@end
