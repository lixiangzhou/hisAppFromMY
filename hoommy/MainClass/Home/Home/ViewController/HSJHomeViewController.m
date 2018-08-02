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

- (void)viewDidLoad {
    self.isFullScreenShow = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
}

- (void)reLoadWhenViewAppear {
    BOOL isShowHug = self.viewModel.homeModel? NO : YES;
    [self getHomeData:isShowHug];
    [self loadUserInfo:NO];
    
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
    [self setUpScrollFreshBlock:self.mainTabelView];
}

- (void)getHomeData:(BOOL)isShowHug  {
    kWeakSelf
    [self.viewModel getHomeDataWithResultBlock:^(id responseData, NSError *erro) {
        [weakSelf.mainTabelView endRefresh:YES];
        if(!erro) {
            [weakSelf updateHeadView];
            [weakSelf reloadPage];
        }
        
    } showHug:isShowHug];
    
    [self.viewModel getGlobal:^(HSJGlobalInfoModel *infoModel) {
        weakSelf.footerView.infoModel = infoModel;
    }];
}

- (void)loadUserInfo:(BOOL)isShowHug {
    self.viewModel.userInfoModel = nil;
    if(KeyChain.isLogin) {
        kWeakSelf
        [self.viewModel downLoadUserInfo:isShowHug resultBlock:^(HXBUserInfoModel *userInfoModel, NSError *erro) {
            if(!erro) {
                weakSelf.viewModel.userInfoModel = userInfoModel;
                if(weakSelf.planIdOfWaitJoin) {
                    [weakSelf joinAction:weakSelf.planIdOfWaitJoin];
                }
            }
            weakSelf.planIdOfWaitJoin = nil;
        }];
    }
    else {
        IDPLogDebug(@"没有登录, 不能获取用户信息");
    }
}

- (void)updateHeadView {
    self.headerView.homeModel = self.viewModel.homeModel;
    CGFloat height = self.headerView.height;
    if (self.viewModel.homeModel.articleList.count) {
        height = kScrAdaptationH750(400);
    }  else if (!self.viewModel.homeModel.articleList.count){
        height = kScrAdaptationH750(310);
    }
    
    if(height != self.headerView.height) {
        self.headerView.height = height;
        self.mainTabelView.tableHeaderView = self.headerView;
    }
}

- (void)joinAction:(NSString*)planId{
    HXBUserInfoModel *userInfoModel = self.viewModel.userInfoModel;
    if(userInfoModel) {
        if (userInfoModel.userInfo.isCreateEscrowAcc == NO) {
            [HSJDepositoryOpenTipView show];
        } else if ([userInfoModel.userInfo.riskType isEqualToString:@"立即评测"]) {
            [self.viewModel riskTypeAssementFrom:self];
        } else {
            HSJBuyViewController *vc = [HSJBuyViewController new];
            vc.planId = planId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.homeModel.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSJHomePlanTableViewCell *cell = (HSJHomePlanTableViewCell*)[self.viewModel tableView:tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[HSJHomePlanTableViewCell class]] && !cell.intoButtonAct) {
        kWeakSelf;
        cell.intoButtonAct = ^(NSString *planId) {
            if(weakSelf.viewModel.userInfoModel) {
                [weakSelf joinAction:planId];
            }
            else {
                weakSelf.planIdOfWaitJoin = planId;
                [weakSelf loadUserInfo:YES];
            }
        };
    }
    return cell;
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
            [HXBBaseWKWebViewController pushWithPageUrl:[NSString stringWithFormat:@"%@/baby/intro?section=3",KeyChain.h5host] fromController:weakSelf];
        };
        _footerView.creditClickBlock = ^{
            [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_HomeCreditClick];
            [HXBBaseWKWebViewController pushWithPageUrl:[NSString stringWithFormat:@"%@/baby/intro?section=2",KeyChain.h5host] fromController:weakSelf];
        };
        _footerView.registeredCapitalClickBlock = ^{
            [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_HomeRegisteredCapitalClick];
            [HXBBaseWKWebViewController pushWithPageUrl:[NSString stringWithFormat:@"%@/baby/intro?section=1",KeyChain.h5host] fromController:weakSelf];
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
        _mainTabelView.estimatedRowHeight = 0;
        _mainTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTabelView.freshOption = ScrollViewFreshOptionDownPull;
    }
    return _mainTabelView;
}

- (void)reloadPage {
    BOOL isFresh = NO;
    if(KeyChain.isLogin != self.viewModel.recordIsLogin) {
        isFresh = YES;
    }
    else if(!self.viewModel.recordHomeModel) {
        isFresh = YES;
    }
    else if(!self.viewModel.homeModel) {
        isFresh = YES;
    }
    else {
        NSDictionary *tempDic1 = [self.viewModel.homeModel toDictionary];
        NSDictionary *tempDic2 = [self.viewModel.recordHomeModel toDictionary];
        NSArray *tempList1 = [tempDic1 arrayAtPath:@"dataList"];
        NSArray *tempList2 = [tempDic2 arrayAtPath:@"dataList"];
        if(tempList1.count != tempList2.count) {
            isFresh = YES;
        }
        else {
            for (int i=0; i<tempList1.count; i++) {
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:[tempList1 safeObjectAtIndex:i]];
                [dic1 removeObjectForKey:@"diffTime"];
                NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithDictionary:[tempList2 safeObjectAtIndex:i]];
                [dic2 removeObjectForKey:@"diffTime"];
                if(![dic1 isEqualToDictionary:dic2]) {
                    isFresh = YES;
                    break;
                }
            }
        }
    }
    
    if(isFresh) {
        self.viewModel.recordIsLogin = KeyChain.isLogin;
        self.viewModel.recordHomeModel = self.viewModel.homeModel;
        self.mainTabelView.contentSize = CGSizeMake(kScreenWidth, 1000);
        [self.mainTabelView reloadData];
    }
}

- (void)headerRefreshAction:(UIScrollView *)scrollView {
    [self getHomeData:NO];
}

- (HSJHomeVCViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HSJHomeVCViewModel alloc] init];
        kWeakSelf
        _viewModel.updateCellHeight = ^() {
            [weakSelf reloadPage];
        };
    }
    return _viewModel;
}

@end
