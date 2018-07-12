//
//  HSJGestureLoginController.h
//  hoommy
//
//  Created by lxz on 2018/7/12.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HXBBaseViewController.h"

typedef enum : NSUInteger {
     HSJGestureTypeLogin,
    HSJGestureTypeSetting,
} HSJGestureType;

@interface HSJGestureLoginController : HXBBaseViewController
@property (nonatomic, assign) HSJGestureType type;
@end
