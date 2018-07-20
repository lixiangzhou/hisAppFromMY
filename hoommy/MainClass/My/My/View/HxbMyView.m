 //
//  HxbMyView.m
//  hoomxb
//
//  Created by HXB-C on 2017/5/3.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HxbMyView.h"
#import "HxbMyViewHeaderView.h"
#import "AppDelegate.h"
#import "HSJMyViewController.h"
//#import "HXBMyCouponViewController.h"   // 优惠券
//#import "HXBMY_PlanListViewController.h"///plan 列表的VC
//#import "HXBMY_LoanListViewController.h"///散标 列表的VC
#import "HXBMY_CapitalRecordViewController.h"//资产记录
#import "HXBMyHomeViewCell.h"
//#import "HXBMyRequestAccountModel.h"
#import "HXBUserInfoModel.h"
//#import "HXBBannerWebViewController.h"
#import "UIResponder+FindNext.h"
#import "UIScrollView+HXBScrollView.h"
#import "HSJMyHomeInfoTableViewCell.h"


@interface HxbMyView ()
<
UITableViewDelegate,
UITableViewDataSource,
MyViewHeaderDelegate
>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) HxbMyViewHeaderView *headerView;
@property (nonatomic, strong) UIView *bottomView;
//@property (nonatomic, strong) UIButton *signOutButton;
@property (nonatomic, copy) void(^clickAllFinanceButtonWithBlock)(UILabel *button);
@end

@implementation HxbMyView
///点击了 总资产
- (void)clickAllFinanceButtonWithBlock: (void(^)(UILabel * button))clickAllFinanceButtonBlock{
    self.clickAllFinanceButtonWithBlock = clickAllFinanceButtonBlock;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainTableView];
//        [self setConstraints];
    }
    return self;
}
- (void)setConstraints {
    kWeakSelf
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(@kScrAdaptationH750(202));
        make.bottom.mas_equalTo(weakSelf.bottom).offset(-HXBTabbarHeight);
    }];
}

/**
 数据模型的set方法
 */
//- (void)setUserInfoViewModel:(HXBRequestUserInfoViewModel *)userInfoViewModel
//{
//    _userInfoViewModel = userInfoViewModel;
//    self.headerView.userInfoViewModel = userInfoViewModel;
//}

//- (void)setAccountModel:(HXBMyRequestAccountModel *)accountModel{
//    _accountModel = accountModel;
//    self.headerView.accountInfoViewModel = accountModel;
//    [self.mainTableView reloadData];
//}

- (void)setUserInfoModel:(HXBUserInfoModel *)userInfoModel {
//    _accountModel = accountModel;
    _userInfoModel = userInfoModel;
    self.headerView.userInfoModel = userInfoModel;
    [self.mainTableView reloadData];
}

- (void)didClickLeftHeadBtn:(UIButton *)sender{
    [self.delegate didLeftHeadBtnClick:sender];
}
-(void)didClickTopUpBtn:(UIButton *)sender{
    [self.delegate didClickTopUpBtn:sender];
}

- (void)didClickWithdrawBtn:(UIButton *)sender{
    [self.delegate didClickWithdrawBtn:sender];
}
- (void)didClickCapitalRecordBtn:(UIButton *_Nullable)sender {
    [self.delegate didClickCapitalRecordBtn:sender];
}
- (void)didClickHelp:(UIButton *)sender {
    [self.delegate didClickHelp:sender];
}

- (void)setIsStopRefresh_Home:(BOOL)isStopRefresh_Home{
    _isStopRefresh_Home = isStopRefresh_Home;
    if (isStopRefresh_Home) {
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView.mj_header endRefreshing];
    }
}

- (NSArray *)getUserInfoModelArray {
    kWeakSelf
    HSJMyHomeInfoModel *model = [HSJMyHomeInfoModel new];
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:2];
    
    NSString *bankDesc = self.userInfoModel.userBank.cardId.length>4?[self.userInfoModel.userBank.cardId substringFromIndex:self.userInfoModel.userBank.cardId.length-4]:@"--";
    BOOL state = [self.userInfoModel.userInfo.hasBindCard isEqualToString:@"1"]?YES:NO;
    model.desc = state?[NSString stringWithFormat:@"尾号%@",bankDesc]:@"立即绑定";
    model.infoBlock = ^(NSInteger type) {
        [weakSelf.delegate didMyHomeInfoClick:type state:state];
    };
    [mArr addObject:model];
    
    state = !self.userInfoModel.userInfo.riskType||[self.userInfoModel.userInfo.riskType isEqualToString:@"立即评测"]?NO:YES;
    model.desc = state?self.userInfoModel.userInfo.riskType:[NSString stringWithFormat:@"立即评测"];
    model.infoBlock = ^(NSInteger type) {
        [weakSelf.delegate didMyHomeInfoClick:type state:state];
    };
    [mArr addObject:model];
    
    return mArr;
}

#pragma TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSLog(@"恒丰银行账户余额");
        } else {
            NSLog(@"红利计划");
//            [HXBUmengManagar HXB_clickEventWithEnevtId:kHXBUmeng_invite_entrance];
//            HxbMyViewController *VC = (HxbMyViewController *)[UIResponder findNextResponderForClass:[HxbMyViewController class] ByFirstResponder:self];
//            HXBBannerWebViewController *webViewVC = [[HXBBannerWebViewController alloc] init];
//            webViewVC.pageUrl = kHXBH5_InviteDetailURL;
//            [VC.navigationController pushViewController:webViewVC animated:YES];
        }
    }
    if (indexPath.section == 1) {//第一组
        NSLog(@"我的信息");
    }
    if (indexPath.section == 2) {//第二组
        NSLog(@"热门推荐");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 || indexPath.section == 2) {
        return kScrAdaptationH750(260);
    } else {
        return kScrAdaptationH(44.5);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1f;
    }else{
        return kScrAdaptationH750(100);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kScrAdaptationH750(20);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *supV = nil;
    if (section == 1 || section == 2) {
        supV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScrAdaptationH750(100))];
        supV.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(kScrAdaptationW750(30), kScrAdaptationH750(35), kScrAdaptationW750(200), kScrAdaptationH750(48))];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.font = kHXBFont_PINGFANGSC_REGULAR_750(34);
        lab.textColor = RGBA(51, 51, 51, 1);
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, supV.frame.size.height-kHXBDivisionLineHeight, kScreenWidth, kHXBDivisionLineHeight)];
        lineV.backgroundColor = RGBA(244, 243, 248, 1);
        [supV addSubview:lineV];
        [supV addSubview:lab];
        lab.text = section == 1? @"我的信息" : @"热门推荐";
        return supV;
    }else{
        return nil;
    }
}

#pragma TableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *celledStr = @"celled";
    HXBMyHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:celledStr];
    if (cell == nil) {
        cell = [[HXBMyHomeViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:celledStr];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = kHXBFont_PINGFANGSC_REGULAR(15);
        cell.textLabel.textColor = COR6;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"恒丰银行账户余额";
            cell.desc = [NSString hxb_getPerMilWithDouble:[self.userInfoModel.userAssets.assetsTotal doubleValue]];
            cell.isShowLine = YES;
            cell.imageName = @"me_hongli_asset";
        } else {
            cell.textLabel.text = @"红利计划";
            cell.desc = [NSString hxb_getPerMilWithDouble:[self.userInfoModel.userAssets.financePlanAssets doubleValue]];
            cell.isShowLine = NO;
            cell.imageName = @"me_hongli";
        }
    } else if (indexPath.section == 1){
        // 我的信息
        HSJMyHomeInfoTableViewCell *cell = [[HSJMyHomeInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"HSJMyHomeInfoTableViewCell"];
        cell.infoModelArr = [self getUserInfoModelArray];
        
        return cell;
    } else {
        // 热门推荐
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.contentView.layer.cornerRadius = 6;
        cell.contentView.layer.masksToBounds = YES;
        cell.contentView.backgroundColor = kHXBColor_BackGround;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    } else if ( section == 1) {
        return 1;
    } else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableView *)mainTableView{
    if (!_mainTableView) {
        
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 49 - HXBBottomAdditionHeight) style:UITableViewStyleGrouped];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableHeaderView = self.headerView;
        _mainTableView.tableFooterView = self.bottomView;
        _mainTableView.tableHeaderView.userInteractionEnabled = YES;
        _mainTableView.backgroundColor = kHXBColor_BackGround;
        kWeakSelf
        _mainTableView.freshOption = ScrollViewFreshOptionDownPull;
        _mainTableView.headerWithRefreshBlock = ^(UIScrollView *scrollView) {
            if (weakSelf.homeRefreshHeaderBlock) weakSelf.homeRefreshHeaderBlock();
        };
    }
    return _mainTableView;
}

- (HxbMyViewHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[HxbMyViewHeaderView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kScrAdaptationH750(575 + 43) + HXBStatusBarAdditionHeight)];//kScrAdaptationH(276)//575
        _headerView.delegate = self;
        _headerView.userInteractionEnabled = YES;
        kWeakSelf
        [_headerView clickAllFinanceButtonWithBlock:^(UILabel * _Nullable button) {
            if (weakSelf.clickAllFinanceButtonWithBlock) {
                weakSelf.clickAllFinanceButtonWithBlock(button);
            }
        }];
    }
    return _headerView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectZero];
        _bottomView.userInteractionEnabled = YES;
        _bottomView.backgroundColor = [UIColor clearColor];
        UIButton *helpBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_bottomView addSubview:helpBtn];
        [helpBtn setImage:[UIImage imageNamed:@"my_help"] forState:UIControlStateNormal];
        [helpBtn setTitle:@"红小宝客服" forState:UIControlStateNormal];
        [helpBtn addTarget:self action:@selector(didClickHelp:) forControlEvents:UIControlEventTouchUpInside];
        helpBtn.layer.cornerRadius = 5;
        helpBtn.layer.masksToBounds = YES;
        [helpBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
        [helpBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10, 0.0, 0)];
        [helpBtn setTitleColor:RGB(127, 133, 161) forState:UIControlStateNormal];
        helpBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [helpBtn.titleLabel setFont:kHXBFont_PINGFANGSC_REGULAR_750(24)];
        helpBtn.backgroundColor = kHXBColor_FFFFFF_100;
        kWeakSelf
        [helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->_bottomView);
            make.width.equalTo(@kScrAdaptationW750(230));
            make.height.equalTo(@kScrAdaptationH750(70));
            make.bottom.mas_equalTo(weakSelf.bottom).offset(kScrAdaptationH750(-92));
        }];
        
        UILabel * lab = [UILabel new];
        lab.textAlignment = NSTextAlignmentCenter;
        [lab setFont:kHXBFont_PINGFANGSC_REGULAR_750(20)];
        lab.textColor = RGB(127, 133, 161);
        lab.text = @"客服电话时间：工作日9:00-18:00";
        [_bottomView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->_bottomView);
            make.width.equalTo(@kScrAdaptationW750(320));
            make.height.equalTo(@kScrAdaptationH750(28));
            make.bottom.mas_equalTo(weakSelf.bottom).offset(kScrAdaptationH750(-40));
        }];
    }
    return _bottomView;
}

@end
