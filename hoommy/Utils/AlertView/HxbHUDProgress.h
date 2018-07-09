//
//  HxbHUDProgress.h
//  hoomxb
//
//  Created by HXB-C on 2017/4/18.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HxbHUDProgress : NSObject

+ (void)showTextWithMessage:(NSString *)message;

+ (void)showTextInView:(UIView*)view text:(NSString *)message;
@end
