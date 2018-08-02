//
//  HXBMyHomeViewCell.m
//  hoomxb
//
//  Created by HXB-C on 2017/8/7.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBMyHomeViewCell.h"

@interface HXBMyHomeViewCell()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *leftImageView;

@end


@implementation HXBMyHomeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.descLab];
        [self.contentView addSubview:self.leftImageView];
        [self setupSubViewFrame];
    }
    return self;
}

- (void)setupSubViewFrame
{
    kWeakSelf
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.textLabel);
        make.left.equalTo(@kScrAdaptationW750(39));
        make.width.height.equalTo(@kScrAdaptationW750(34));
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImageView.mas_right).offset(kScrAdaptationW750(14));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf.textLabel);
        make.height.offset(kScrAdaptationH750(1.0f));
        
    }];
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.textLabel);
        make.height.equalTo(@kScrAdaptationH750(24));
        make.right.equalTo(weakSelf.contentView.mas_right).offset(kScrAdaptationW750(-10));
    }];
}

- (void)setDesc:(id)desc{
    if ([desc isKindOfClass:[NSString class]]) {
        self.descLab.text = desc;
    }else if ([desc isKindOfClass:[NSAttributedString class]]){
        self.descLab.attributedText = desc;
    }
}
-(void)setImageName:(NSString *)imageName {
    self.leftImageView.image = [UIImage imageNamed:imageName];
}
- (void)setIsShowLine:(BOOL)isShowLine
{
    _isShowLine = isShowLine;
    self.lineView.hidden = !isShowLine;
}

-(UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _leftImageView;
}
- (UILabel *)descLab{
    if (!_descLab) {
        _descLab = [[UILabel alloc]initWithFrame:CGRectMake(kScrAdaptationW750(750-66-300), kScrAdaptationH750(38), kScrAdaptationW750(300), kScrAdaptationH750(24))];
        _descLab.font = kHXBFont_PINGFANGSC_REGULAR_750(28);
        _descLab.textColor = kHXBColor_333333_100;
        _descLab.textAlignment = NSTextAlignmentRight;
    }
    return _descLab;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBA(244, 243, 248, 1);
        _lineView.hidden = YES;
    }
    return _lineView;
}


@end
