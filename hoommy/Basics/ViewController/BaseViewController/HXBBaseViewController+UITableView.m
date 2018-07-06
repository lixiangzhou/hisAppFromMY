//
//  HXBBaseViewController+UITableView.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HXBBaseViewController+UITableView.h"

@implementation HXBBaseViewController (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    cell.backgroundColor = [UIColor grayColor];
    cell.textLabel.text = @"asdfasdfasdfadsf";
    return cell;
}

@end
