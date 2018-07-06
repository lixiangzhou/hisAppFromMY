//
//  HSJBaseViewModel.h
//  hoomxb
//
//  Created by caihongji on 2017/12/29.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HSNetRequestDelegate.h"

//获取hud的父视图
typedef UIView* (^HugViewBlock)(void);
//业务层网络数据的统一返回标准
typedef void(^NetWorkResponseBlock)(id responseData, NSError* erro);


@interface HSJBaseViewModel : NSObject

@property (nonatomic, strong) HugViewBlock hugViewBlock;

/**
 viewmodel中统一的网络数据加载方法

 @param requestBlock 在这个回调中可以补充request参数
 @param responseBlock 回调结果给发送者
 */
- (void)loadData:(void(^)(NYBaseRequest *request))requestBlock responseResult:(void(^)(id responseData, NSError* erro))responseBlock;
@end
