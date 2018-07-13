//
//  HXBBindPhoneViewController.m
//  hoomxb
//
//  Created by caihongji on 2018/7/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HXBBindPhoneViewController.h"
#import "HXBBindPhoneTableFootView.h"
#import "HXBBindPhoneTableViewCell.h"
#import "HXBCheckCaptchaViewController.h"

@interface HXBBindPhoneViewController ()

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) HXBBindPhoneTableFootView* footView;

@property (nonatomic, strong) HXBBindPhoneVCViewModel* viewModel;

//
@property (nonatomic, copy) NSString *checkPaptcha;

@end

@implementation HXBBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupUI];
    [self addConstraints];
}

- (void)setupData {
    self.viewModel = [[HXBBindPhoneVCViewModel alloc] init];
    [self.viewModel buildCellDataList:self.bindPhoneStepType userInfoModel:self.userInfoModel];
}

- (void)setupUI {
    self.isWhiteColourGradientNavigationBar = YES;
    self.title = @"绑定新手机号";
    self.view.backgroundColor = kHXBFontColor_f3f4f5_100;
    [self.safeAreaView addSubview:self.tableView];
    
    [self.tableView registerClass:[HXBBindPhoneTableViewCell class] forCellReuseIdentifier:@"HXBBindPhoneTableViewCell"];
    self.tableView.tableFooterView = self.footView;
}

- (void)addConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.safeAreaView);
    }];
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
//        _tableView.estimatedRowHeight = kScrAdaptationH(48);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (HXBBindPhoneTableFootView *)footView {
    if(!_footView) {
        _footView = [[HXBBindPhoneTableFootView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScrAdaptationH(80))];
        _footView.buttonTitle = @"立即验证";
        _footView.buttonBackGroundColor = [UIColor redColor];
        
        kWeakSelf
        _footView.checkAct = ^{
            [weakSelf checkButtonAct];
        };
    }
    
    return _footView;
}

- (void)checkButtonAct {
    switch (self.bindPhoneStepType) {
        case HXBBindPhoneStepFirst:
        case HXBBindPhoneTransactionPassword:
        {
            NSString *idCard = [self.viewModel getTextAtIndex:1];
            NSString *smsCode = [self.viewModel getTextAtIndex:3];
            [self verifyWithIDCard:idCard andCode:smsCode];
            break;
        }
        case HXBBindPhoneStepSecond:
        {
            NSString *phone = [self.viewModel getTextAtIndex:0];
            NSString *smsCode = [self.viewModel getTextAtIndex:1];
            break;
        }
            
        default:
            break;
    }
}
/**
 验证身份证号码
 
 @param IDCard 身份证号码
 */
- (void)authenticationWithIDCard:(NSString *)IDCard indexPathForCell:(NSIndexPath*)indexPath
{
    HXBBindPhoneTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    kWeakSelf
    if ([self.userInfoModel.userInfo.isIdPassed isEqualToString:@"1"] && self.bindPhoneStepType == HXBBindPhoneTransactionPassword) {
        [self.viewModel modifyTransactionPasswordWithIdCard:IDCard resultBlock:^(id responseData, NSError *erro) {
            if(!erro) {
                [cell checkCodeCountDown:YES];
                [weakSelf getValidationCode:indexPath];
            }
        }];
    } else {
        [cell checkCodeCountDown:YES];
        [weakSelf getValidationCode:indexPath];
    }
    
}


/**
 获取验证码
 */
- (void)getValidationCode:(NSIndexPath*)indexPath {
    // fixme : 暂时获取验证码的action只有两个，目前处理为修改交易密码用前面的，其他均为解绑原手机号。
    NSString *action = self.bindPhoneStepType == HXBBindPhoneTransactionPassword ? kTypeKey_tradpwd : kTypeKey_oldmobile;
    
    kWeakSelf
    [self.viewModel myTraderPasswordGetverifyCodeWithAction:action resultBlock:^(id responseData, NSError *erro) {
        if(erro) {
            HXBBindPhoneTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            [cell checkCodeCountDown:NO];
        }
    }];
}

- (void)verifyWithIDCard:(NSString *)IDCard andCode:(NSString *)code
{
    if (code.length == 0) {
        [HxbHUDProgress showTextWithMessage:@"短信验证码不能为空"];
    } else {
        kWeakSelf
        [self.viewModel modifyBindPhone:IDCard code:code resultBlock:^(id responseData, NSError *erro) {
            if(!erro) {
                [weakSelf checkIdentitySmsSuccessWithIDCard:IDCard andCode:code];
            }
        }];
    }
}

- (void)checkIdentitySmsSuccessWithIDCard:(NSString *)IDCard andCode:(NSString *)code
{
    if(self.bindPhoneStepType == HXBBindPhoneStepFirst) {
        HXBBindPhoneViewController *vc = [[HXBBindPhoneViewController alloc] init];
        vc.userInfoModel = self.userInfoModel;
        vc.bindPhoneStepType = HXBBindPhoneStepSecond;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(self.bindPhoneStepType == HXBBindPhoneStepSecond) {
        
    }
    else if(self.bindPhoneStepType == HXBBindPhoneTransactionPassword) {
        
    }
//    if (self.type == HXBModifyTransactionPasswordType) {
//        HXBTransactionPasswordConfirmationViewController *transactionPasswordVC = [[HXBTransactionPasswordConfirmationViewController alloc] init];
//        transactionPasswordVC.idcard = IDCard;
//        transactionPasswordVC.code = code;
//        [self.navigationController pushViewController:transactionPasswordVC animated:YES];
//    }else if (self.type == HXBModifyPhoneType){
//        HXBModifyPhoneViewController *modifyPhoneVC = [[HXBModifyPhoneViewController alloc] init];
//        [self.navigationController pushViewController:modifyPhoneVC animated:YES];
//    }

}

- (void)textChangeCheck:(NSIndexPath*)indexPath checkText:(NSString*)text{
    if(self.bindPhoneStepType==HXBBindPhoneStepFirst || self.bindPhoneStepType==HXBBindPhoneTransactionPassword) {
        if(indexPath.row == 1) {
            HXBBindPhoneTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            if(text.length > 17) {
                [cell enableCheckButton:YES];
            }
            else{
                [cell enableCheckButton:NO];
            }
        }
    }
    else if(self.bindPhoneStepType == HXBBindPhoneStepSecond) {
        if(indexPath.row == 0) {
            HXBBindPhoneTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            if(text.length > 10) {
                [cell enableCheckButton:YES];
            }
            else{
                [cell enableCheckButton:NO];
            }
        }
    }
}

#pragma mark 修改绑定手机号的第二步操作
/**
进入图形验证码界面
*/
- (void)enterGraphicsCodeViewWithPhoneNumber:(NSString *)phoneNumber{
    kWeakSelf
    ///1. 如果要是已经图验过了，那就不需要图验了
    HXBCheckCaptchaViewController *checkCaptchVC = [[HXBCheckCaptchaViewController alloc]init];
    [self presentViewController:checkCaptchVC animated:YES completion:nil];
    [checkCaptchVC checkCaptchaSucceedFunc:^(NSString *checkPaptcha){
        weakSelf.checkPaptcha = checkPaptcha;
        [weakSelf graphicSuccessWithPhoneNumber:phoneNumber andWithCheckPaptcha:checkPaptcha];
        //        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
        //        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //        });
    }];
    
}

/**
 图形验证成功
 
 @param phoneNumber 新手机号
 @param checkPaptcha 图形验证码
 */
- (void)graphicSuccessWithPhoneNumber:(NSString *)phoneNumber andWithCheckPaptcha:(NSString *)checkPaptcha
{
    kWeakSelf
    [self.viewModel getVerifyCodeRequesWithMobile:phoneNumber andAction:HXBSignUPAndLoginRequest_sendSmscodeType_newmobile andCaptcha:checkPaptcha andType:@"" andCallbackBlock:^(BOOL isSuccess, NSError *error) {
        if (isSuccess) {
            HXBBindPhoneTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [cell checkCodeCountDown:YES];
        }
        else {
            NSLog(@"%@",error);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.cellDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXBBindPhoneTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HXBBindPhoneTableViewCell"];
    HXBBindPhoneCellModel *cellModel = [self.viewModel.cellDataList safeObjectAtIndex:indexPath.row];
    
    cell.indexPath = indexPath;
    cell.cellModel = cellModel;
    
    kWeakSelf
    if(!cell.checkCodeAct) {
        cell.checkCodeAct = ^(NSIndexPath *indexPath) {
            if(weakSelf.bindPhoneStepType == HXBBindPhoneStepFirst) {
                NSString *idCard = @""; //身份证号
                HXBBindPhoneCellModel *cellModel = [weakSelf.viewModel.cellDataList safeObjectAtIndex:1];
                idCard = cellModel.text;
                [weakSelf authenticationWithIDCard:idCard indexPathForCell:indexPath];
            }
            else if(weakSelf.bindPhoneStepType == HXBBindPhoneStepSecond) {
                NSString *phone = @"";//新手机号
                HXBBindPhoneCellModel *cellModel = [weakSelf.viewModel.cellDataList safeObjectAtIndex:0];
                phone = cellModel.text;
                [weakSelf enterGraphicsCodeViewWithPhoneNumber:phone];
            }
        };
    }
    
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
