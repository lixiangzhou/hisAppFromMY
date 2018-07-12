//
//  KeyChainManage.h
//  HongXiaoBao
//
//  Created by 牛严 on 16/6/16.
//  Copyright © 2016年 hongxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXBUserInfoModel.h"

#define KeyChain [KeyChainManage sharedInstance]

@interface KeyChainManage : NSObject

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, copy) NSString  *token;
///用户手机号
@property (nonatomic,copy) NSString *mobile;
/**
 h5根地址
 */
@property (nonatomic, copy) NSString *h5host;
//是否有网络
@property (nonatomic, assign) BOOL ishaveNet;
///记录修改登录密码的次数
@property (nonatomic, copy) NSString *siginCount;



/**
 *  获取KeyChainManage单例
 */
+ (instancetype)sharedInstance;
- (void)signOut;      //!< 退出登录
@end
