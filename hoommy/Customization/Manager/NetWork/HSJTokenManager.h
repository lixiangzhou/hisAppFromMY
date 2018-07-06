//
//  HSJTokenManager.h
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/17.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSJTokenManager : NSObject

/**
 *  获取HSJTokenManager单例
 */
+ (instancetype)sharedInstance;

/**
 刷新令牌
 */
- (void)getAccessToken;

/**
 令牌失效处理
 */
- (void)processTokenInvidate;
@end
