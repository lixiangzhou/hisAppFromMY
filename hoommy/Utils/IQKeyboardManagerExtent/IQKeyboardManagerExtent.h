//
//  IQKeyboardManagerExtent.h
//  hoommy
//
//  Created by caihongji on 2018/8/8.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IQKeyboardManager.h"

@interface IQKeyboardManagerExtent : NSObject
@property(nonatomic, assign) BOOL enable;

+ (instancetype)sharedInstance;

- (void)setKeyboardManager;
@end

@protocol KeyboardSizeChange<NSObject>

@optional
- (void)keyboardShow:(CGRect)rect;
- (void)keyboardHidden;

@end
