//
//  HXBWithdrawRecordModel.m
//  hoomxb
//
//  Created by HXB-C on 2017/10/10.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBWithdrawRecordModel.h"

@implementation HXBWithdrawRecordModel

- (UIColor *)stateColor {
    
    if ([self.cashDrawStatus isEqualToString:@"CASHDRAW_SUCCESS"]) {
        _stateColor = RGB(212, 173, 114);
    } else if ([self.cashDrawStatus isEqualToString:@"CASHDRAW_FAIL"]) {
        _stateColor = RGB(254, 126, 94);
    } else {
        _stateColor = RGB(72, 140, 255);
    }
    
    return _stateColor;
}


- (NSString *)bankLastNum {
    _bankLastNum = [NSString stringWithFormat:@"（尾号%@）",[self.bankNum substringFromIndex:self.bankNum.length - 4]];
    return _bankLastNum;
}

- (NSString *)applyTimeStr {
    _applyTimeStr = [[HXBBaseHandDate sharedHandleDate] millisecond_StringFromDate:self.applyTime andDateFormat:@"yyyy-MM-dd HH:mm"];
    return _applyTimeStr;
}
- (NSString *)cashAmount {
    _cashAmount = [NSString stringWithFormat:@"%.2lf",_cashAmount.doubleValue];
    return _cashAmount;
}

@end
