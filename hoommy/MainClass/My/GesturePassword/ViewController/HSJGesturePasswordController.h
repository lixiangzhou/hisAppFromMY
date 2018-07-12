//
//  HSJGesturePasswordController.h
//  hoommy
//
//  Created by lxz on 2018/7/9.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HXBBaseViewController.h"

/// 手势密码开关类型
typedef NS_ENUM(NSUInteger, HSJAccountSecureSwitchType) {
    HSJAccountSecureSwitchTypeNone,     // 无
    HSJAccountSecureSwitchTypeOn,       // 开
    HSJAccountSecureSwitchTypeOff,      // 关
    HSJAccountSecureSwitchTypeChange,   // 修改
};

typedef enum {
    HSJGesturePasswordTypeSetting = 1,
    HSJGesturePasswordTypeLogin
} HSJGesturePasswordType;

@interface HSJGesturePasswordController : HXBBaseViewController

/**
 *  控制器来源类型
 */
@property (nonatomic, assign) HSJGesturePasswordType type;
/// 手势密码开关
@property (nonatomic, assign) HSJAccountSecureSwitchType switchType;

@end
