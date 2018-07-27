//
//  HSJRollOutController.m
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJRollOutController.h"
#import "HSJRollOutHeaderView.h"
#import "HSJRollOutViewModel.h"
#import "HSJRollOutCell.h"
#import "HSJRollOutPlanDetailController.h"
#import "HSJRollOutConfirmController.h"

@interface HSJRollOutController ()
@property (nonatomic, strong) HSJRollOutHeaderView *headerView;
@property (nonatomic, strong) HSJRollOutViewModel *viewModel;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIButton *batchBtn;

@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UILabel *rollOutLabel;
@property (nonatomic, weak) UIButton *rollOutBtn;
@end

@implementation HSJRollOutController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"持有资产";
    
    self.viewModel = [HSJRollOutViewModel new];
    [self setUI];
    [self updateData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:kHXBNotification_RefreshAccountPlanList object:nil];
}

#pragma mark - UI

- (void)setUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.headerView = [HSJRollOutHeaderView new];
    tableView.tableHeaderView = self.headerView;
    tableView.rowHeight = kScrAdaptationW(84);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[HSJRollOutCell class] forCellReuseIdentifier:HSJRollOutCellIdentifier];
    [self.safeAreaView addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView addSubview:self.noDataView];
    
    UIButton *batchBtn = [[UIButton alloc] init];
    [batchBtn setTitleColor:kHXBColor_488CFF_100 forState:UIControlStateNormal];
    [batchBtn setTitle:@"批量转出" forState:UIControlStateNormal];
    [batchBtn setTitle:@"       取消" forState:UIControlStateSelected];
    batchBtn.titleLabel.font = kHXBFont_28;
    [batchBtn addTarget:self action:@selector(batchProcess) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:batchBtn];
    self.batchBtn = batchBtn;

    // 底部视图
    UIView *bottomView = [UIView new];
    [self.safeAreaView addSubview:bottomView];
    self.bottomView = bottomView;

    UIView *topLine = [UIView new];
    topLine.backgroundColor = kHXBColor_ECECEC_100;
    [bottomView addSubview:topLine];

    UILabel *rollOutLabel = [UILabel new];
    rollOutLabel.text = @"待转出金额0.00元";
    rollOutLabel.font = kHXBFont_28;
    rollOutLabel.textColor = kHXBColor_333333_100;
    [bottomView addSubview:rollOutLabel];
    self.rollOutLabel = rollOutLabel;

    UIButton *rollOutBtn = [UIButton new];
    [rollOutBtn setTitle:@"转出" forState:UIControlStateNormal];
    [rollOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rollOutBtn.backgroundColor = kHXBColor_FF7055_100;
    rollOutBtn.layer.cornerRadius = 2;
    rollOutBtn.layer.masksToBounds = YES;
    [rollOutBtn addTarget:self action:@selector(rollOutAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:rollOutBtn];
    self.rollOutBtn = rollOutBtn;

    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.safeAreaView);
    }];

    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableView.mas_bottom);
        make.right.left.bottom.equalTo(self.safeAreaView);
        make.height.equalTo(@0);
    }];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bottomView);
        make.height.equalTo(@kScrAdaptationW(0.5));
    }];

    [rollOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(bottomView);
        make.bottom.equalTo(rollOutBtn.mas_top);
    }];

    [rollOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@kScrAdaptationW(15));
        make.bottom.right.equalTo(@kScrAdaptationW(-15));
        make.height.equalTo(@kScrAdaptationW(41));
    }];
    
    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView);
        make.centerY.equalTo(self.tableView).offset(self.headerView.height * 0.5);
    }];
}

#pragma mark - Network
- (void)updateData {
    kWeakSelf
    [self.viewModel getAssets:^(BOOL isSuccess) {
        weakSelf.headerView.assetsModel = weakSelf.viewModel.assetsModel;
        weakSelf.noDataView.hidden = weakSelf.viewModel.dataSource.count > 0;
    }];
    
    [self getListData:YES];
}

- (void)getListData:(BOOL)isNew {
    kWeakSelf
    [self.viewModel getPlans:isNew resultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.tableView reloadData];
            if (weakSelf.viewModel.footerType == HSJRefreshFooterTypeMoreData) {
                [weakSelf.tableView.mj_footer endRefreshing];
                weakSelf.tableView.footerWithRefreshBlock = ^(UIScrollView *scrollView) {
                    [weakSelf getListData:NO];
                };
            } else if (weakSelf.viewModel.footerType == HSJRefreshFooterTypeNoMoreData) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
                weakSelf.tableView.mj_footer = nil;
            }
        }
    }];
}



#pragma mark - Delegate Internal

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSJRollOutCell *cell = [tableView dequeueReusableCellWithIdentifier:HSJRollOutCellIdentifier forIndexPath:indexPath];
    cell.viewModel = self.viewModel.dataSource[indexPath.row];

    kWeakSelf
    cell.rollOutBlock = ^(HSJRollOutCellViewModel *viewModel) {
        HSJRollOutConfirmController *VC = [HSJRollOutConfirmController new];
        VC.ids = @[viewModel.model.id];
        [weakSelf.navigationController pushViewController:VC animated:YES];
    };

    cell.selectBlock = ^(HSJRollOutCellViewModel *viewModel) {
        [weakSelf updateAmount];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.editing == NO) {
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_RollOutSingieClick];
        HSJRollOutPlanDetailController *VC = [HSJRollOutPlanDetailController new];
        HSJRollOutCellViewModel *vm = self.viewModel.dataSource[indexPath.row];
        VC.planId = vm.model.id;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - Action
- (void)batchProcess {
    if (self.batchBtn.selected == NO) {
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_RollOutBatchClick];
    }
    self.batchBtn.selected = !self.batchBtn.isSelected;
    
    self.viewModel.editing = self.batchBtn.selected;
    
    [self.tableView reloadData];
    self.bottomView.hidden = !self.viewModel.editing;
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.viewModel.editing ? 90 : 0));
    }];
    
    [self updateAmount];
}
     
 - (void)rollOutAction {
     [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_RollOutBatchSureClick];
     if (self.viewModel.hasQuitPlans) {
         if (self.viewModel.selectedIds.count == 0) {
             [HxbHUDProgress showTextWithMessage:@"请选择要转出的内容"];
         } else {
             HSJRollOutConfirmController *VC = [HSJRollOutConfirmController new];
             VC.ids = self.viewModel.selectedIds;
             [self.navigationController pushViewController:VC animated:YES];
         }
     } else {
         [HxbHUDProgress showTextWithMessage:@"当前无可转出内容"];
     }
     
 }

#pragma mark - Helper
 - (void)updateAmount {
     [self.viewModel calAmount];
     self.rollOutLabel.text = self.viewModel.amount;
 }


@end
