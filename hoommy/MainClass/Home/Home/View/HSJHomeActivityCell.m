//
//  HSJHomeActivityCell.m
//  hoommy
//
//  Created by HXB-C on 2018/7/23.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJHomeActivityCell.h"
#import <UIImageView+WebCache.h>


NSString *const HSJHomeActivityCellIdentifier = @"HSJHomeActivityCellIdentifier";

@interface HSJHomeActivityCell()

@property (nonatomic, strong) UIView *segmentLineView;

@property (nonatomic, strong) UIImageView *h5ImageView;

@end

@implementation HSJHomeActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.segmentLineView];
    [self.contentView addSubview:self.h5ImageView];
    [self.segmentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.offset(kScrAdaptationH750(20));
    }];
    [self.h5ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.bottom.equalTo(self.segmentLineView.mas_top);
    }];
    self.h5ImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setPlanModel:(HSJHomePlanModel *)planModel {
    _planModel = planModel;
    [self.h5ImageView sd_setImageWithURL:[NSURL URLWithString:planModel.image] placeholderImage:[UIImage imageNamed:@"HomeActivity"]];
}

- (UIView *)segmentLineView {
    if (!_segmentLineView) {
        _segmentLineView = [[UIView alloc] init];
        _segmentLineView.backgroundColor = kHXBBackgroundColor;
    }
    return _segmentLineView;
}

- (UIImageView *)h5ImageView {
    if (!_h5ImageView) {
        _h5ImageView = [[UIImageView alloc] init];
    }
    return _h5ImageView;
}

@end
