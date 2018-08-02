//
//  HSJHomeVCViewModel.h
//  hoommy
//
//  Created by HXB-C on 2018/7/23.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"
#import "HSJHomeModel.h"

@class HSJGlobalInfoModel;

@interface HSJHomeVCViewModel : HSJBaseViewModel

@property (nonatomic, strong) HSJHomeModel *homeModel;

@property (nonatomic, strong) HXBUserInfoModel *userInfoModel;

- (void)getHomeDataWithResultBlock:(NetWorkResponseBlock)resultBlock showHug:(BOOL)isShowHug;

//风险测评
- (void)riskTypeAssementFrom:(UIViewController *)controller;
@end
