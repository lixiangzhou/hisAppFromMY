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

@interface HSJRollOutController ()
@property (nonatomic, strong) HSJRollOutHeaderView *headerView;
@property (nonatomic, strong) HSJRollOutViewModel *viewModel;

@property (nonatomic, weak) UITableView *tableView;
@end

@implementation HSJRollOutController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"持有资产";
    self.viewModel = [HSJRollOutViewModel new];
    [self setUI];
    [self updateData];
}

#pragma mark - UI

- (void)setUI {
    self.isWhiteColourGradientNavigationBar = YES;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.headerView = [HSJRollOutHeaderView new];
    tableView.tableHeaderView = self.headerView;
    tableView.rowHeight = HSJRollOutCellHeight;
    [tableView registerClass:[HSJRollOutCell class] forCellReuseIdentifier:HSJRollOutCellIdentifier];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - Network
- (void)updateData {
    kWeakSelf
    [self.viewModel getAssets:^(BOOL isSuccess) {
        weakSelf.headerView.assetsModel = weakSelf.viewModel.assetsModel;
    }];
    
    [self.viewModel getPlans:^(BOOL isSuccess) {
        [weakSelf.tableView reloadData];
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
    return cell;
}

#pragma mark - Delegate External

#pragma mark -


#pragma mark - Action


#pragma mark - Setter / Getter / Lazy


#pragma mark - Helper


#pragma mark - Other


#pragma mark - Public

@end
