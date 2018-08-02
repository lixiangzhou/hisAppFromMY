//
//  HXBMyRequestAccountModel.h
//  hoomxb
//
//  Created by hxb on 2017/10/30.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyRequestOperateModel;
@interface HXBMyRequestAccountModel : NSObject

@property (nonatomic,assign) double assetsTotal;//总资产
@property (nonatomic,assign) double earnTotal;//累计收益
@property (nonatomic,assign) double financePlanAssets;//红利计划-持有资产
@property (nonatomic,assign) double financePlanSumPlanInterest;//红利计划-累计收益
@property (nonatomic,assign) double lenderPrincipal;//散标债权-持有资产
@property (nonatomic,assign) double lenderEarned;//散标债权-累计收益
@property (nonatomic,assign) double availablePoint;//可用余额
@property (nonatomic,assign) double yesterdayInterest; ///昨日收益
@property (nonatomic,assign) long long availableCouponCount;//可用优惠券数量
/// 持有总资产
@property (nonatomic, strong) NSNumber *holdingTotalAssets;
/// 是否展示邀请好友入口
@property (nonatomic, assign) BOOL isDisplayInvite;

@property (nonatomic, strong) NSArray <MyRequestOperateModel *> *operateList;

@end

@interface MyRequestOperateModel : NSObject
@property (nonatomic, copy) NSString *title;/// 标题
@property (nonatomic, copy) NSString *image;/// 图片地址
@property (nonatomic, copy) NSString *link;/// 链接地址
@property (nonatomic, copy) NSString *type;/// `h5  native`
@end
