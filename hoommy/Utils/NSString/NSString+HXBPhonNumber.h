//
//  NSString+HXBPhonNumber.h
//  hoomxb
//
//  Created by HXB on 2017/6/3.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <Foundation/Foundation.h>
///隐藏了手机号码中的中间字段
@interface NSString (HXBPhonNumber)
///隐藏了手机号码中的中间字段
- (NSString *) hxb_hiddenPhonNumberWithMid;
///隐藏了真实姓名前面的字段
- (NSString *) hxb_hiddenUserNameWithleft;
///隐藏了银行卡号
- (NSString *) hxb_hiddenBankCard;
///将某个范围内的字符串变为不可见
-(NSString *)replaceStringWithStartLocation:(NSInteger)startLocation lenght:(NSInteger)lenght;
@end
