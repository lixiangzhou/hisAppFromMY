//
//  HSJFinAddRecortdModel.m
//  hoommy
//
//  Created by hxb on 2018/7/25.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJFinAddRecortdModel.h"

@implementation HSJFinAddRecortdModel


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

/**
 状态
 */
/*
- (NSString *) status {
    if (!_status) {
        ///String    投标中
        NSString *str = self.status;
        if ( [str isEqualToString:@"OPEN"]){
            _status = @"立即投标";
        }
        ///    String    已满标
        if ([str isEqualToString:@"READY"]){
            _status = @"已满标";
            
        }
        ///    String    已流标
        if ([str isEqualToString:@"FAILED"]){
            _status = @"立即投标";
            
        }
        ///    String    收益中
        if ([str isEqualToString:@"IN_PROGRESS"]){
            _status = @"收益中";
        }
        ///    String    逾期
        if ([str isEqualToString:@"OVER_DUE"]){
            _status = @"逾期";
            
            
        }
        ///    String    坏账
        if ([str isEqualToString:@"BAD_DEBT"]){
            _status = @"坏账";
        }
        
        ///    String    已结清
        if ([str isEqualToString:@"CLOSED"]){
            _status = @"已结清";
        }
        
        ///    String    新申请
        if ([str isEqualToString:@"FIRST_APPLY"]){
            _status = @"立即投标";
        }
        
        ///    String    已满标
        if ([str isEqualToString:@"FIRST_READY"]){
            _status = @"已满标";
        }
        
        ///    String    预售
        if ([str isEqualToString:@"PRE_SALES"]){
            _status = @"立即投标";
        }
        
        ///    String    等待招标
        if ([str isEqualToString:@"WAIT_OPEN"]){
            _status = @"立即投标";
        }
        
        ///    String    放款中
        if ([str isEqualToString:@"FANGBIAO_PROCESSING"]){
            _status = @"立即投标";
        }
        
        ///    String    流标中
        if ([str isEqualToString:@"LIUBIAO_PROCESSING"]){
            _status = @"立即投标";
        }
    }
    return _status;
}
*/
@end
