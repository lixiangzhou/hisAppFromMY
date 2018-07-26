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

@property (nonatomic, strong) HSJGlobalInfoModel *infoModel;

@property (nonatomic, strong, readonly) NSMutableArray *cellHeightArray;

@property (nonatomic, strong) void(^updateCellHeight)(void);

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)getHomeDataWithResultBlock:(NetWorkResponseBlock)resultBlock;

- (void)getGlobal:(void (^)(HSJGlobalInfoModel *))resultBlock;
@end
