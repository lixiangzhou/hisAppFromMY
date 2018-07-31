//
//  NSDate+HXB.m
//  hoomxb
//
//  Created by lxz on 2017/11/23.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "NSDate+HXB.h"

@implementation NSDate (HXB)

+ (NSString *)milliSecondSince1970 {
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970] * 1000;
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    return [NSString stringWithFormat:@"%llu",theTime];
}


/// 传入date，返回此天的0时0分0秒时间
+ (NSDate *)getDayZeroTimestamp:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day])];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd"];
    
    NSString *todayTimestamp = [NSString stringWithFormat:@"%@ 00:00:00",[dateday stringFromDate:beginningOfWeek]];//@"2023-10-23 00:00:00";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    return [formatter dateFromString:todayTimestamp];//将字符串转换为时间对象;
}
@end
