//
//  HSJHomeViewController.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/13.
//  Copyright © 2018年 caihongji. All rights reserved.
//



#import "HSJHomeViewController.h"
#import "HSJPlanDetailController.h"
#import "HSJHomeCustomNavbarView.h"
#import "HSJHomeHeaderView.h"
#import "HSJHomePlanTableViewCell.h"
#import "HSJHomeActivityCell.h"
#import "HSJHomeFooterView.h"
#import "HSJHomeVCViewModel.h"
#import "HXBExtensionMethodTool.h"
#import "UIScrollView+HXBScrollView.h"
#import "HXBNoticeViewController.h"
#import "HXBBaseWKWebViewController.h"
@interface HSJHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) HSJHomeCustomNavbarView *navView;

@property (nonatomic, strong) HSJHomeHeaderView *headerView;

@property (nonatomic, strong) UITableView *mainTabelView;

@property (nonatomic, strong) HSJHomeFooterView *footerView;

@property (nonatomic, strong) HSJHomeVCViewModel *viewModel;

@end

@implementation HSJHomeViewController

- (void)viewDidLoad {
    self.isFullScreenShow = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getHomeData];
    [self updateUI];
}

- (void)setUI {
    [self.safeAreaView addSubview:self.navView];
    [self.safeAreaView addSubview:self.mainTabelView];
    [self.mainTabelView registerClass:[HSJHomePlanTableViewCell class] forCellReuseIdentifier:HSJHomePlanCellIdentifier];
    [self.mainTabelView registerClass:[HSJHomeActivityCell class] forCellReuseIdentifier:HSJHomeActivityCellIdentifier];
    [self.mainTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.left.right.bottom.equalTo(self.safeAreaView);
    }];
}

- (void)getHomeData {
    kWeakSelf
    [self.viewModel getHomeDataWithResultBlock:^(id responseData, NSError *erro) {
        weakSelf.headerView.homeModel = weakSelf.viewModel.homeModel;
        [weakSelf updateUI];
        [weakSelf.mainTabelView reloadData];
        [weakSelf.mainTabelView endRefresh:YES];
    }];
    [self.viewModel getGlobal:^(HSJGlobalInfoModel *infoModel) {
        weakSelf.footerView.infoModel = infoModel;
    }];
}

- (void)updateUI {
    if (self.viewModel.homeModel.articleList.count) {
        self.headerView.height = kScrAdaptationH750(400);
    }  else if (!self.viewModel.homeModel.articleList.count){
        self.headerView.height = kScrAdaptationH750(310);
    }
    self.mainTabelView.tableHeaderView = self.headerView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.homeModel.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel.cellHeightArray[indexPath.row] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HSJHomePlanModel * cellmodel = self.viewModel.homeModel.dataList[indexPath.row];
    if ([cellmodel.viewItemType  isEqual: @"product"]) {
        if (KeyChain.isLogin) {
            [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_HomeSignInPlanClick];
        } else {
            [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_HomeSignupPlanClick];
        }
        HSJPlanDetailController* vc = [[HSJPlanDetailController alloc] init];
        vc.planId = self.viewModel.homeModel.dataList[indexPath.row].ID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellmodel.viewItemType  isEqual: @"signuph5"]) {
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_HomeSignupClick];
        BannerModel *bannerModel = [[BannerModel alloc] init];
        bannerModel.type = cellmodel.type;
        bannerModel.link = cellmodel.link;
        [HXBExtensionMethodTool pushToViewControllerWithModel:bannerModel andWithFromVC:self];
    } else if([cellmodel.viewItemType  isEqual: @"h5"]) {
        BannerModel *bannerModel = [[BannerModel alloc] init];
        bannerModel.type = cellmodel.type;
        bannerModel.link = cellmodel.link;
        [HXBExtensionMethodTool pushToViewControllerWithModel:bannerModel andWithFromVC:self];
    }
    
}

- (HSJHomeCustomNavbarView *)navView {
    if (!_navView) {
        _navView = [[HSJHomeCustomNavbarView alloc] init];
        _navView.title = @"红小宝";
        _navView.titleColor = kHXBColor_333333_100;
        _navView.titleFount = kHXBFont_PINGFANGSC_REGULAR_750(40);
        kWeakSelf
        _navView.noticeBlock = ^{
            [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_HomeNoticeClick];
            HXBNoticeViewController *noticeVC = [[HXBNoticeViewController alloc] init];
            [weakSelf.navigationController pushViewController:noticeVC animated:YES];
        };
    }
    return _navView;
}



- (HSJHomeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HSJHomeHeaderView alloc] initWithFrame:CGRectZero];
        kWeakSelf
        _headerView.bannerDidSelectItemAtIndex = ^(NSInteger index) {
            [HXBExtensionMethodTool pushToViewControllerWithModel:weakSelf.viewModel.homeModel.bannerList[index] andWithFromVC:weakSelf];
        };
        _headerView.titleDidSelectItemAtIndex = ^(NSInteger index) {
            [HXBBaseWKWebViewController pushWithPageUrl:weakSelf.viewModel.homeModel.articleList[index].link fromController:weakSelf];
        };
        
    }
    return _headerView;
}

- (HSJHomeFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[HSJHomeFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScrAdaptationH750(630))];
        kWeakSelf
        _footerView.platformAmountClickBlock = ^{
             [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_HomeSafeClick];
            [HXBBaseWKWebViewController pushWithPageUrl:[NSString stringWithFormat:@"%@/baby/data",KeyChain.h5host] fromController:weakSelf];
        };
        _footerView.userAmountClickBlock = ^{
             [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_HomeSafeClick];
            [HXBBaseWKWebViewController pushWithPageUrl:[NSString stringWithFormat:@"%@/baby/data",KeyChain.h5host] fromController:weakSelf];
        };
        _footerView.bankClickBlock = ^{
            [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_HomeBankClick];
            [HXBBaseWKWebViewController pushWithPageUrl:[NSString stringWithFormat:@"%@/baby/intro#section1",KeyChain.h5host] fromController:weakSelf];
        };
        _footerView.creditClickBlock = ^{
            [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_HomeCreditClick];
            [HXBBaseWKWebViewController pushWithPageUrl:[NSString stringWithFormat:@"%@/baby/intro#section2",KeyChain.h5host] fromController:weakSelf];
        };
        _footerView.registeredCapitalClickBlock = ^{
            [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_HomeRegisteredCapitalClick];
            [HXBBaseWKWebViewController pushWithPageUrl:[NSString stringWithFormat:@"%@/baby/intro#section3",KeyChain.h5host] fromController:weakSelf];
        };
    }
    return _footerView;
}



- (UITableView *)mainTabelView {
    if (!_mainTabelView) {
        _mainTabelView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _mainTabelView.backgroundColor = kHXBBackgroundColor;
        _mainTabelView.tableHeaderView = self.headerView;
        _mainTabelView.tableFooterView = self.footerView;
        _mainTabelView.delegate = self;
        _mainTabelView.dataSource = self;
        _mainTabelView.showsVerticalScrollIndicator = NO;
        _mainTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        kWeakSelf
        _mainTabelView.freshOption = ScrollViewFreshOptionDownPull;
        _mainTabelView.headerWithRefreshBlock = ^(UIScrollView *scrollView) {
            [weakSelf getHomeData];
        };
    }
    return _mainTabelView;
}

- (HSJHomeVCViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HSJHomeVCViewModel alloc] init];
        kWeakSelf
        _viewModel.updateCellHeight = ^() {
            [weakSelf.mainTabelView reloadData];
        };
    }
    return _viewModel;
}

@end
