//
//  UITextField+HxbTextField.h
//  hoomxb
//
//  Created by HXB-C on 2017/5/2.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (HxbTextField)

@property (nonatomic, assign) NSRange selectedRange;

+ (UITextField *)hxb_lineTextFieldWithFrame:(CGRect)frame;

@end
