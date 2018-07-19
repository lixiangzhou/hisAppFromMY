//
//  HSJRollOutCell.m
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJRollOutCell.h"

NSString *const HSJRollOutCellIdentifier = @"HSJRollOutCellIdentifier";
const CGFloat HSJRollOutCellHeight = 44;

@interface HSJRollOutCell ()

@end

@implementation HSJRollOutCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setUI];
    }
    return self;
}

#pragma mark - UI

- (void)setUI {
    
}

#pragma mark - Action


#pragma mark - Setter / Getter / Lazy


#pragma mark - Helper


#pragma mark - Other


#pragma mark - Public

@end
