//
//  HXBWithdrawRecordViewController.m
//  hoomxb
//
//  Created by HXB-C on 2017/10/10.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBWithdrawRecordViewController.h"
#import "HXBWithdrawRecordViewModel.h"
#import "HXBWithdrawRecordListModel.h"
#import "HXBWithdrawRecordCell.h"
#import "HXBMiddlekey.h"

@interface HXBWithdrawRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 提现记录的ViewModel
 */
@property (nonatomic, strong) HXBWithdrawRecordViewModel *withdrawRecordViewModel;
/**
 提现进度列表
 */
@property (nonatomic, strong) UITableView *withdrawRecordTableView;


@end

@implementation HXBWithdrawRecordViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现进度";
    [self loadCashRegisterDataNeeedShowLoading:YES];
    [self.safeAreaView addSubview:self.withdrawRecordTableView];
}
#pragma mark - Events
///无网状态的网络连接
- (void)getNetworkAgain {
    [self loadCashRegisterDataNeeedShowLoading:YES];
}
#pragma mark - Private
//加载数据
- (void)loadCashRegisterDataNeeedShowLoading:(BOOL)isShowLoading {
    kWeakSelf
    [self.withdrawRecordViewModel withdrawRecordProgressRequestWithLoading:isShowLoading resultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf isHaveData];
            [weakSelf.withdrawRecordTableView reloadData];
            
            if (weakSelf.withdrawRecordViewModel.withdrawRecordListModel.isNoMoreData) {
                [self.withdrawRecordTableView.mj_header endRefreshing];
                [weakSelf.withdrawRecordTableView.mj_footer endRefreshingWithNoMoreData];
                if (weakSelf.withdrawRecordViewModel.withdrawRecordListModel.dataList.count <= kPageCount) {
                    weakSelf.withdrawRecordTableView.mj_footer = nil;
                }
            } else {
                [weakSelf endRefreshing];
                weakSelf.withdrawRecordTableView.freshOption = ScrollViewFreshOptionAll;
            }
        } else {
            [weakSelf.withdrawRecordTableView reloadData];
            [weakSelf endRefreshing];
        }
    }];
}
//结束刷新
- (void)endRefreshing {
    [self.withdrawRecordTableView.mj_header endRefreshing];
    [self.withdrawRecordTableView.mj_footer endRefreshing];
}
//判断是否有数据
- (void)isHaveData {
    self.isShowNodataView = self.withdrawRecordViewModel.withdrawRecordListModel.dataList.count<=0;
}

#pragma mark - UITableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *identifier = @"HXBNoticeViewControllerCell";
    HXBWithdrawRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HXBWithdrawRecordCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    NSString *key = self.withdrawRecordViewModel.formatWithdrawRecordDataKeyList[indexPath.section];
    NSArray *keyValueArray = self.withdrawRecordViewModel.formatWithdrawRecordDataValueList[key];
    cell.withdrawRecordModel = keyValueArray[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.withdrawRecordViewModel.withdrawRecordListModel.dataList.count;
    NSString *key = self.withdrawRecordViewModel.formatWithdrawRecordDataKeyList[section];
    NSArray *keyValueArray = self.withdrawRecordViewModel.formatWithdrawRecordDataValueList[key];
    return keyValueArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.withdrawRecordViewModel.formatWithdrawRecordDataKeyList.count;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScrAdaptationH(87);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kScrAdaptationH(40);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = BACKGROUNDCOLOR;
    UILabel *lab = [[UILabel alloc]initWithFrame: CGRectMake(kScrAdaptationW(15), kScrAdaptationH(10), kScrAdaptationW(80), kScrAdaptationH(20))];
    lab.textColor = kHXBColor_333333_100;
    lab.font = kHXBFont_PINGFANGSC_REGULAR(14);
    lab.text = self.withdrawRecordViewModel.formatWithdrawRecordDataKeyList[section];;
    [headView addSubview:lab];
    
    return headView;
}

- (void)headerRefreshAction:(UIScrollView *)scrollView {
    self.withdrawRecordViewModel.withdrawRecordPage = 1;
    [self loadCashRegisterDataNeeedShowLoading:NO];
}

- (void)footerRefreshAction:(UIScrollView *)scrollView {
    self.withdrawRecordViewModel.withdrawRecordPage++;
    [self loadCashRegisterDataNeeedShowLoading:NO];
}

#pragma mark - Getters and Setters
- (UITableView *)withdrawRecordTableView {
    if (!_withdrawRecordTableView) {
        _withdrawRecordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HXBStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight - HXBStatusBarAndNavigationBarHeight) style:(UITableViewStyleGrouped)];
        [HXBMiddlekey AdaptationiOS11WithTableView:_withdrawRecordTableView];
        _withdrawRecordTableView.backgroundColor = BACKGROUNDCOLOR;
        _withdrawRecordTableView.delegate = self;
        _withdrawRecordTableView.dataSource = self;
        _withdrawRecordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _withdrawRecordTableView.freshOption = ScrollViewFreshOptionDownPull;
        [self setUpScrollFreshBlock:_withdrawRecordTableView];
        
    }
    return _withdrawRecordTableView;
}

- (HXBWithdrawRecordViewModel *)withdrawRecordViewModel {
    if (!_withdrawRecordViewModel) {
        _withdrawRecordViewModel = [[HXBWithdrawRecordViewModel alloc] init];
    }
    return _withdrawRecordViewModel;
}

@end
