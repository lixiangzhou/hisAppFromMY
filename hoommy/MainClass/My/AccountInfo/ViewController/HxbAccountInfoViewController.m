//
//  HxbAccountInfoViewController.m
//  hoomxb
//  账户设置
//  Created by HXB-C on 2017/5/8.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HxbAccountInfoViewController.h"
//#import "HxbMyBankCardViewController.h"
//#import "HxbMyAccountSecurityViewController.h"
#import "HxbMyAboutMeViewController.h"
#import "HXBBaseTabBarController.h"
//#import "HxbWithdrawCardViewController.h"
#import "HXBAccountInfoViewModel.h"
#import "HXBGeneralAlertVC.h"
#import "HXBAccountSecureCell.h"
#import <YYModel.h>
//#import "HXBBottomLineTableViewCell.h"
#import "HXBBaseWKWebViewController.h"
#import "HXBAccount_AlterLoginPassword_ViewController.h"
#import "HXBBindPhoneViewController.h"

#import "HXBCommonProblemViewController.h"

#import "HxbWithdrawCardViewController.h"
#import "HSJDepositoryOpenController.h"
#import "HSJGestureSettingController.h"
#import "NSString+HxbPerMilMoney.h"
#import "HSJDepositoryOpenTipController.h"


typedef enum : NSUInteger {
    USERINFO_UPDATE_FAILE,//失败
    USERINFO_UPDATE_ING, //正在更新
    USERINFO_UPDATE_SUCCESS,//成功
}UserInfoUpdateState;

@interface HxbAccountInfoViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *signOutLabel;
//@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) HXBAccountInfoViewModel *viewModel;

@property (nonatomic, assign) UserInfoUpdateState userInfoUpdateState;
@property (nonatomic, assign) HXBAccountSecureType actionType;
@end

@implementation HxbAccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户设置";
    
    kWeakSelf
    self.viewModel = [[HXBAccountInfoViewModel alloc] init];
    self.viewModel.hugViewBlock = ^UIView *{
        return weakSelf.view;
    };
    [self.view addSubview:self.tableView];
}

- (void)setupConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentViewInsetNoTabbar);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)reLoadWhenViewAppear {
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.actionType = HXBAccountSecureTypeNone;
    if(self.userInfoModel) {
        [self loadData_userInfo:NO];///加载用户数据
    }
    else {
        [self loadData_userInfo:YES];///加载用户数据
    }
    [self prepareData];
    [self.tableView reloadData];
    [self setUpScrollFreshBlock:self.tableView];
    [self setupConstraints];
    self.isShowSplitLine = YES;
    self.userInfoUpdateState = USERINFO_UPDATE_FAILE;
}

/**
 再次获取网络数据
 */
- (void)getNetworkAgain
{
     [self loadData_userInfo:YES];
}

#pragma mark 绑定手机号

- (void)bindPhone
{
    if (!self.userInfoModel.userInfo.isCreateEscrowAcc) {
        if ([self.userInfoModel.userInfo.isMobilePassed isEqualToString:@"1"]) {
            [self entryBindPhonePage:HXBBindPhoneStepFirst];
        }
    } else {
        if (self.userInfoModel.userInfo.isUnbundling) {
            [HXBAlertManager callupWithphoneNumber:kServiceMobile andWithTitle:@"温馨提示" Message:[NSString stringWithFormat:@"您的身份信息不完善，请联系客服 %@", kServiceMobile]];
            return;
        }
        if ([self.userInfoModel.userInfo.hasBindCard isEqualToString:@"1"]) {
            if ([self.userInfoModel.userInfo.isMobilePassed isEqualToString:@"1"]) {
                [self entryBindPhonePage:HXBBindPhoneStepFirst];
            }
        } else {
            if ([self.userInfoModel.userInfo.isCashPasswordPassed isEqualToString:@"1"]) {
                HXBGeneralAlertVC *alertVC = [[HXBGeneralAlertVC alloc] initWithMessageTitle:@"温馨提示" andSubTitle:@"由于银行限制，您需要绑定银行卡后方可修改手机号" andLeftBtnName:@"暂不绑定" andRightBtnName:@"立即绑定" isHideCancelBtn:YES isClickedBackgroundDiss:NO];
                alertVC.isCenterShow = YES;
                [alertVC setRightBtnBlock:^{
                    //进入绑卡界面
                    HxbWithdrawCardViewController *withdrawCardViewController = [[HxbWithdrawCardViewController alloc]init];
                    withdrawCardViewController.type = HXBRechargeAndWithdrawalsLogicalJudgment_Other;
                    [self.navigationController pushViewController:withdrawCardViewController animated:YES];
                }];
                
                [self presentViewController:alertVC animated:NO completion:nil];
            }
            else {//账户信息不完善
                HSJDepositoryOpenController *vc = [[HSJDepositoryOpenController alloc] init];
                vc.userInfoModel = self.userInfoModel;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

#pragma mark 修改交易密码
- (void)modifyTransactionPwd {
    if (self.userInfoModel.userInfo.isUnbundling) {
        [HXBAlertManager callupWithphoneNumber:kServiceMobile andWithTitle:@"温馨提示" Message:[NSString stringWithFormat:@"您的身份信息不完善，请联系客服 %@", kServiceMobile]];
        return;
    }

    if (!self.userInfoModel.userInfo.isCreateEscrowAcc) {
        [self entryDepositoryAccount];
    }
    else {
        if ([self.userInfoModel.userInfo.isCashPasswordPassed isEqualToString:@"1"]) {
            [self entryBindPhonePage:HXBBindPhoneTransactionPassword];
        }
        else {//账户信息不完善
            HSJDepositoryOpenController *vc = [[HSJDepositoryOpenController alloc] init];
            vc.userInfoModel = self.userInfoModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
}

- (void)entryBindPhonePage:(HXBBindPhoneStepType)stepType {
    HXBBindPhoneViewController* vc = [[HXBBindPhoneViewController alloc] init];
    vc.bindPhoneStepType = stepType;
    vc.userInfoModel = self.userInfoModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)preLoadUserInfo:(HXBAccountSecureType)acttionType {
    if(self.userInfoUpdateState == USERINFO_UPDATE_SUCCESS) {
        return NO;
    }
    else {
        [self loadData_userInfo:YES];
    }
    self.actionType = acttionType;
    return YES;
}

- (void)dispathFirstSectionClickTask:(HXBAccountSecureType)acttionType {
    switch (acttionType) {
        case HXBAccountSecureTypeModifyPhone:
            //绑定手机号
            if(![self preLoadUserInfo:acttionType]) {
                [self bindPhone];
            }
            break;
        case HXBAccountSecureTypeLoginPwd:
            //登录密码
        {
            if(![self preLoadUserInfo:acttionType]) {
                NSLog(@"登录密码");
                HXBAccount_AlterLoginPassword_ViewController *signUPVC = [[HXBAccount_AlterLoginPassword_ViewController alloc] init];
                signUPVC.type = HXBSignUPAndLoginRequest_sendSmscodeType_forgot;
                [self.navigationController pushViewController: signUPVC animated:YES];
            }
        }
            break;
        case HXBAccountSecureTypeTransactionPwd:
            if(![self preLoadUserInfo:acttionType]) {
                [self modifyTransactionPwd];
            }
            break;
        case HXBAccountSecureTypeGesturePwdModify:
            //手势密码
        {
            NSLog(@"修改手势密码");
            HSJCheckLoginPasswordViewController *VC = [[HSJCheckLoginPasswordViewController alloc] init];
            VC.switchType = HXBAccountSecureSwitchTypeChange;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case HXBAccountSecureTypeGesturePwdSwitch:
            //修改手势密码
            NSLog(@"手势密码开关");
            break;
        default:
            break;
    }
}

#pragma TableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScrAdaptationH(160))];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(kScrAdaptationW(25), kScrAdaptationH(20), kScrAdaptationW(50), kScrAdaptationW(50))];
        iconImg.layer.cornerRadius = kScrAdaptationW(25);
        iconImg.layer.masksToBounds = YES;
        iconImg.image = [UIImage imageNamed:@"personal_center"];
        [bgView addSubview:iconImg];
        
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(kScrAdaptationW(90), kScrAdaptationH(32), kScrAdaptationW(150), kScrAdaptationH(25))];
        nameLab.textAlignment = NSTextAlignmentLeft;
        nameLab.font = kHXBFont_PINGFANGSC_REGULAR(18);
        nameLab.textColor = COR28;
        nameLab.text = self.userInfoModel.userInfo.username?:@"--";
        [bgView addSubview:nameLab];
        
        UIImageView *hf_bgImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kScrAdaptationW(15), kScrAdaptationH(89), kScreenWidth-2*kScrAdaptationW(15), kScrAdaptationH(70))];
        hf_bgImgV.image = [UIImage imageNamed:@"home_bot_safety_bg"];
        hf_bgImgV.userInteractionEnabled = YES;
        [bgView addSubview:hf_bgImgV];
        
        if (self.userInfoModel.userInfo.isCreateEscrowAcc) {
            UIImageView *hfProtocolImg = [[UIImageView alloc]initWithFrame:CGRectZero];
            hfProtocolImg.image = [UIImage imageNamed:@"home_bot_safety"];
            [hf_bgImgV addSubview:hfProtocolImg];
            
            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(kScrAdaptationW(31), kScrAdaptationH(13), kScrAdaptationW(300), kScrAdaptationH(20))];
            name.textAlignment = NSTextAlignmentLeft;
            name.font = kHXBFont_PINGFANGSC_REGULAR(14);
            name.textColor = COR5;
            
            NSString * nameStr = [self.userInfoModel.userInfo.realName replaceStringWithStartLocation:0 lenght:self.userInfoModel.userInfo.realName.length - 1];
            
            NSString *idNo = [NSString hiddenStr:self.userInfoModel.userInfo.idNo MidWithFistLenth:1 andLastLenth:1];
            idNo = [NSMutableString stringWithFormat:@"（%@）",idNo];
        
            NSString *messageStr = [NSString stringWithFormat:@"真实姓名：%@%@",nameStr,idNo];
            NSRange range = [messageStr rangeOfString:idNo];
            name.attributedText = [NSMutableAttributedString setupAttributeStringWithString:messageStr WithRange:(NSRange)range andAttributeColor:RGB(146, 149, 162) andAttributeFont:kHXBFont_PINGFANGSC_REGULAR(14)];
            [hf_bgImgV addSubview:name];
            
            UILabel *bankProtocolLab = [[UILabel alloc]initWithFrame:CGRectMake(kScrAdaptationW(11), kScrAdaptationH(39), kScrAdaptationW(150), kScrAdaptationH(20))];
            bankProtocolLab.textAlignment = NSTextAlignmentLeft;
            bankProtocolLab.font = kHXBFont_PINGFANGSC_REGULAR(14);
            bankProtocolLab.textColor = RGB(72, 140, 255);
            bankProtocolLab.text = @"《恒丰银行存管协议》";
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHFbankProtocolButton:)];
            [bankProtocolLab addGestureRecognizer:tap];
            bankProtocolLab.userInteractionEnabled = YES;
            [hf_bgImgV addSubview:bankProtocolLab];
            
            [hfProtocolImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(name);
                make.left.offset(kScrAdaptationW(15));
                make.width.equalTo(@kScrAdaptationW(11));
                make.height.equalTo(@kScrAdaptationH(13));
            }];
        } else {
            UIImageView *hfProtocolImg = [[UIImageView alloc]initWithFrame:CGRectMake(kScrAdaptationW(30), kScrAdaptationH(26), kScrAdaptationW(24), kScrAdaptationH(18))];
            hfProtocolImg.image = [UIImage imageNamed:@"hflogo"];
            [hf_bgImgV addSubview:hfProtocolImg];
            
            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(kScrAdaptationW(59), kScrAdaptationH(24), kScrAdaptationW(130), kScrAdaptationH(22))];
            name.textAlignment = NSTextAlignmentLeft;
            name.font = kHXBFont_PINGFANGSC_REGULAR(16);
            name.textColor = COR19;
            name.text = @"恒丰银行资金存管";
            [hf_bgImgV addSubview:name];
            
            UIButton *openBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScrAdaptationW(245), kScrAdaptationH(19), kScrAdaptationW(90), kScrAdaptationH(32))];
            [openBtn setTitle:@"立即开通" forState:UIControlStateNormal];
            [openBtn setBackgroundColor: [UIColor colorWithRed:72/255.0 green:140/255.0 blue:255/255.0 alpha:1/1.0]];
            openBtn.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
            openBtn.layer.cornerRadius = 4.0f;
            openBtn.layer.masksToBounds = YES;
            [openBtn addTarget:self action:@selector(entryDepositoryAccount) forControlEvents:UIControlEventTouchUpInside];
            [hf_bgImgV addSubview:openBtn];
        }
        
        return bgView;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HXBAccountSecureModel *model = self.dataSource[indexPath.row];
    if (indexPath.section == 0) {
        [self dispathFirstSectionClickTask:model.type];
    } else if (indexPath.section == 1) {
        NSInteger row =  [tableView numberOfRowsInSection:0] + indexPath.row;
        model = self.dataSource[row];
        switch (model.type) {
            case HXBAccountSecureTypeCommonProblems:{
                //常见问题HXBCommonProblemViewController
                HXBCommonProblemViewController *commonProblemVC = [[HXBCommonProblemViewController alloc] init];
                commonProblemVC.pageUrl = [NSString splicingH5hostWithURL:kHXBUser_QuestionsURL];
                [self.navigationController pushViewController:commonProblemVC animated:YES];
            }
            break;
        case HXBAccountSecureTypeAboutUs:
            {
                //关于我们
                HxbMyAboutMeViewController *myAboutMeViewController = [[HxbMyAboutMeViewController alloc] init];
                [self.navigationController pushViewController:myAboutMeViewController animated:YES];
            }
            
            break;
        default:
            break;
        }
    } else {
        NSLog(@"退出账号");
        [self signOutButtonButtonClick]; //退出账号
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScrAdaptationH(55);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return kScrAdaptationH(160);
    } else {
        return kScrAdaptationH(10);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma TableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    HXBAccountSecureCell *cell = [tableView dequeueReusableCellWithIdentifier:HXBAccountSecureCellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.model = self.dataSource[indexPath.row];
        cell.hiddenLine = cell.model.type == HXBAccountSecureTypeGesturePwdModify ?:NO;
        cell.isLineRight = YES;
    } else if (indexPath.section == 1) {
        NSInteger row =  [tableView numberOfRowsInSection:0] + indexPath.row;
        cell.model = self.dataSource[row];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.hiddenLine = cell.model.type == HXBAccountSecureTypeAboutUs ?:NO;
        cell.isLineRight = YES;
    } else {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:self.signOutLabel];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.hiddenLine = YES;
        cell.isLineRight = YES;
        
        [self.signOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.height.width.equalTo(cell.contentView);
        }];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return self.dataSource.count-2;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (void)clickHFbankProtocolButton:(UIGestureRecognizer *)tap {
    NSLog(@"跳转恒丰银行协议");
    kWeakSelf
    [HXBBaseWKWebViewController pushWithPageUrl:[NSString splicingH5hostWithURL:kHXB_Negotiate_thirdpart] fromController:weakSelf];
}

/**
 进入存管账户
 */
- (void)entryDepositoryAccount
{
    NSLog(@"开通存管账户");
    HSJDepositoryOpenController *VC = [HSJDepositoryOpenController new];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)prepareData {
    NSMutableArray *data = [NSMutableArray new];
    [data addObject:@{@"type":@(HXBAccountSecureTypeModifyPhone), @"title": @"修改手机号"}];
    [data addObject:@{@"type":@(HXBAccountSecureTypeTransactionPwd), @"title": @"交易密码"}];
    [data addObject:@{@"type":@(HXBAccountSecureTypeLoginPwd), @"title": @"登录密码"}];
    [data addObject:@{@"type":@(HXBAccountSecureTypeGesturePwdSwitch), @"title": @"手势密码开关"}];
//    [data addObject:@{@"type":@(HXBAccountSecureTypeGesturePwdModify), @"title": @"修改手势密码"}];//暂时写上
    
    if ([KeyChain.skipGesture isEqual:kHXBGesturePwdSkipeNO]) {
        [data addObject:@{@"type":@(HXBAccountSecureTypeGesturePwdModify), @"title": @"修改手势密码"}];
    }
    [data addObject:@{@"type":@(HXBAccountSecureTypeCommonProblems), @"title": @"常见问题"}];
    [data addObject:@{@"type":@(HXBAccountSecureTypeAboutUs), @"title": @"关于我们"}];
    
    kWeakSelf
    self.dataSource = [NSMutableArray arrayWithCapacity:data.count];
    for (NSInteger i = 0; i < data.count; i++) {
        NSDictionary *dict = data[i];
        
        HXBAccountSecureModel *model = [HXBAccountSecureModel yy_modelWithJSON:dict];
        if (model.type == HXBAccountSecureTypeGesturePwdSwitch) {
            model.switchBlock = ^(BOOL isOn) {
                HSJCheckLoginPasswordViewController *VC = [[HSJCheckLoginPasswordViewController alloc] init];
                VC.switchType = isOn ? HXBAccountSecureSwitchTypeOn : HXBAccountSecureSwitchTypeOff;
                [weakSelf.navigationController pushViewController:VC animated:YES];
            };
        }
        
        [self.dataSource addObject:model];
    }
}

//登出按钮事件
- (void)signOutButtonButtonClick{
    kWeakSelf
    HXBGeneralAlertVC *alertVC = [[HXBGeneralAlertVC alloc] initWithMessageTitle:@"提示" andSubTitle:@"您确定要退出登录吗？" andLeftBtnName:@"取消" andRightBtnName:@"确定" isHideCancelBtn:YES isClickedBackgroundDiss:YES];
    alertVC.isCenterShow = YES;
    [self presentViewController:alertVC animated:NO completion:nil];
    [alertVC setRightBtnBlock:^{
        
        [weakSelf.viewModel userLogOut:YES resultBlock:^(id responseData, NSError *erro) {
            
            if (!erro) {
                [(HXBBaseTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController setSelectedIndex:0];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }];
}

- (UILabel *)signOutLabel
{
    if (!_signOutLabel) {
        _signOutLabel = [[UILabel alloc] init];
        _signOutLabel.text = @"退出登录";
        _signOutLabel.textColor = kHXBColor_666666_100;
        _signOutLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
        _signOutLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _signOutLabel;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView  alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerClass:[HXBAccountSecureCell class] forCellReuseIdentifier:HXBAccountSecureCellID];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionHeaderHeight = 0.1;
        _tableView.sectionFooterHeight = 0.1;
    }
    return _tableView;
}

#pragma mark - 加载数据
- (void)loadData_userInfo:(BOOL)isShowLoading {
    self.userInfoUpdateState = USERINFO_UPDATE_ING;
    kWeakSelf
    [self.viewModel downLoadUserInfo:isShowLoading resultBlock:^(id responseData, NSError *erro) {
        if (!erro) {
            weakSelf.userInfoUpdateState = USERINFO_UPDATE_SUCCESS;
            weakSelf.userInfoModel = responseData;
            [weakSelf.tableView reloadData];
            [weakSelf dispathFirstSectionClickTask:self.actionType];
        }
        else{
            weakSelf.userInfoUpdateState = USERINFO_UPDATE_FAILE;
        }
        
        weakSelf.actionType = HXBAccountSecureTypeNone;
    }];
}

@end
