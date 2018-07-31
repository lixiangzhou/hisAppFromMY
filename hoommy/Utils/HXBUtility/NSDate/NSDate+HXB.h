//
//  NSDate+HXB.h
//  hoomxb
//
//  Created by lxz on 2017/11/23.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HXB)
/// 毫秒级时间
+ (NSString *)milliSecondSince1970;

/// 传入date，返回此天的0时0分0秒时间
+ (NSDate *)getDayZeroTimestamp:(NSDate *)aDate;
@end
