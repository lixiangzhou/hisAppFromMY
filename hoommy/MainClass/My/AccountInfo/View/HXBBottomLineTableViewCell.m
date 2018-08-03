//
//  HXBBottomLineTableViewCell.m
//  hoomxb
//
//  Created by HXB-C on 2017/8/29.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBottomLineTableViewCell.h"

@interface HXBBottomLineTableViewCell ()

@property (nonatomic, strong) UIView *line;

@end

@implementation HXBBottomLineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = COR12;
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.offset(kHXBDivisionLineHeight);
        }];
        
    }
    return self;
}

- (void)setHiddenLine:(BOOL)hiddenLine
{
    _hiddenLine = hiddenLine;
    self.line.hidden = hiddenLine;
}

- (void)setIsLineRight:(BOOL)isLineRight {
    if (_hiddenLine) {
        return;
    }
    self.line.backgroundColor = RGB(238, 238, 245);
    kWeakSelf
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(weakSelf.textLabel);
        make.height.equalTo(@0.5f);
    }];
}


@end
