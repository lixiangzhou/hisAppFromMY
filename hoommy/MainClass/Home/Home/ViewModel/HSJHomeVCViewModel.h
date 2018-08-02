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

//网络数据
@property (nonatomic, strong) HSJHomeModel *homeModel;

@property (nonatomic, strong) HSJGlobalInfoModel *infoModel;

@property (nonatomic, strong) HXBUserInfoModel *userInfoModel;

//逻辑数据
@property (nonatomic, strong) HSJHomeModel *recordHomeModel;

@property (nonatomic, assign) BOOL recordIsLogin;


@property (nonatomic, strong) void(^updateCellHeight)(void);

- (void)getHomeDataWithResultBlock:(NetWorkResponseBlock)resultBlock showHug:(BOOL)isShowHug;
- (void)getGlobal:(void (^)(HSJGlobalInfoModel *))resultBlock;
@end
