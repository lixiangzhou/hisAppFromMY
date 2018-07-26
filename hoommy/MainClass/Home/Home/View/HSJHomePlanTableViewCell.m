//
//  HSJHomePlanTableViewCell.m
//  hoommy
//
//  Created by HXB-C on 2018/7/23.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJHomePlanTableViewCell.h"
#import "HSJHomePlanView.h"

NSString *const HSJHomePlanCellIdentifier = @"HSJHomePlanCellIdentifier";

@interface HSJHomePlanTableViewCell()

@property (nonatomic, strong) HSJHomePlanView *planView;

@end

@implementation HSJHomePlanTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self.contentView addSubview:self.planView];
    [self.planView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
    }];
}

- (void)setPlanModel:(HSJHomePlanModel *)planModel {
    _planModel = planModel;
    self.planView.planModel = planModel;
}

- (HSJHomePlanView *)planView {
    if (!_planView) {
        _planView = [[HSJHomePlanView alloc] initWithFrame:CGRectZero];
    }
    return _planView;
}



@end
