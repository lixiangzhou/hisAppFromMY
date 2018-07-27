//
//  HXBUnBindCardController.m
//  hoomxb
//
//  Created by lxz on 2017/11/29.
//Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBUnBindCardController.h"
#import "HXBBankCardViewModel.h"
#import "HXBBindPhoneViewController.h"
#import "HXBMyBankResultViewController.h"

#import "HSJUnBindCardHeadView.h"
#import "HXBBindPhoneTableFootView.h"
#import "HXBBindCardTableViewCell.h"

@interface HXBUnBindCardController ()

@property (nonatomic, strong) UIImageView *topLineImv;
@property (nonatomic, strong) HSJUnBindCardHeadView *headView;
@property (nonatomic, strong) HXBBindPhoneTableFootView *footView;
@property (nonatomic, strong) UITableView *tableView;

//数据源
@property (nonatomic, strong) HXBBankCardViewModel *bankCardViewModel;
@property (nonatomic, strong) NSArray *cellDataList;

//以下待删除
@property (nonatomic, weak) UIView *bankInfoView;
@property (nonatomic, weak) HXBCustomTextField *idCardTextField;
@property (nonatomic, weak) HXBCustomTextField *transactionPwdTextField;
@property (nonatomic, weak) UIButton *unBindBtn;
@end

@implementation HXBUnBindCardController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
    [self setupUI];
    [self setupConstraints];
}

- (void)setupData {
    self.bankCardViewModel = [[HXBBankCardViewModel alloc] init];
    self.bankCardViewModel.bankCardModel = self.bankCardModel;
    
    //构建cell数据源列表
    NSMutableArray *dataList = [NSMutableArray array];
    self.cellDataList = dataList;
    NSString *realName = [self.bankCardModel.name replaceStringWithStartLocation:0 lenght:self.bankCardModel.name.length - 1];
    HXBBindCardCellModel *cellModel = [[HXBBindCardCellModel alloc] initModel:@"真实姓名" placeText:@"" text:realName];
    [dataList addObject:cellModel];
    
    cellModel = [[HXBBindCardCellModel alloc] initModel:@"身份证号" placeText:@"请输入您的身份证号码" text:@""];
    cellModel.isCanEdit = YES;
    cellModel.keyboardType = UIKeyboardTypeNumberPad;
    cellModel.limtTextLenght = 18;
    [dataList addObject:cellModel];
    
    cellModel = [[HXBBindCardCellModel alloc] initModel:@"交易密码" placeText:@"请输入交易密码" text:@""];
    cellModel.isCanEdit = YES;
    cellModel.limtTextLenght = 6;
    cellModel.keyboardType = UIKeyboardTypeNumberPad;
    cellModel.secureTextEntry = YES;
    [dataList addObject:cellModel];
}

#pragma mark - UI

- (void)setupUI {
    self.title = @"解绑银行卡";
    
    [self.safeAreaView addSubview:self.topLineImv];
    
    [self.safeAreaView addSubview:self.tableView];
    [self.tableView registerClass:[HXBBindCardTableViewCell class] forCellReuseIdentifier:@"HXBBindCardTableViewCell"];
}

- (void)setupConstraints {
    [self.topLineImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaView).offset(0.5);
        make.left.right.equalTo(self.safeAreaView);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLineImv.mas_bottom).offset(0.5);
        make.left.right.bottom.equalTo(self.safeAreaView);
    }];
}

- (HSJUnBindCardHeadView *)headView {
    if(!_headView) {
        _headView = [[HSJUnBindCardHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScrAdaptationH(140))];
        _headView.bankCardModel = self.bankCardModel;
    }
    
    return _headView;
}

- (HXBBindPhoneTableFootView *)footView {
    if(!_footView) {
        _footView = [[HXBBindPhoneTableFootView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScrAdaptationH(119))];
        _footView.buttonTitle = @"确认解绑";
        _footView.rightTopBtnTitle = @"忘记密码？";
        _footView.buttonBackGroundColor = kHXBColor_FF7055_100;
        
        kWeakSelf
        _footView.checkAct = ^{
            [weakSelf unBind];
        };
        _footView.rightTopButtonAct = ^{
            HXBBindPhoneViewController *modifyTransactionPasswordVC = [[HXBBindPhoneViewController alloc] init];
            modifyTransactionPasswordVC.bindPhoneStepType = HXBBindPhoneTransactionPassword;
            [weakSelf.navigationController pushViewController:modifyTransactionPasswordVC animated:YES];
        };
    }
    
    return _footView;
}

- (UIImageView *)topLineImv {
    if(!_topLineImv) {
        _topLineImv = [[UIImageView alloc] init];
        _topLineImv.backgroundColor = kHXBColor_EEEEF5_100;
    }
    
    return _topLineImv;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headView;
        _tableView.tableFooterView = self.footView;
    }
    return _tableView;
}

- (void)textChangeCheck:(NSIndexPath*)indexPath checkText:(NSString*)text{
    
}

- (void)unBind {
    HXBBindCardCellModel *cellModel = [self.cellDataList safeObjectAtIndex:1];
    NSString *idCardNo = [cellModel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    cellModel = [self.cellDataList safeObjectAtIndex:2];
    NSString *transactionPwd = [cellModel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 验证身份证号
    NSString *idCardNoMessage = [self.bankCardViewModel validateIdCardNo:idCardNo];
    if (idCardNoMessage) {
        [HxbHUDProgress showTextWithMessage:idCardNoMessage];
        return;
    }
    
    // 验证交易密码
    NSString *transactionPwdMessage = [self.bankCardViewModel validateTransactionPwd:transactionPwd];
    if (transactionPwdMessage) {
        [HxbHUDProgress showTextWithMessage:transactionPwdMessage];
        return;
    }
    
    // 防止按钮重复点击
    self.unBindBtn.enabled = NO;
    
    kWeakSelf
    [self.bankCardViewModel requestUnBindWithParam:@{@"idCardNo": idCardNo, @"cashPassword": transactionPwd} finishBlock:^(BOOL succeed, NSString *errorMessage, BOOL canPush) {
        // 防止按钮重复点击
        weakSelf.unBindBtn.enabled = YES;
        
        if (canPush) {
            HXBMyBankResultViewController *VC = [HXBMyBankResultViewController new];
            VC.isSuccess = succeed;
            VC.mobileText = weakSelf.bankCardViewModel.bankNoLast4;
            VC.describeText = errorMessage;
            [weakSelf.navigationController pushViewController:VC animated:YES];
        }
    }];
}

#pragma mark - Setter / Getter / Lazy
- (void)setBankCardModel:(HXBBankCardModel *)bankCardModel {
    _bankCardModel = bankCardModel;
    self.bankCardViewModel.bankCardModel = bankCardModel;
}

- (HXBBankCardViewModel *)bankCardViewModel {
    if (_bankCardViewModel == nil) {
        _bankCardViewModel = [HXBBankCardViewModel new];
    }
    return _bankCardViewModel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXBBindCardTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HXBBindCardTableViewCell"];
    HXBBindCardCellModel *cellModel = [self.cellDataList safeObjectAtIndex:indexPath.row];
    
    cell.indexPath = indexPath;
    cell.cellModel = cellModel;
    
    kWeakSelf
    if(!cell.textChange) {
        cell.textChange = ^(NSIndexPath *indexPath, NSString *text) {
            [weakSelf textChangeCheck:indexPath checkText:text];
        };
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScrAdaptationH(48);
    
}

@end
