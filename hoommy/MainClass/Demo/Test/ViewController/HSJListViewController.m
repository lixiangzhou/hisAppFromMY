//
//  HSJListViewController.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJListViewController.h"

@interface HSJListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HSJListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"列表视图";
    [self setUpScrollFreshBlock:self.tableView];
    self.tableView.freshOption = ScrollViewFreshOptionDownPull;
    
}

- (void)headerRefreshAction:(UIScrollView *)scrollView {
    self.tableView.freshOption = ScrollViewFreshOptionAll;
    [scrollView endRefresh:NO];
}

- (void)footerRefreshAction:(UIScrollView *)scrollView {
    [scrollView endRefresh:YES];
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
