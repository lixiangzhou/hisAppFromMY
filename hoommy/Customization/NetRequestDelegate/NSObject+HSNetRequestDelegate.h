//
//  NSObject+HSJNetRequestDelegate.h
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/17.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSJNetRequestDelegate.h"

@interface NSObject (HSJNetRequestDelegate) <HSJNetRequestDelegate>

/**
 当前对象内所有发出的网络请求对象
 */
@property (nonatomic, strong) NSMutableArray* netRequestList;

/**
 获取loading框的父视图

 @return 父视图
 */
- (UIView*)getHugView;
@end
