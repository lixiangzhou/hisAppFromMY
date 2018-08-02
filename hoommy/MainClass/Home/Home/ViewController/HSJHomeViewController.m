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
#import "HXBAdvertiseManager.h"
#import "HXBVersionUpdateManager.h"
#import "HSJBuyViewController.h"
#import "HXBHomePopViewManager.h"
#import "HSJDepositoryOpenTipView.h"

@interface HSJHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) HSJHomeCustomNavbarView *navView;

@property (nonatomic, strong) HSJHomeHeaderView *headerView;

@property (nonatomic, strong) UITableView *mainTabelView;

@property (nonatomic, strong) HSJHomeFooterView *footerView;

@property (nonatomic, strong) HSJHomeVCViewModel *viewModel;

//等待加入的计划id
@property (nonatomic, copy) NSString *planIdOfWaitJoin;

@end

@implementation HSJHomeViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    self.isFullScreenShow = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];

}

- (void)reLoadWhenViewAppear {
    BOOL isShowHug = self.viewModel.homeModel? NO : YES;
    [self getHomeData:isShowHug];
    [self.footerView updateData];
    
    if ([HXBAdvertiseManager shared].couldPopAtHomeAfterSlashOrGesturePwd) {
        [[HXBVersionUpdateManager sharedInstance] show];
        [[HXBHomePopViewManager sharedInstance] popHomeViewfromController:self];//展示首页弹窗
    }
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

#pragma mark - Network
- (void)getHomeData:(BOOL)isShowHug  {
    kWeakSelf
    [self.viewModel getHomeDataWithResultBlock:^(id responseData, NSError *erro) {
        [weakSelf.mainTabelView endRefresh:YES];
        if(!erro) {
            weakSelf.headerView.homeModel = weakSelf.viewModel.homeModel;
            [weakSelf updateHeaderView];
            [weakSelf.mainTabelView reloadData];
        }
        
    } showHug:isShowHug];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.homeModel.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSJHomePlanModel * cellmodel = self.viewModel.homeModel.dataList[indexPath.row];
    if ([cellmodel.viewItemType  isEqual: @"product"]) {
        HSJHomePlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HSJHomePlanCellIdentifier];
        cell.planModel = cellmodel;
        kWeakSelf
        cell.intoButtonAct = ^(NSString *planId) {
            [weakSelf.viewModel checkDepositoryAndRiskFromController:weakSelf finishBlock:^{
                HSJBuyViewController *vc = [HSJBuyViewController new];
                vc.planId = planId;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
        };
        return cell;
    } else if ([cellmodel.viewItemType  isEqual: @"signuph5"] && !KeyChain.isLogin) {
        HSJHomeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:HSJHomeActivityCellIdentifier];
        cell.planModel = cellmodel;
        return cell;
    } else if ([cellmodel.viewItemType  isEqual: @"h5"]) {
        HSJHomeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:HSJHomeActivityCellIdentifier];
        cell.planModel = cellmodel;
        return cell;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.homeModel.dataList[indexPath.row].cellHeight;
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
    } else if ([cellmodel.viewItemType isEqual: @"signuph5"] || [cellmodel.viewItemType isEqual: @"h5"]) {
        BannerModel *bannerModel = [[BannerModel alloc] init];
        bannerModel.type = cellmodel.type;
        bannerModel.link = cellmodel.link;
        [HXBExtensionMethodTool pushToViewControllerWithModel:bannerModel andWithFromVC:self];
    }
}

#pragma mark - Helper
- (void)updateHeaderView {
    if (self.viewModel.homeModel.articleList.count) {
        self.headerView.height = kScrAdaptationH750(400);
    }  else if (!self.viewModel.homeModel.articleList.count){
        self.headerView.height = kScrAdaptationH750(310);
    }
    self.mainTabelView.tableHeaderView = self.headerView;
}

#pragma mark - Lazy
- (HSJHomeCustomNavbarView *)navView {
    if (!_navView) {
        _navView = [[HSJHomeCustomNavbarView alloc] init];
        _navView.title = @"红小宝";
        _navView.titleColor = kHXBColor_333333_100;
        _navView.titleFount = [UIFont boldSystemFontOfSize:20];
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
            [weakSelf getHomeData:NO];
        };
    }
    return _mainTabelView;
}

- (HSJHomeVCViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HSJHomeVCViewModel alloc] init];
    }
    return _viewModel;
}

@end
