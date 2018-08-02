//
//  HSJMyOperateListCell.m
//  hoommy
//
//  Created by hxb on 2018/8/2.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJMyOperateListCell.h"
#import <UIImageView+WebCache.h>

@interface HSJMyOperateListCell()

@property (nonatomic, strong) UIImageView *leftImageView;

@end

@implementation HSJMyOperateListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.accessoryType = UITableViewCellAccessoryNone;
        [self.contentView addSubview:self.leftImageView];
        [self setupSubViewFrame];
    }
    return self;
}

- (void)setupSubViewFrame
{
    kWeakSelf
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(kScrAdaptationH750(50));
        make.left.equalTo(weakSelf.contentView).offset(kScrAdaptationW750(30));
        make.right.equalTo(weakSelf.contentView).offset(kScrAdaptationW750(-30));
        make.height.equalTo(@kScrAdaptationH750(180));
    }];
    
}

-(void)setImageName:(NSString *)imageName {
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
}


-(UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _leftImageView.layer.cornerRadius = 4;
        _leftImageView.layer.masksToBounds = YES;
    }
    return _leftImageView;
}

@end
