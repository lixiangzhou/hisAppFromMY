//
//  HSJRollOutPlanDetailController.m
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJRollOutPlanDetailController.h"
#import "HSJRollOutPlanDetailViewModel.h"
#import "HSJRollOutDetailCell.h"
#import "HSJRollOutConfirmController.h"
#import "HXBBaseWKWebViewController.h"
#import "HSJFinAddRecortdViewController.h"

@interface HSJRollOutPlanDetailController ()
@property (nonatomic, strong) HSJRollOutPlanDetailViewModel *viewModel;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation HSJRollOutPlanDetailController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"存钱罐";
    self.viewModel = [HSJRollOutPlanDetailViewModel new];
    [self setUI];
    
    [self getData];
}

#pragma mark - UI

- (void)setUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = kHXBBackgroundColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = kScrAdaptationW(50);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = self.bottomView;
    [tableView registerClass:[HSJRollOutDetailCell class] forCellReuseIdentifier:HSJRollOutDetailCellIdentifier];
    [self.safeAreaView addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.safeAreaView);
    }];
}

#pragma mark - Network
- (void)getData {
    kWeakSelf
    [self.viewModel getPlanDetail:self.planId resultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.tableView reloadData];
            weakSelf.bottomView.hidden = weakSelf.viewModel.hideBottomView;
        }
    }];
}

#pragma mark - Delegate Internal

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSJRollOutDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:HSJRollOutDetailCellIdentifier forIndexPath:indexPath];
    NSArray *models = self.viewModel.dataSource[indexPath.section];
    cell.model = models[indexPath.row];
    cell.hideBottomLine = models.count - 1 == indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HSJRollOutPlanDetailRowModel *model = self.viewModel.dataSource[indexPath.section][indexPath.row];
    
    if (model.type == HSJRollOutPlanDetailRowTypeAction) {
        HSJFinAddRecortdViewController *vc = [HSJFinAddRecortdViewController new];
        vc.planId = self.planId;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (model.type == HSJRollOutPlanDetailRowTypeProtocol) {
        NSString *url = kHXB_Negotiate_ServePlan_AccountURL(self.planId);
        HXBBaseWKWebViewController *vc = [[HXBBaseWKWebViewController alloc] init];
        vc.pageUrl = [NSString splicingH5hostWithURL:url];
        vc.pageTitle = @"存钱罐服务协议";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kScrAdaptationW(10);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - Action
- (void)rollOutAction {
    [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_RollOutSingieSureClick];
    HSJRollOutConfirmController *VC = [HSJRollOutConfirmController new];
    VC.ids = @[self.planId];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - Setter / Getter / Lazy
- (UIView *)bottomView {
    if (_bottomView == nil) {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScrAdaptationW(121))];
        UIButton *btn = [UIButton new];
        [btn setTitle:@"转出" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = kHXBColor_FF7055_100;
        btn.titleLabel.font = kHXBFont_32;
        btn.layer.cornerRadius = 2;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(rollOutAction) forControlEvents:UIControlEventTouchUpInside];
        bottomView.hidden = YES;
        [bottomView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@kScrAdaptationW(15));
            make.right.equalTo(@kScrAdaptationW(-15));
            make.height.equalTo(@kScrAdaptationW(41));
            make.centerY.equalTo(bottomView);
        }];
        
        _bottomView = bottomView;
    }
    return _bottomView;
}

@end
