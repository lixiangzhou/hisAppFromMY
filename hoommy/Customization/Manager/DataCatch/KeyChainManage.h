//
//  KeyChainManage.h
//  HongXiaoBao
//
//  Created by 牛严 on 16/6/16.
//  Copyright © 2016年 hongxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#define KeyChain [KeyChainManage sharedInstance]

@interface KeyChainManage : NSObject

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, copy) NSString  *token;
/**
 *  获取KeyChainManage单例
 */
+ (instancetype)sharedInstance;

@end