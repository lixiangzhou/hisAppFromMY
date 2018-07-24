//
//  HSJBaseViewModel.m
//  hoomxb
//
//  Created by caihongji on 2017/12/29.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HSJBaseViewModel.h"
#import "HXBRootVCManager.h"
#import "SGInfoAlert.h"
#import "HXBBaseRequestManager.h"

@interface HSJBaseViewModel()

@end

@implementation HSJBaseViewModel


- (void)dealloc
{
    [[HXBBaseRequestManager sharedInstance] cancelRequest:self];
    if([self getHugView] == [UIApplication sharedApplication].keyWindow) {
        [self hideProgress:nil];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isFilterHugHidden = YES;
    }
    return self;
}

//重写基类获取hug父视图的方法
- (UIView *)getHugView {
    if(self.hugViewBlock) {
        return self.hugViewBlock();
    }
    
    return [super getHugView];
}

- (void)hideProgress:(NYBaseRequest *)request {
    if(self.isFilterHugHidden) {
        if(!request || request.showHud) {
            [super hideProgress:request];
        }
    }
    else {
        [super hideProgress:request];
    }
}

- (BOOL)isLoadingData {
    return [[HXBBaseRequestManager sharedInstance] isSendingRequest:self];
}
/**
 viewmodel中统一的网络数据加载方法
 
 @param requestBlock 在这个回调中可以补充request参数
 @param responseBlock 回调结果给发送者
 */
- (void)loadData:(void(^)(NYBaseRequest *request))requestBlock responseResult:(NetWorkResponseBlock)responseBlock{
    NYBaseRequest* request = [[NYBaseRequest alloc] initWithDelegate:self];
    if(requestBlock) {
        requestBlock(request);
    }
    
    [request loadData:^(NYBaseRequest *request, id responseObject) {
        id result = responseObject;
        if([request.modelType isSubclassOfClass:[Jastor class]]) {//自动解析
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary* dataDic = responseObject;
                Jastor* model = [[request.modelType alloc] init];
                [model setDataFromDictionary:[dataDic dictAtPath:@"data"]];
                result = model;
            }
        }
        if(responseBlock) {
            responseBlock(result, nil);
        }
    } failure:^(NYBaseRequest *request, NSError *error) {
        if(responseBlock) {
            responseBlock(nil, error);
        }
    }];
}

/**
 获取状态码
 
 @param responseObj 网络响应数据
 @return 状态码
 */
- (int)getStateCode:(NSDictionary*)responseObj {
    int statusCode = [responseObj stringAtPath:@"statusCode"].intValue;
    
    return statusCode;
}

/**
 获取网络错误消息
 
 @param responseObj 网络响应数据
 @return 消息
 */
- (NSString*)getErroMessage:(NSDictionary*)responseObj {
    NSString *errMsg = [responseObj stringAtPath:@"message"];
    
    return errMsg;
}
@end
