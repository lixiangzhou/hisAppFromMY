//
//  HXBBindPhoneTableViewCell.m
//  hoomxb
//
//  Created by caihongji on 2018/7/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HXBBindPhoneTableViewCell.h"

@interface HXBBindPhoneTableViewCell()

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *codeBt;
@property (nonatomic, strong) UILabel *codeLb;
@property (nonatomic, strong) UIImageView *lineImv;

@end

@implementation HXBBindPhoneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
