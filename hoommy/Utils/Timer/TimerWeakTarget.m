//
//  TimerWeakTarget.m
//  测试
//
//  Created by HXB-C on 2018/6/20.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "TimerWeakTarget.h"

@implementation TimerWeakTarget

+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats{
    
    TimerWeakTarget * timer = [TimerWeakTarget new];
    timer.target = aTarget;
    timer.selector = aSelector;
    //-------------------------------------------------------------此处的target已经被换掉了不是原来的VIewController而是TimerWeakTarget类的对象timer
    timer.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:timer selector:@selector(fire:) userInfo:userInfo repeats:repeats];
    return timer.timer;
}



-(void)fire:(NSTimer *)timer{
    
    if (self.target) {
        [self.target performSelector:self.selector withObject:timer.userInfo];
    } else {
        
        [self.timer invalidate];
    }
}

@end
