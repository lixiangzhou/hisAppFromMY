//
//  HXBconfirmBuyReslut.h
//  hoomxb
//
//  Created by HXB on 2017/6/16.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXBFinModel_BuyResoult_PlanModel : Jastor
@property (nonatomic,copy) NSString *orderNo;
///计息开始时间
@property (nonatomic,copy) NSString *lockStart;
/** 是否开启活动 */
@property (nonatomic, assign) BOOL isInviteActivityShow;
/** 邀请活动的文案 */
@property (nonatomic, copy) NSString *inviteActivityDesc;
@end
