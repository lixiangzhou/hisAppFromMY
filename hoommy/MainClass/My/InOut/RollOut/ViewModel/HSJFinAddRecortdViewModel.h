//
//  HSJFinAddRecortdViewModel.h
//  hoommy
//
//  Created by hxb on 2018/7/25.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"
@class HSJFinAddRecortdModel;

@interface HSJFinAddRecortdViewModel : HSJBaseViewModel
@property (nonatomic, assign) NSUInteger pageNumber;//第几页
@property (nonatomic, assign) NSUInteger pageSize;//每页多少条
@property (nonatomic, assign) NSUInteger totalCount;//总条数
@property (nonatomic,strong) NSMutableArray<HSJFinAddRecortdModel *> *dataSource;


- (void)getFinAddRecortd:(BOOL)isNew planID:(NSString *)planID resultBlock:(void(^)(BOOL isSuccess))resultBlock;

@end
