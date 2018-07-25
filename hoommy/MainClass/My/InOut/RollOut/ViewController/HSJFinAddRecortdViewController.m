//
//  HSJFinAddRecortdViewController.m
//  hoommy
//
//  Created by hxb on 2018/7/25.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJFinAddRecortdViewController.h"
#import "HSJFinAddRecortdViewModel.h"
#import "HSJFinAddRecortdCell.h"
#import "HSJFinAddRecortdModel.h"
#import "HXBBaseWKWebViewController.h"
#import "UIScrollView+HXBScrollView.h"
#import "HXBMiddlekey.h"

@interface HSJFinAddRecortdViewController ()

@property (nonatomic,strong)HSJFinAddRecortdViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HXBNoDataView *nodataView;

@end

@implementation HSJFinAddRecortdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投标记录";
    
    self.viewModel = [HSJFinAddRecortdViewModel new];
    [self setUI];
    
    [self getData];
}

#pragma mark - UI
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGB(244, 243, 248);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = kScrAdaptationH750(148);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HSJFinAddRecortdCell class] forCellReuseIdentifier:HSJFinAddRecortdCellIdentifier];
        [HXBMiddlekey AdaptationiOS11WithTableView:_tableView];
        _tableView.freshOption = ScrollViewFreshOptionAll;
        kWeakSelf
        _tableView.headerWithRefreshBlock = ^(UIScrollView *scrollView) {
            [weakSelf getFinAddRecortdData:YES];
        };
    }
    return _tableView;
}


- (void)setUI {
    
    [self.safeAreaView addSubview:self.tableView];
    kWeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.safeAreaView);
    }];
}

#pragma mark - Network
- (void)getData {
    
    [self getFinAddRecortdData:YES];
}

- (void)getFinAddRecortdData:(BOOL)isNew{
    kWeakSelf
    [self.viewModel getFinAddRecortd:isNew planID:self.planId resultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            if (!weakSelf.viewModel.dataSource.count) {
                weakSelf.nodataView.hidden = NO;
            } else
            {
                weakSelf.nodataView.hidden = YES;
            }
            weakSelf.tableView.hidden = NO;
            [weakSelf.tableView reloadData];
            
            if (weakSelf.viewModel.dataSource.count < weakSelf.viewModel.totalCount) {
                weakSelf.tableView.footerWithRefreshBlock = ^(UIScrollView *scrollView) {
                    [weakSelf getFinAddRecortdData:NO];
                };
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView.mj_header endRefreshing];
        }
        else {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - Delegate Internal


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section  {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSJFinAddRecortdCell *cell = [tableView dequeueReusableCellWithIdentifier:HSJFinAddRecortdCellIdentifier forIndexPath:indexPath];
    HSJFinAddRecortdModel *model = self.viewModel.dataSource[indexPath.section];
    cell.model = model;
    kWeakSelf
    cell.statusActionBlock = ^(HSJFinAddRecortdModel *model) {
        NSString *url = kHXB_Negotiate_ServePlan_AccountURL(weakSelf.planId);
        [HXBBaseWKWebViewController pushWithPageUrl:[NSString splicingH5hostWithURL:url] fromController:weakSelf];
    };

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kScrAdaptationH750(20);
}

#pragma mark - Action

#pragma mark - Setter / Getter / Lazy
- (HXBNoDataView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[HXBNoDataView alloc]initWithFrame:CGRectZero];
        _nodataView.imageName = @"Fin_NotData";
        _nodataView.noDataMassage = @"暂无数据";
        //        _nodataView.downPULLMassage = @"下拉进行刷新";
        kWeakSelf
        [self.tableView addSubview:_nodataView];
        [_nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.tableView).offset(kScrAdaptationH(100));
            make.height.width.equalTo(@(kScrAdaptationH(184)));
            make.centerX.equalTo(weakSelf.tableView);
        }];
    }
    return _nodataView;
}

@end
