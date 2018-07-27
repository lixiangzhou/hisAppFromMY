//
//  HXBNoticeViewController.m
//  hoomxb
//
//  Created by HXB-C on 2017/7/13.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//



#import "HXBNoticeViewController.h"
#import "HXBNoticeVCViewModel.h"
#import "HXBNoticModel.h"
#import "HXBNoticeCell.h"
#import "HXBBaseWKWebViewController.h"
#import "HXBMiddlekey.h"
#import "UIScrollView+HXBScrollView.h"
@interface HXBNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTabelView;
/**
 请求
 */
@property (nonatomic, strong) HXBNoticeVCViewModel *noticeViewModel;

@end

@implementation HXBNoticeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红小宝公告";
    self.isWhiteColourGradientNavigationBar = YES;
    [self.view addSubview:self.mainTabelView];
    [self loadDataWithIsUPReloadData:NO];
}
/**
 再次获取网络数据
 */
- (void)getNetworkAgain
{
     [self loadDataWithIsUPReloadData:YES];
}


- (void)loadDataWithIsUPReloadData:(BOOL)isUPReloadData
{
    kWeakSelf
    //公告请求接口
    [self.noticeViewModel noticeRequestWithisUPReloadData:isUPReloadData andCallbackBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.isShowNodataView = !weakSelf.noticeViewModel.noticModel.dataList.count;

            weakSelf.mainTabelView.hidden = NO;
            [weakSelf.mainTabelView reloadData];
            [weakSelf setTableFooterView:weakSelf.mainTabelView];
            if (weakSelf.noticeViewModel.noticModel.dataList.count < weakSelf.noticeViewModel.noticModel.totalCount) {
                [weakSelf.mainTabelView.mj_footer endRefreshing];
            }
            else {
                [weakSelf.mainTabelView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf.mainTabelView.mj_header endRefreshing];
        }
        else {
            [weakSelf.mainTabelView.mj_header endRefreshing];
            [weakSelf.mainTabelView.mj_footer endRefreshing];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.noticeViewModel.noticModel.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"HXBNoticeViewControllerCell";
    HXBNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HXBNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    HSJNoticeListModel *noticModel = self.noticeViewModel.noticModel.dataList[indexPath.row];
    cell.noticModel = noticModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     HSJNoticeListModel *noticModel = self.noticeViewModel.noticModel.dataList[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%@/notice/%@",[KeyChain h5host],noticModel.ID];
    [HXBBaseWKWebViewController pushWithPageUrl:str fromController:self];
}


#pragma mark - 懒加载
- (UITableView *)mainTabelView
{
     kWeakSelf
    if (!_mainTabelView) {
        _mainTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, HXBStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight - HXBStatusBarAndNavigationBarHeight)];
        _mainTabelView.delegate = self;
        _mainTabelView.dataSource = self;
        _mainTabelView.hidden = YES;
        _mainTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTabelView.rowHeight = kScrAdaptationH750(90);
        _mainTabelView.freshOption = ScrollViewFreshOptionAll;
        _mainTabelView.headerWithRefreshBlock = ^(UIScrollView *scrollView) {
            [weakSelf loadDataWithIsUPReloadData:YES];
        };
        _mainTabelView.footerWithRefreshBlock = ^(UIScrollView *scrollView) {
            [weakSelf loadDataWithIsUPReloadData:NO];
        };
        [HXBMiddlekey AdaptationiOS11WithTableView:_mainTabelView];
    }
//    if (self.noticeViewModel.noticModel.totalCount > kPageCount && (_mainTabelView.mj_footer == nil)) {
//        
//    }
    return _mainTabelView;
}

- (void)setTableFooterView:(UITableView *)tb {
    if (!tb) {
        return;
    }
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [tb setTableFooterView:view];
}


- (HXBNoticeVCViewModel *)noticeViewModel
{
    if (!_noticeViewModel) {
        _noticeViewModel = [[HXBNoticeVCViewModel alloc] init];
    }
    return _noticeViewModel;
}
@end
