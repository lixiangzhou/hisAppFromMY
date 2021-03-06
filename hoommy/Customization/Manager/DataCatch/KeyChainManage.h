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
#define kUserDefaults [NSUserDefaults standardUserDefaults]

#define kHXBGesturePWD [NSString stringWithFormat:@"kHXBGesturePWD%@", KeyChain.mobile ?: @""]
// 是否忽略手势密码
#define kHXBGesturePwdSkipeYES @"kHXBGesturePwdSkipeYES"    // 忽略
#define kHXBGesturePwdSkipeNO @"kHXBGesturePwdSkipeNO"      // 不忽略
#define kHXBGesturePwdSkipeNONE @"kHXBGesturePwdSkipeNONE"  // 相当于没有决定

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
///统一密文
@property (nonatomic, strong) NSString *ciphertext;

///手势密码
@property (nonatomic, copy) NSString  *gesturePwd;
///手势密码输入的次数，不存在返回 NSNotFound
@property (nonatomic, assign) NSInteger gesturePwdCount;
/// 是否忽略手势密码，值为 kHXBGesturePwdSkipeYES，或 kHXBGesturePwdSkipeNO
@property (nonatomic, copy) NSString *skipGesture;
/// 是否弹窗过忽略手势密码
@property (nonatomic, assign) BOOL skipGestureAlertAppeared;
///缓存首页获取的计划列表中的第一条记录的planid
@property (nonatomic ,copy) NSString *firstPlanIdInPlanList;

/**
 *  获取KeyChainManage单例
 */
+ (instancetype)sharedInstance;
- (void)signOut;      //!< 退出登录后的数据清理
- (void)removeGesture;
@end
