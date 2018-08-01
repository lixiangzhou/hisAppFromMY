//
//  HSJBuyViewController.m
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBuyViewController.h"
#import "HSJBuyFootView.h"
#import "HSJBuyHeadView.h"
#import "HSJBuySectionHeadView.h"
#import "HSJBuyTableViewCell.h"
#import "HSJBuyViewModel.h"
#import "HSJAgreementsViewController.h"
#import "HxbMyBankCardViewController.h"
#import "HxbWithdrawCardViewController.h"
#import "HXBTransactionPasswordView.h"
#import "HXBVerificationCodeAlertVC.h"
#import "HSJPlanBuyResultViewController.h"

@interface HSJBuyViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HSJBuyFootView *footView;
@property (nonatomic, strong) HSJBuyHeadView *headView;
@property (nonatomic, strong) HXBTransactionPasswordView *passwordView;
@property (nonatomic, strong) HXBVerificationCodeAlertVC *alertVC;

@property (nonatomic, strong) HSJBuyViewModel *viewModel;

@end

@implementation HSJBuyViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupUI];
    [self setupConstraints];
}

- (void)leftBackBtnClick {
    [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_BuyIntoClick];
    [super leftBackBtnClick];
}

- (void)setupData {
    self.viewModel = [[HSJBuyViewModel alloc] init];
    kWeakSelf
    self.viewModel.hugViewBlock = ^UIView *{
        if(weakSelf.presentedViewController) {
            return weakSelf.presentedViewController.view;
        }
        return weakSelf.view;
    };
    self.viewModel.inputMoney = self.startMoney;
    
    NSString *planId = self.planId?:@"";
    [self.viewModel getDataWithId:planId showHug:YES resultBlock:^(id responseData, NSError *erro) {
        if(!erro) {
            weakSelf.viewModel.planModel = responseData;
            [weakSelf startSaleTimer];
            [weakSelf resultDeal];
        }
    }];
    [self loadUserInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyCall:) name:kHXBNotification_unBindBankCard object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyCall:) name:kHXBNotification_bindBankCard object:nil];
}

- (void)notifyCall:(NSNotification*)notify {
    NSDictionary *resultDic = notify.userInfo;
    if([notify.name isEqualToString:kHXBNotification_unBindBankCard] || [notify.name isEqualToString:kHXBNotification_bindBankCard]) {
        NSString *result = [resultDic stringAtPath:@"result"];
        if([result isEqualToString:@"YES"]) {
            [self loadUserInfo];
        }
    }
}

- (void)loadUserInfo {
    kWeakSelf
    [self.viewModel downLoadUserInfo:YES resultBlock:^(id responseData, NSError *erro) {
        if(!erro) {
            weakSelf.viewModel.userInfoModel = responseData;
            [weakSelf resultDeal];
        }
    }];
}

- (void)setupUI {
    self.title = @"转入";
    self.isShowSplitLine = YES;
    self.view.backgroundColor = kHXBBackgroundColor;
    
    [self.tableView registerClass:[HSJBuyTableViewCell class] forCellReuseIdentifier:@"HSJBuyTableViewCell"];
    [self.tableView registerClass:[HSJBuySectionHeadView class] forHeaderFooterViewReuseIdentifier:@"HSJBuySectionHeadView"];
    [self.safeAreaView addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    self.tableView.tableFooterView = self.footView;
}

- (void)setupConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.safeAreaView);
    }];
}

- (void)resultDeal {
    if(!self.viewModel.isLoadingData) {
        if(self.viewModel.planModel && self.viewModel.userInfoModel) {
            [self.viewModel buildCellDataList];
            self.tableView.hidden = NO;
            [self reload];
            [self updateHeadView];
            [self updateFootView];
        }
    }
}

- (void)startSaleTimer {
    kWeakSelf
    [self.viewModel startCountDownTimer:^() {
        if(weakSelf.viewModel.buttonType != HSJBUYBUTTON_TIMER) {
            [weakSelf updateFootView];
            [weakSelf updateHeadView];
        }
        else {
            weakSelf.footView.btnContent = weakSelf.viewModel.buttonShowContent;
        }
    }];
}

- (void)reload {
    [self.tableView reloadData];
    self.headView.isKeepKeyboard = YES;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.sectionFooterHeight = 0.1;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
    }
    
    return _tableView;
}

- (HSJBuyHeadView *)headView {
    if(!_headView) {
        _headView = [[HSJBuyHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScrAdaptationH(155.5))];
        _headView.inputMoney = self.startMoney;
        kWeakSelf
        _headView.textChange = ^(NSString *text) {
            weakSelf.viewModel.inputMoney = text;
            [weakSelf.viewModel buildCellDataList];
            [weakSelf reload];
            [weakSelf updateFootView];
        };
    }
    return _headView;
}

- (HSJBuyFootView *)footView {
    if(!_footView) {
        _footView = [[HSJBuyFootView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScrAdaptationH(143))];
        _footView.isAgreementGroup = YES;
        _footView.isShowAgreeRiskApplyAgreementView = NO;
        _footView.isAgreeRiskApplyAgreement = NO;
        _footView.btnContent = @"立即转入";
        kWeakSelf
        _footView.addAction = ^{
            [weakSelf addAction];
        };
        _footView.lookUpAgreement = ^{
            [weakSelf lookUpAgreement];
        };
    }
    
    return _footView;
}

- (void)updateHeadView {
    self.headView.addUpLimitMoney = self.viewModel.addUpLimit;
    self.headView.addCondition = self.viewModel.addCondition;
    self.headView.inputMoney = self.viewModel.inputMoney;
    
    if(HSJBUYBUTTON_EXITED==self.viewModel.buttonType || HSJBUYBUTTON_TIMER==self.viewModel.buttonType) {
        self.headView.enableContentTf = NO;
    }
    else {
        self.headView.enableContentTf = YES;
    }
}

- (void)updateFootView {
    self.footView.isShowAgreeRiskApplyAgreementView = self.viewModel.isShowRiskAgeement;
    self.footView.btnContent = self.viewModel.buttonShowContent;
    
    if(HSJBUYBUTTON_EXITED == self.viewModel.buttonType) {
        self.footView.enableAddButton = NO;
        self.footView.buttonBackGroundColor = kHXBColor_ECECF0_100;
    }
    else if(HSJBUYBUTTON_TIMER == self.viewModel.buttonType || HSJBUYBUTTON_NOMONEY == self.viewModel.buttonType) {
        self.footView.enableAddButton = NO;
        self.footView.buttonBackGroundColor = kHXBColor_FF7055_40;
    }
    else {
        self.footView.enableAddButton = YES;
        self.footView.buttonBackGroundColor = kHXBColor_FF7055_100;
    }
}

- (void)addAction {
    if(self.viewModel.buttonType == HSJBUYBUTTON_BINDCARD) {
        HxbWithdrawCardViewController *vc = [[HxbWithdrawCardViewController alloc] init];
        vc.type = HXBRechargeAndWithdrawalsLogicalJudgment_Other;
        vc.userInfoModel = self.viewModel.userInfoModel;
        kWeakSelf
        vc.block = ^(BOOL isBlindSuccess) {
            [weakSelf loadUserInfo];
        };
        [self.navigationController pushViewController:vc animated:YES];
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_BuyAddBankCardButtonClick];
    }
    else {
        kWeakSelf
        BOOL moneyCheckResult = [self.viewModel checkMoney:^(BOOL isLess) {
            if(isLess) {
                weakSelf.viewModel.inputMoney = weakSelf.viewModel.planModel.minRegisterAmount;
                [weakSelf.viewModel buildCellDataList];
                [weakSelf reload];
                [weakSelf updateHeadView];
                [weakSelf updateFootView];
            }
        }];
        BOOL agreementCheckResult = [self.viewModel checkAgreement:self.footView.isAgreementGroup agreeRiskApplyAgreement:self.footView.isAgreeRiskApplyAgreement];
        if(moneyCheckResult && agreementCheckResult) {//校验通过
            if([self.viewModel.buyType isEqualToString:@"balance"]) {//余额购买
                [self alertPassWord];
            }
            else {
                [self showRechargeAlertVC];
            }
        }
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_BuySureButtonClick];
    }
    
}

- (void)alertPassWord {
    kWeakSelf
    self.passwordView = [[HXBTransactionPasswordView alloc] init];
    [self.passwordView showInView:self.view];
    self.passwordView.getTransactionPasswordBlock = ^(NSString *password) {
        NSDictionary *dic = nil;
        dic = @{@"amount": weakSelf.viewModel.inputMoney,
                @"cashType": weakSelf.viewModel.planModel.cashType,
                @"buyType": weakSelf.viewModel.buyType,
                @"tradPassword": password,
                @"willingToBuy": @"1",
                //@"couponId": weakSelf.couponid
                };
        [weakSelf planBuy:dic];
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_BuyTransactionPasswordSureClick];
    };
    self.passwordView.cancelAction = ^{
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_BuyTransactionPasswordCancelClick];
    };
}

- (void)showRechargeAlertVC {
    if (!self.presentedViewController) {
        self.alertVC = [[HXBVerificationCodeAlertVC alloc] init];
        self.alertVC.isCleanPassword = YES;
        double rechargeMoney = [self.viewModel.inputMoney doubleValue] - self.viewModel.userInfoModel.userAssets.availablePoint.floatValue;
        self.alertVC.messageTitle = @"请输入短信验证码";
        self.alertVC.subTitle = [NSString stringWithFormat:@"已发送到%@上，请查收", [self.viewModel.userInfoModel.userBank.securyMobile replaceStringWithStartLocation:3 lenght:4]];
        kWeakSelf
        self.alertVC.sureBtnClick = ^(NSString *pwd) {
            [weakSelf.alertVC.view endEditing:YES];
            NSDictionary *dic = nil;
            dic = @{@"amount": self.viewModel.inputMoney,
                    @"cashType": weakSelf.viewModel.planModel.cashType,
                    @"buyType": weakSelf.viewModel.buyType,
                    @"balanceAmount": weakSelf.viewModel.userInfoModel.userAssets.availablePoint,
                    @"smsCode": pwd,
                    @"willingToBuy": @"1",
//                    @"couponId": weakSelf.couponid
                    };
            [weakSelf planBuy:dic];
            [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_BuyCodeSureClick];
        };
        self.alertVC.getVerificationCodeBlock = ^{
            [weakSelf.alertVC.verificationCodeAlertView enabledBtns];
            [weakSelf sendSmsCodeWithMoney:rechargeMoney];
        };
        self.alertVC.getSpeechVerificationCodeBlock = ^{
            [weakSelf.alertVC.verificationCodeAlertView enabledBtns];
            [weakSelf sendSmsCodeWithMoney:rechargeMoney];
        };
        self.alertVC.cancelBtnClickBlock = ^{
            [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_BuyCodeCancelClick];
        };
        [self presentViewController:self.alertVC animated:NO completion:nil];
    }
}

- (void)sendSmsCodeWithMoney:(double)topupMoney {
    kWeakSelf
    [self.viewModel getVerifyCodeRequesWithRechargeAmount:[NSString stringWithFormat:@"%.2f", topupMoney] andWithType:@"sms" andWithAction:@"buy" resultBlock:^(id responseData, NSError *erro) {
        if (!erro) {
            weakSelf.alertVC.subTitle = [NSString stringWithFormat:@"已发送到%@上，请查收", [weakSelf.viewModel.userInfoModel.userBank.securyMobile replaceStringWithStartLocation:3 lenght:4]];
            [weakSelf showRechargeAlertVC];
            [weakSelf.alertVC.verificationCodeAlertView disEnabledBtns];
        }
        else {
            [weakSelf.alertVC.verificationCodeAlertView enabledBtns];
        }
    }];
}

- (void)planBuy:(NSDictionary*)paramDic {
    kWeakSelf
    [self.viewModel planBuyReslutWithPlanID:self.viewModel.planModel.planId parameter:paramDic resultBlock:^(BOOL isSuccess) {
        if([self.viewModel.buyType isEqualToString:@"balance"]) {//余额购买
            [self.passwordView removeFromSuperview];
        }
        else {
            [self.alertVC dismissViewControllerAnimated:NO completion:nil];
        }
        
        if(isSuccess) {
            [weakSelf buyResult:0];
        }
        else {
            [weakSelf buyResult:weakSelf.viewModel.buyErrorCode];
        }
    }];
}

- (void)buyResult:(NSInteger)state {
    if(kBuy_Toast != state) {
        HSJPlanBuyResultViewController  *vc = [[HSJPlanBuyResultViewController alloc] init];
        vc.state = state;
        if(0 == state) {
            vc.lockStart = self.viewModel.resultModel.lockStart;
        }
        else {
            vc.erroInfo = self.viewModel.buyErrorMessage;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)lookUpAgreement {
    HSJAgreementsViewController *vc = [[HSJAgreementsViewController alloc] init];
    vc.isFullScreenShow = YES;
    [self presentViewController:vc animated:NO completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.cellDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSJBuyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HSJBuyTableViewCell"];
    BOOL isLastItem = NO;
    if(indexPath.row >= self.viewModel.cellDataList.count-1) {
        isLastItem = YES;
    }
    HSJBuyCellModel *cellModel = [self.viewModel.cellDataList safeObjectAtIndex:indexPath.row];
    [cell bindData:isLastItem cellDataModel:cellModel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScrAdaptationH(64);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HSJBuySectionHeadView *sectionView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSJBuySectionHeadView"];
    sectionView.title = @"支付方式";
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kScrAdaptationH(51);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(1 == indexPath.row) {
        HSJBuyCellModel *cellModel = [self.viewModel.cellDataList safeObjectAtIndex:indexPath.row];
        if(cellModel.isShowArrow) {
            if(!self.viewModel.userInfoModel.userInfo.hasBindCard.boolValue) {//绑卡
                HxbWithdrawCardViewController *vc = [[HxbWithdrawCardViewController alloc] init];
                vc.type = HXBRechargeAndWithdrawalsLogicalJudgment_Other;
                vc.userInfoModel = self.viewModel.userInfoModel;
                kWeakSelf
                vc.block = ^(BOOL isBlindSuccess) {
                    [weakSelf loadUserInfo];
                };
                [self.navigationController pushViewController:vc animated:YES];
                [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_BuyAddBankCardSmallButtonClick];
            }
            else{//换卡
                HxbMyBankCardViewController *vc = [[HxbMyBankCardViewController alloc] init];
                vc.isBank = YES;
                vc.isCashPasswordPassed = @"1";
                [self.navigationController pushViewController:vc animated:YES];
                [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_BuyChangeBankCardButtonClick];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
