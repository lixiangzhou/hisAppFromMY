//
//  HSJBaseViewModel.h
//  hoomxb
//
//  Created by caihongji on 2017/12/29.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HSNetRequestDelegate.h"

typedef enum : NSUInteger {
    HSJRefreshFooterTypeMoreData,
    HSJRefreshFooterTypeNoMoreData,
    HSJRefreshFooterTypeNone,
} HSJRefreshFooterType;

//获取hud的父视图
typedef UIView* (^HugViewBlock)(void);
//业务层网络数据的统一返回标准
typedef void(^NetWorkResponseBlock)(id responseData, NSError* erro);


@interface HSJBaseViewModel : NSObject

//是否在hug隐藏的方法中进行过滤
@property (nonatomic, assign) BOOL isFilterHugHidden;
//是否正在请求数据
@property (nonatomic, assign, readonly) BOOL isLoadingData;

@property (nonatomic, strong) HugViewBlock hugViewBlock;

/**
 viewmodel中统一的网络数据加载方法

 @param requestBlock 在这个回调中可以补充request参数
 @param responseBlock 回调结果给发送者
 */
- (void)loadData:(void(^)(NYBaseRequest *request))requestBlock responseResult:(void(^)(id responseData, NSError* erro))responseBlock;

/**
 获取状态码

 @param responseObj 网络响应数据
 @return 状态码
 */
- (int)getStateCode:(NSDictionary*)responseObj;

/**
 获取网络错误消息
 
 @param responseObj 网络响应数据
 @return 消息
 */
- (NSString*)getErroMessage:(NSDictionary*)responseObj;
@end
