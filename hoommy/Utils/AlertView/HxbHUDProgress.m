//
//  HxbHUDProgress.m
//  hoomxb
//
//  Created by HXB-C on 2017/4/18.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HxbHUDProgress.h"
#import "SGInfoAlert.h"

@interface HxbHUDProgress ()

@end


@implementation HxbHUDProgress

+ (void)showTextWithMessage:(NSString *)message{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self showTextInView:keyWindow text:message];
}

+ (void)showTextInView:(UIView*)view text:(NSString *)message {
    if(message.length <= 0) {
        return;
    }
    [SGInfoAlert showInfo:message bgColor:[UIColor blackColor].CGColor inView:view vertical:0.3];
}

@end
