//
//  HSJNetStateCode.h
//  HXBCriterionProject
//
//  Created by caihongji on 2017/11/28.
//  Copyright © 2017年 caihongji. All rights reserved.
//
#ifndef HSJNetStateCode_h
#define HSJNetStateCode_h

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HSJNetStateCodeTokenNotJurisdiction = 401,
    // 如果网络层已经做了弹窗处理， 那么就会返回这个错误码
    HSJNetStateCodeAlreadyPopWindow = -100000,
    // 当封装多处使用的通用接口时， 如果state的值是非0值， 那么就以这个错误吗构建一个NSErro对象，回传给调用者
    HSJNetStateCodeCommonInterfaceErro = -200000,
    // 成功
    HSJNetStateCodeSuccess = 0
} HSJNetStateCode;


#endif /* HSJNetStateCode_h */
