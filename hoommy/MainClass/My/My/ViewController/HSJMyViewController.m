//
//  HSJMyViewController.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/13.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJMyViewController.h"
#import "HSJBaseModel.h"

//#import "HXBBindPhoneViewController.h"

#import "HSJRiskAssessmentViewController.h"
#import "HSJSignInViewController.h"
#import "HXBBaseNavigationController.h"
#import "HxbAccountInfoViewController.h"
#import "HXBGeneralAlertVC.h"
#import "HxbMyBankCardViewController.h"
#import "HxbWithdrawCardViewController.h"

#import "HSJMyViewVCViewModel.h"
#import "HXBBindPhoneViewController.h"
#import "HSJRiskAssessmentViewController.h"
#import "HSJDepositoryOpenController.h"


//==================
#import "HxbMyView.h"
#import "HXBMY_AllFinanceViewController.h"
#import "HXBMY_CapitalRecordViewController.h"
#import "HSJDepositoryOpenController.h"


#import "HSJBuyViewController.h"

@interface HSJMyViewController ()<MyViewDelegate>
@property (nonatomic, strong) HxbMyView *myView;
@property (nonatomic, strong) HSJMyViewVCViewModel *viewModel;
@end

@implementation HSJMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFullScreenShow = YES;

    self.viewModel = [[HSJMyViewVCViewModel alloc] init];
    [self setupSubView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self transparentNavigationTitle];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    //加载用户数据
    if ([KeyChain isLogin]) {
        [self loadData_userInfo];
//        [self loadData_accountInfo];//账户内数据总览
    }
//    else {
//        self.myView.accountModel = nil;
//        [self transparentNavigationTitle];
//    }
}
#pragma mark - UI
- (void)setupSubView {
    [self setupMyView];
    [self clickAllFinanceButton];
}

- (void)setupMyView{
    kWeakSelf
    self.myView = [[HxbMyView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.myView.delegate = self;
    self.myView.userInteractionEnabled = YES;
//    self.myView.backgroundColor = kHXBColor_BackGround;
    self.myView.homeRefreshHeaderBlock = ^(){ //下拉加载回调的Block
        [weakSelf loadData_userInfo];
//        [weakSelf loadData_accountInfo];//账户内数据总览
    };
    
    [self.view addSubview:self.myView];
}

/// 查看总资产或开户
- (void)clickAllFinanceButton {
    kWeakSelf
    [self.myView clickAllFinanceButtonWithBlock:^(UILabel * _Nullable button) {
        //跳转资产目录
        if (KeyChain.isLogin) {
            if (!weakSelf.viewModel.userInfoModel.userInfo.isCreateEscrowAcc) { //未开户
                HSJDepositoryOpenController *openVC = [[HSJDepositoryOpenController alloc] init];
                openVC.title = @"开通存管账户";
                [self.navigationController pushViewController:openVC animated:YES];
            } else { //已开户去账户资产页
                HXBMY_AllFinanceViewController *allFinanceViewController = [[HXBMY_AllFinanceViewController alloc]init];
                [weakSelf.navigationController pushViewController:allFinanceViewController animated:YES];
            }
        }
    }];
}

#pragma mark - Setter Getter


#pragma mark - MyViewDelegate
- (void)didLeftHeadBtnClick:(UIButton *)sender{
    HxbAccountInfoViewController *accountInfoVC = [[HxbAccountInfoViewController alloc]init];
    accountInfoVC.userInfoModel = self.viewModel.userInfoModel;
    accountInfoVC.isDisplayAdvisor = self.viewModel.userInfoModel.userInfo.isDisplayAdvisor;
    [self.navigationController pushViewController:accountInfoVC animated:YES];
}
/// 充值
- (void)didClickTopUpBtn:(UIButton *)sender{
//    [HXBUmengManagar HXB_clickEventWithEnevtId:kHXBUmeng_topup_money];
    [self logicalJudgment:HXBRechargeAndWithdrawalsLogicalJudgment_Recharge];
}
/// 提现
- (void)didClickWithdrawBtn:(UIButton *)sender{
//    [HXBUmengManagar HXB_clickEventWithEnevtId:kHXBUmeng_withdraw_money];
    [self logicalJudgment:HXBRechargeAndWithdrawalsLogicalJudgment_Withdrawals];
}
/// 交易记录
-(void)didClickCapitalRecordBtn:(UIButton *)sender {
    HXBMY_CapitalRecordViewController *capitalRecordViewController = [[HXBMY_CapitalRecordViewController alloc]init];
    [self.navigationController pushViewController:capitalRecordViewController animated:YES];
}
/// 红小宝客服
- (void)didClickHelp:(UIButton *)sender {
    [HXBAlertManager callupWithphoneNumber:kServiceMobile andWithTitle:@"红小宝客服电话" Message:kServiceMobile];
}

- (void)entryDepositoryAccount
{
    NSLog(@"开通存管账户");
    HSJDepositoryOpenController *VC = [HSJDepositoryOpenController new];
    [self.navigationController pushViewController:VC animated:YES];
}

/// 我的信息
- (void)didMyHomeInfoClick:(NSInteger)type state:(BOOL)state {
    if (type == 0) { //银行卡
        if(!self.myView.userInfoModel.userInfo.isCreateEscrowAcc) {
            [self entryDepositoryAccount];
        }
        else{
            if (1 == self.myView.userInfoModel.userInfo.hasBindCard.intValue) { //已绑卡
                //进入银行卡页面
                HxbMyBankCardViewController *vc = [[HxbMyBankCardViewController alloc] init];
                vc.isBank = YES;
                vc.isCashPasswordPassed = @"1";
                [self.navigationController pushViewController:vc animated:YES];
                NSLog(@"进入银行卡页面");
            } else {
                //未绑卡
                NSLog(@"进入绑卡页面");
                HxbWithdrawCardViewController *withdrawCardViewController = [[HxbWithdrawCardViewController alloc]init];
                withdrawCardViewController.type = HXBRechargeAndWithdrawalsLogicalJudgment_Other;
                withdrawCardViewController.userInfoModel = self.viewModel.userInfoModel;
                [self.navigationController pushViewController:withdrawCardViewController animated:YES];
            }
        }
    }
    if (type == 1) { //风险测评
        HSJBuyViewController *vc = [[HSJBuyViewController alloc] init];
        vc.startMoney = @"100";
        [self.navigationController pushViewController:vc animated:YES];
        return;
        HSJRiskAssessmentViewController *riskAssessmentVC = [[HSJRiskAssessmentViewController alloc] init];
        [self.navigationController pushViewController:riskAssessmentVC animated:YES];
    }
}

#pragma mark - Helper
/**
 逻辑判断
 */
- (void)logicalJudgment:(HXBRechargeAndWithdrawalsLogicalJudgment)type
{
    kWeakSelf
    [self.viewModel downLoadUserInfo:YES resultBlock:^(id responseData, NSError *erro) {
        if (!erro) {
            weakSelf.myView.userInfoModel = responseData;
            weakSelf.viewModel.userInfoModel = responseData;
//            HXBRequestUserInfoViewModel *userInfoViewModel = weakSelf.viewModel.userInfoModel;
            if (weakSelf.viewModel.userInfoModel.userInfo.isUnbundling) {
                [HXBAlertManager callupWithphoneNumber:kServiceMobile andWithTitle:@"温馨提示" Message:[NSString stringWithFormat:@"您的身份信息不完善，请联系客服 %@", kServiceMobile]];
                return;
            }
            if (!weakSelf.viewModel.userInfoModel.userInfo.isCreateEscrowAcc) {
                
                //                HXBDepositoryAlertViewController *alertVC = [[HXBDepositoryAlertViewController alloc] init];
                //                alertVC.immediateOpenBlock = ^{
                //                    [HXBUmengManagar HXB_clickEventWithEnevtId:kHXBUmeng_alertBtn];
                //                    HXBOpenDepositAccountViewController *openDepositAccountVC = [[HXBOpenDepositAccountViewController alloc] init];
                //                    //                openDepositAccountVC.userModel = viewModel;
                //                    openDepositAccountVC.title = @"开通存管账户";
                //                    openDepositAccountVC.type = type;
                //                    [weakSelf.navigationController pushViewController:openDepositAccountVC animated:YES];
                //                };
                //                [weakSelf presentViewController:alertVC animated:NO completion:nil];
                
                
            } else if ([weakSelf.viewModel.userInfoModel.userInfo.isCashPasswordPassed isEqualToString:@"1"] && [weakSelf.viewModel.userInfoModel.userInfo.hasBindCard isEqualToString:@"0"])
            {
                //进入绑卡界面
                //                HxbWithdrawCardViewController *withdrawCardViewController = [[HxbWithdrawCardViewController alloc]init];
                //                withdrawCardViewController.title = @"绑卡";
                //                withdrawCardViewController.type = type;
                //                withdrawCardViewController.userInfoModel = userInfoViewModel.userInfoModel;
                //                [weakSelf.navigationController pushViewController:withdrawCardViewController animated:YES];
            } else if (!([weakSelf.viewModel.userInfoModel.userInfo.isCashPasswordPassed isEqualToString:@"1"] && [weakSelf.viewModel.userInfoModel.userInfo.hasBindCard isEqualToString:@"1"]))
            {
                //完善信息
                //                HXBOpenDepositAccountViewController *openDepositAccountVC = [[HXBOpenDepositAccountViewController alloc] init];
                //                openDepositAccountVC.title = @"完善信息";
                //                openDepositAccountVC.type = type;
                //                [weakSelf.navigationController pushViewController:openDepositAccountVC animated:YES];
            } else
            {
                //                if (type == HXBRechargeAndWithdrawalsLogicalJudgment_Recharge) {
                //                    HxbMyTopUpViewController *hxbMyTopUpViewController = [[HxbMyTopUpViewController alloc]init];
                //                    [weakSelf.navigationController pushViewController:hxbMyTopUpViewController animated:YES];
                //                } else if (type == HXBRechargeAndWithdrawalsLogicalJudgment_Withdrawals){
                //                    if (!KeyChain.isLogin)  return;
                //                    HxbWithdrawViewController *withdrawViewController = [[HxbWithdrawViewController alloc]init];
                //                    [weakSelf.navigationController pushViewController:withdrawViewController animated:YES];
                //                }
            }
        }
    }];
}

#pragma mark - Network
//- (void)loadData_accountInfo{
//    kWeakSelf
//    [self.viewModel downLoadAccountInfo:^(BOOL isSuccess) {
//        if (isSuccess) {
//            weakSelf.myView.accountModel = weakSelf.viewModel.accountModel;
//        }
//        weakSelf.myView.isStopRefresh_Home = YES;
//    }];
//}
- (void)loadData_userInfo {
    kWeakSelf
    [self.viewModel downLoadUserInfo:NO resultBlock:^(id responseData, NSError *erro) {
        if (!erro) {
            weakSelf.viewModel.userInfoModel = responseData;
            weakSelf.myView.userInfoModel = responseData;
        }
        weakSelf.myView.isStopRefresh_Home = YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
