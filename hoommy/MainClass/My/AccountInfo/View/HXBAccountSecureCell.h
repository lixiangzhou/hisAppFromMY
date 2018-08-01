//
//  HXBAccountSecureCell.h
//  hoomxb
//
//  Created by lxz on 2017/12/11.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBottomLineTableViewCell.h"

typedef NS_ENUM(NSUInteger, HXBAccountSecureType) {
    HXBAccountSecureTypeNone = 0,
    HXBAccountSecureTypeModifyPhone = 1,    /// 修改手机号
    HXBAccountSecureTypeLoginPwd,   /// 登录密码
    HXBAccountSecureTypeTransactionPwd, // 交易密码
    HXBAccountSecureTypeGesturePwdModify, /// 修改手势密码
    HXBAccountSecureTypeGesturePwdSwitch, /// 手势密码开关
    HXBAccountSecureTypeCommonProblems, /// 常见问题
    HXBAccountSecureTypeAboutUs, /// 关于我们
    HXBAccountSecureTypeExitAccount, /// 退出红小宝账户
};

typedef void(^HXBHXBAccountSecureSwitchBlock)(BOOL);

@interface HXBAccountSecureModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) HXBAccountSecureType type;
@property (nonatomic, copy) HXBHXBAccountSecureSwitchBlock switchBlock;
@end

#define HXBAccountSecureCellID @"HXBAccountSecureCellID"

@interface HXBAccountSecureCell : UITableViewCell//HXBBottomLineTableViewCell
@property (nonatomic, strong) HXBAccountSecureModel *model;
@end
