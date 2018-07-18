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
    
    self.viewModel = [HSJRollOutViewModel new];
    [self setUI];  
}

#pragma mark - UI

- (void)setUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.headerView = [HSJRollOutHeaderView new];
    tableView.tableHeaderView = self.headerView;
    [tableView registerClass:[HSJRollOutCell class] forCellReuseIdentifier:HSJRollOutCellIdentifier];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - Network


#pragma mark - Delegate Internal

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSJRollOutCell *cell = [tableView dequeueReusableCellWithIdentifier:HSJRollOutCellIdentifier forIndexPath:indexPath];
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
