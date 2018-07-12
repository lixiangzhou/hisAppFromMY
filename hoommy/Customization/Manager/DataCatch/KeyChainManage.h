//
//  KeyChainManage.h
//  HongXiaoBao
//
//  Created by 牛严 on 16/6/16.
//  Copyright © 2016年 hongxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#define KeyChain [KeyChainManage sharedInstance]
#define kUserDefaults [NSUserDefaults standardUserDefaults]

#define kHXBGesturePWD [NSString stringWithFormat:@"kHXBGesturePWD%@", KeyChain.mobile ?: @""]
// 是否忽略手势密码
#define kHXBGesturePwdSkipeYES @"kHXBGesturePwdSkipeYES"
#define kHXBGesturePwdSkipeNO @"kHXBGesturePwdSkipeNO"

@interface KeyChainManage : NSObject

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, copy) NSString  *token;
/**
 h5根地址
 */
@property (nonatomic, copy) NSString *h5host;

/// 用户手机号
@property (nonatomic,copy) NSString *mobile;
///手势密码
@property (nonatomic, copy) NSString  *gesturePwd;
///手势密码输入的次数，不存在返回 NSNotFound
@property (nonatomic, assign) NSInteger gesturePwdCount;
/// 是否忽略手势密码，值为 kHXBGesturePwdSkipeYES，或 kHXBGesturePwdSkipeNO
@property (nonatomic, copy) NSString *skipGesture;
/// 是否弹窗过忽略手势密码
@property (nonatomic, assign) BOOL skipGestureAlertAppeared;

/**
 *  获取KeyChainManage单例
 */
+ (instancetype)sharedInstance;
- (void)signOut;      //!< 退出登录
- (void)removeGesture;
@end
