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

- (void)getHomeDataWithResultBlock:(NetWorkResponseBlock)resultBlock showHug:(BOOL)isShowHug;

- (void)reloadPage:(void (^)(BOOL needReload))resultBlock;
@end
