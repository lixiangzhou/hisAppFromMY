//
//  HSJRollOutPlanDetailRowModel.h
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    /// 左边 右边 都是文本
    HSJRollOutPlanDetailRowTypeNormal = 1,
    /// 左边文本 右边箭头，点击跳转特定的页面
    HSJRollOutPlanDetailRowTypeAction,
    /// 左边文本 右边箭头，点击跳转协议的页面
    HSJRollOutPlanDetailRowTypeProtocol,
} HSJRollOutPlanDetailRowType;

@interface HSJRollOutPlanDetailRowModel : NSObject
@property (nonatomic, copy) NSString *left;

/// HSJRollOutPlanDetailRowTypeNormal 时有值
@property (nonatomic, copy) NSString *right;

/// HSJRollOutPlanDetailRowTypeProtocol 时有值
@property (nonatomic, copy) NSString *protocol;
/// HSJRollOutPlanDetailRowTypeAction 时有值
@property (nonatomic, copy) NSString *className;

/// type
@property (nonatomic, assign) HSJRollOutPlanDetailRowType type;

- (instancetype)initWithType:(HSJRollOutPlanDetailRowType)type left:(NSString *)left right:(NSString *)right protocol:(NSString *)protocol className:(NSString *)className;

@end
