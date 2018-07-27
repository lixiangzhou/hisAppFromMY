//
//  HxbWithdrawCardViewController.m
//  hoomxb
//
//  Created by HXB-C on 2017/5/10.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HxbWithdrawCardViewController.h"
#import "HxbWithdrawResultViewController.h"
#import "HXBBankCardModel.h"
#import "HXBBindPhoneViewController.h"
#import "HXBBankCardListViewController.h"
#import "HXBWithdrawCardView.h"

#import "HxbMyTopUpViewController.h"
#import "HxbWithdrawViewController.h"
#import "HXBBankCardViewModel.h"

#import "HXBBindPhoneTableFootView.h"
#import "HXBBindCardCellModel.h"
#import "HXBBindCardTableViewCell.h"
#import "HSJClientServeTelView.h"
#import "HXBBankCardListViewController.h"

@interface HxbWithdrawCardViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *topLineImv;
@property (nonatomic, strong) HXBBindPhoneTableFootView *footView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HSJClientServeTelView *clientServerView;

@property (nonatomic, strong) HXBBankCardModel *bankCardModel;

@property (nonatomic, strong) HXBBankCardViewModel *bindBankCardVM;
@property (nonatomic, strong) NSArray *cellDataList;
@property (nonatomic, strong) HXBCardBinModel *carbinModel;

/**
 bankCode
 */
//@property (nonatomic, copy) NSString *bankCode;
/**
 数据模型
 */

@property (nonatomic, strong) HXBWithdrawCardView *withdrawCardView;


@end

@implementation HxbWithdrawCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isDisableSliderBack = YES;
    
    [self setupData];
    
}

- (void)setupData {
    self.bindBankCardVM = [[HXBBankCardViewModel alloc] init];
    if(!self.userInfoModel) {
        kWeakSelf
        [self.bindBankCardVM downLoadUserInfo:YES resultBlock:^(id responseData, NSError *erro) {
            if(!erro) {
                weakSelf.userInfoModel = responseData;
                [weakSelf setupUI];
                [weakSelf setupConstraints];
                [weakSelf buildCellModelList];
            }
        }];
    }
    else {
        [self setupUI];
        [self setupConstraints];
        [self buildCellModelList];
    }
}

- (void)buildCellModelList {
    //构建cell数据源列表
    NSMutableArray *dataList = [NSMutableArray array];
    self.cellDataList = dataList;
    NSString *realName = [self.userInfoModel.userInfo.realName replaceStringWithStartLocation:0 lenght:self.userInfoModel.userInfo.realName.length - 1];
    HXBBindCardCellModel *cellModel = [[HXBBindCardCellModel alloc] initModel:@"持卡人" placeText:@"" text:realName];
    [dataList addObject:cellModel];
    
    cellModel = [[HXBBindCardCellModel alloc] initModel:@"银行卡号" placeText:@"请输入银行卡号" text:@""];
    cellModel.isCanEdit = YES;
    cellModel.keyboardType = UIKeyboardTypeNumberPad;
    cellModel.isBankCardNoField = YES;
    cellModel.rightButtonText = @"查看限额";
    [dataList addObject:cellModel];
    
    cellModel = [[HXBBindCardCellModel alloc] initModel:@"手机号" placeText:@"请输入银行预留手机号" text:@""];
    cellModel.isCanEdit = YES;
    cellModel.limtTextLenght = 11;
    cellModel.keyboardType = UIKeyboardTypeNumberPad;
    [dataList addObject:cellModel];
}
#pragma mark - UI

- (void)setupUI {
    self.title = @"绑定银行卡";
    
    [self.safeAreaView addSubview:self.topLineImv];
    
    [self.safeAreaView addSubview:self.tableView];
    [self.tableView registerClass:[HXBBindCardTableViewCell class] forCellReuseIdentifier:@"HXBBindCardTableViewCell"];
    
    [self.safeAreaView addSubview:self.clientServerView];
}

- (void)setupConstraints {
    [self.topLineImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaView).offset(0.5);
        make.left.right.equalTo(self.safeAreaView);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.clientServerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.safeAreaView);
        make.bottom.equalTo(self.safeAreaView).offset(-kScrAdaptationW(20));
        make.height.mas_equalTo(kScrAdaptationH(62));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLineImv.mas_bottom).offset(0.5);
        make.left.right.equalTo(self.safeAreaView);
        make.bottom.equalTo(self.clientServerView.mas_top);
    }];
}

- (BOOL)judgeIsNull
{
    BOOL isNull = NO;
    HXBBindCardCellModel *cellModel = [self.cellDataList safeObjectAtIndex:1];
    if (!(cellModel.text.length > 0)) {
        [HxbHUDProgress showTextInView:self.view text:@"银行卡号不能为空"];
        isNull = YES;
    }
    else if (!(cellModel.text.length >= 10 && cellModel.text.length <= 31)) {
        [HxbHUDProgress showTextInView:self.view text:@"您银行卡号有误，请重新输入"];
        isNull = YES;
    }
    else {
        cellModel = [self.cellDataList safeObjectAtIndex:2];
        if (!(cellModel.text.length > 0)) {
            [HxbHUDProgress showTextInView:self.view text:@"预留手机号不能为空"];
            isNull = YES;
        }
        else if (cellModel.text.length != 11) {
            [HxbHUDProgress showTextInView:self.view text:@"预留手机号有误"];
            isNull = YES;
        }
    }
    
    return isNull;
}

- (HXBBindPhoneTableFootView *)footView {
    if(!_footView) {
        _footView = [[HXBBindPhoneTableFootView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScrAdaptationH(119))];
        _footView.buttonTitle = @"立即绑卡";
        _footView.buttonBackGroundColor = kHXBColor_FF7055_100;
        
        kWeakSelf
        _footView.checkAct = ^{
            if(![weakSelf judgeIsNull]) {
                HXBBindCardCellModel *cardCellModel = [weakSelf.cellDataList safeObjectAtIndex:1];
                HXBBindCardCellModel *phoneCellModel = [weakSelf.cellDataList safeObjectAtIndex:2];
                NSString *cardNo = [cardCellModel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSDictionary *dic = @{
                                      @"bankCard" : cardNo,
                                      @"bankReservedMobile" : phoneCellModel.text,
                                      @"bankCode" : weakSelf.carbinModel.bankCode?:@""
                                      };
                [weakSelf nextButtonClick:dic];
            }
            
        };
    }
    
    return _footView;
}

- (HSJClientServeTelView *)clientServerView {
    if(!_clientServerView) {
        _clientServerView = [[HSJClientServeTelView alloc] init];
        _clientServerView.callTelNumber = ^{
            [HXBAlertManager callupWithphoneNumber:kServiceMobile andWithTitle:@"红小宝客服电话" Message:kServiceMobile];
        };
    }
    
    return _clientServerView;
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
        _tableView.tableFooterView = self.footView;
    }
    return _tableView;
}

- (void)textChangeCheck:(NSIndexPath*)indexPath checkText:(NSString*)text{
    if (indexPath.row==1 && text.length >= 12) {
        kWeakSelf
        NSString *cardNo = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self.bindBankCardVM cancelRequest];
        [self.bindBankCardVM checkCardBinResultRequestWithBankNumber:cardNo andisToastTip:NO andCallBack:^(id responseData, NSError *erro) {
            if (erro) {
                weakSelf.bindBankCardVM.cardBinModel = nil;
            }
            if((!weakSelf.carbinModel&&weakSelf.bindBankCardVM.cardBinModel) || (weakSelf.carbinModel&&!weakSelf.bindBankCardVM.cardBinModel)) {
                weakSelf.carbinModel = weakSelf.bindBankCardVM.cardBinModel;
                [weakSelf.tableView reloadData];
                HXBBindCardTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                cell.isKeepKeyboardPop = YES;
            }
            
        }];
    }
}

- (void)leftBackBtnClick {
    if (_className.length > 0 && _type == HXBRechargeAndWithdrawalsLogicalJudgment_Other) {
        if (self.block) {
            self.block(0);
        }
        [self popToViewControllerWithClassName:_className];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)nextButtonClick:(NSDictionary *)dic{
    [self openStorageWithArgument:dic];
}

/**
 开通存管账户
 */
- (void)openStorageWithArgument:(NSDictionary *)dic{
    NSString *bankCard = [dic stringAtPath:@"bankCard"];
    //接口调用
    kWeakSelf
    [self.bindBankCardVM showProgress:nil];
    [self.bindBankCardVM checkCardBinResultRequestWithBankNumberExtend:bankCard andisToastTip:YES showHug:NO andCallBack:^(id responseData, NSError *erro) {
        if(!erro) {
            [weakSelf.bindBankCardVM bindBankCardRequestWithArgument:dic showHug:NO andFinishBlock:^(id responseData, NSError *erro) {
                [weakSelf.bindBankCardVM hideProgress:nil];
                if (!erro) {
                    [weakSelf bindBankCardRequest];
                }
            }];
        }
        else {
            [weakSelf.bindBankCardVM hideProgress:nil];
        }
    }];
    
    
}

- (void)bindBankCardRequest {
    if (self.type == HXBRechargeAndWithdrawalsLogicalJudgment_Recharge) {
        
        HxbMyTopUpViewController *hxbMyTopUpViewController = [[HxbMyTopUpViewController alloc]init];
        [self.navigationController pushViewController:hxbMyTopUpViewController animated:YES];
        
    } else if (self.type == HXBRechargeAndWithdrawalsLogicalJudgment_Withdrawals) {
        
        HxbWithdrawViewController *withdrawViewController = [[HxbWithdrawViewController alloc]init];
        if (!KeyChain.isLogin)  return;
        [self.navigationController pushViewController:withdrawViewController animated:YES];
        
    } else if(self.type == HXBRechargeAndWithdrawalsLogicalJudgment_Other) {
        if (self.block) { // 绑卡成功，返回
            self.block(1);
        };
        [self leftBackBtnClick];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXBBindCardTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HXBBindCardTableViewCell"];
    HXBBindCardCellModel *cellModel = [self.cellDataList safeObjectAtIndex:indexPath.row];
    
    cell.indexPath = indexPath;
    cell.cellModel = cellModel;
    
    if(indexPath.row == 1) {
        NSString *prompText = [NSString stringWithFormat:@"%@: %@", self.carbinModel.bankName, self.carbinModel.quota];
        [cell bindPrompInfo:self.carbinModel.bankCode prompText:prompText];
    }
    kWeakSelf
    if(!cell.textChange) {
        cell.textChange = ^(NSIndexPath *indexPath, NSString *text) {
            [weakSelf textChangeCheck:indexPath checkText:text];
        };
    }
    
    if(!cell.checkCodeAct) {
        cell.checkCodeAct = ^(NSIndexPath *indexPath) {
            HXBBankCardListViewController *vc = [[HXBBankCardListViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 1) {
        if(self.bindBankCardVM.cardBinModel) {
            return kScrAdaptationH(48+37);
        }
    }
    return kScrAdaptationH(48);
    
}

@end

