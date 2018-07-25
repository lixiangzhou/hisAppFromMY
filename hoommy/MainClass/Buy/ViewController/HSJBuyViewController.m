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

@interface HSJBuyViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HSJBuyFootView *footView;
@property (nonatomic, strong) HSJBuyHeadView *headView;

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

- (void)setupData {
    self.viewModel = [[HSJBuyViewModel alloc] init];
    self.planId = @"748";
    self.viewModel.inputMoney = self.startMoney;
    if(!self.planModel) {
        kWeakSelf
        [self.viewModel getDataWithId:self.planId showHug:YES resultBlock:^(id responseData, NSError *erro) {
            if(!erro) {
                weakSelf.viewModel.planModel = responseData;
                [weakSelf resultDeal];
            }
        }];
    }
    else{
        self.viewModel.planModel = self.planModel;
    }
    [self loadUserInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyCall:) name:kHXBNotification_unBindBankCard object:nil];
}

- (void)notifyCall:(NSNotification*)notify {
    NSDictionary *resultDic = notify.userInfo;
    if([notify.name isEqualToString:kHXBNotification_unBindBankCard]) {
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
            weakSelf.planModel = responseData;
            weakSelf.viewModel.userInfoModel = responseData;
            [weakSelf resultDeal];
        }
    }];
}

- (void)resultDeal {
    if(!self.viewModel.isLoadingData) {
        [self.viewModel buildCellDataList];
        self.tableView.hidden = NO;
        [self reload];
        [self updateHeadView];
        [self updateFootView];
    }
}

- (void)reload {
    [self.tableView reloadData];
    self.headView.isKeepKeyboard = YES;
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
        _footView.isTransparentBtnColor = YES;
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
}

- (void)updateFootView {
    self.footView.isShowAgreeRiskApplyAgreementView = self.viewModel.isShowRiskAgeement;
    self.footView.btnContent = self.viewModel.buttonShowContent;
    
    if(0 == self.viewModel.inputMoney.doubleValue) {
        self.footView.enableAddButton = NO;
    }
    else {
        self.footView.enableAddButton = YES;
    }
    
    if(0 == self.viewModel.inputMoney.floatValue) {
        self.footView.isTransparentBtnColor = YES;
    }
    else{
        self.footView.isTransparentBtnColor = NO;
    }
}

- (void)addAction {
    BOOL checkResult = [self.viewModel checkMoney:^(BOOL isLess) {
        
    }];
    if(checkResult) {//数据校验通过
        
    }
}

- (void)lookUpAgreement {
    HSJAgreementsViewController *vc = [[HSJAgreementsViewController alloc] init];
    vc.isFullScreenShow = YES;
    [self presentViewController:vc animated:YES completion:nil];
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
            }
            else{//换卡
                HxbMyBankCardViewController *vc = [[HxbMyBankCardViewController alloc] init];
                vc.isBank = YES;
                vc.isCashPasswordPassed = @"1";
                [self.navigationController pushViewController:vc animated:YES];
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
