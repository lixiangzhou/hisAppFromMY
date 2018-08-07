//
//  NYNetworkAgent.m
//  NYNetwork
//
//  Created by 牛严 on 16/6/28.
//  Copyright © 2016年 NYNetwork. All rights reserved.
//

#import "NYNetworkAgent.h"
#import "NYHTTPConnection.h"
#import "HXBBaseRequestManager.h"

@implementation NYNetworkAgent

+ (instancetype)sharedManager
{
    static NYNetworkAgent *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)addRequest:(NYBaseRequest *)request
{
    //防止同一个
    if([[HXBBaseRequestManager sharedInstance] sameRequestInstance:request]){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (request.failure) {
                NSError* erro = [NSError errorWithDomain:@"" code:HSJNetStateCodeAlreadyPopWindow userInfo:nil];
                request.failure(request, erro);
            }
        });
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    // 显示HUD
    if(request.showHud) {
        [request showLoading];
    }
    
    [[HXBBaseRequestManager sharedInstance] addRequest:request];
    NYHTTPConnection *connection = [[NYHTTPConnection alloc]init];
    
    __weak typeof (request) weakRequest = request;
    [connection connectWithRequest:request success:^(NYHTTPConnection *connection, id responseJsonObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self processConnection:connection withRequest:weakRequest responseJsonObject:responseJsonObject];
    } failure:^(NYHTTPConnection *connection, NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self processConnection:connection withRequest:weakRequest error:error];
    }];
}

- (void)processConnection:(NYHTTPConnection *)connection withRequest:(NYBaseRequest *)request responseJsonObject:(id)responseJsonObject
{
    if([[HXBBaseRequestManager sharedInstance] deleteRequest:request]) {
        // 适配重构前的HUD
        [request hideLoading:request];
        
        [self callBackRequestSuccess:request responseJsonObject:responseJsonObject];
    }
}

- (void)processConnection:(NYHTTPConnection *)connection withRequest:(NYBaseRequest *)request error:(NSError *)error
{
    if([[HXBBaseRequestManager sharedInstance] deleteRequest:request]) {
        // 适配重构前的HUD
        [request hideLoading:request];
        
        [self callBackRequestFailure:request error:error];
    }
}

//--------------------------------------------回调--------------------------------------------
/**
 *  成功回调
 */
- (void)callBackRequestSuccess:(NYBaseRequest *)request responseJsonObject:(id)responseJsonObject
{
    IDPLogDebug(@"======================👌👌 开始 👌👌====================================");
    IDPLogDebug(@"👌👌URL: %@,  Code =>%ld  ",request.requestUrl,(long)request.responseStatusCode);
    IDPLogDebug(@"👌👌请求 体 ----- %@",request.requestArgument);
    IDPLogDebug(@"👌👌相应 体 ------%@",responseJsonObject);
    IDPLogDebug(@"======================👌👌 结束 👌👌====================================");
    
    if (request.success) {
        if([responseJsonObject isKindOfClass:[NSDictionary class]]) {
            if([request.hudDelegate respondsToSelector:@selector(erroStateCodeDeal:response:)]) {
                if([request.hudDelegate erroStateCodeDeal:request response:responseJsonObject]) {
                    if(request.failure) {
                        NSError* erro = [NSError errorWithDomain:@"" code:HSJNetStateCodeAlreadyPopWindow userInfo:nil];
                        request.failure(request, erro);
                        return;
                    }
                }
            }
            NSDictionary* responseDic = responseJsonObject;
            NSString* codeValue = [responseDic stringAtPath:@"status"];
            if(![codeValue isEqualToString:@"0"]) {
                if(request.failure) {
                    request.failure(request, [NSError errorWithDomain:@"" code:HSJNetStateCodeCommonInterfaceErro userInfo:responseJsonObject]);
                    return;
                }
            }
        }
        
        request.success(request,responseJsonObject);
    }
}

/**
 *  失败回调
 */
- (void)callBackRequestFailure:(NYBaseRequest *)request error:(NSError *)error
{
    IDPLogDebug(@"======================👌👌 开始 👌👌====================================");
    IDPLogDebug(@"👌👌URL: %@,  Code =>%ld  ",request.requestUrl,(long)request.responseStatusCode);
    IDPLogDebug(@"👌👌请求 体 ----- %@",request.requestArgument);
    IDPLogDebug(@"👌👌相应 体 ------%@",error);
    IDPLogDebug(@"======================👌👌 结束 👌👌====================================");
    
    if (request.failure) {
        if([request.hudDelegate respondsToSelector:@selector(erroResponseCodeDeal:error:)]) {
            if([request.hudDelegate erroResponseCodeDeal:request error:error]) {
                NSError* erro = [NSError errorWithDomain:@"" code:HSJNetStateCodeAlreadyPopWindow userInfo:nil];
                request.failure(request, erro);
                return;
            }
        }
        
        if(!error) {
            error = [NSError errorWithDomain:@"" code:HSJNetStateCodeAlreadyPopWindow userInfo:nil];
        }
        request.failure(request, error);
    }
}
@end
