//
//  HSJBuySectionHeadView.m
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBuySectionHeadView.h"

@interface HSJBuySectionHeadView()

@property (nonatomic, strong) UIView *colorBackGroundView;
@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation HSJBuySectionHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self) {
        [self setupUI];
        [self setupConstraints];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor greenColor];
    
    self.colorBackGroundView = [[UIView alloc] init];
    self.colorBackGroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.colorBackGroundView];
    
    self.titleLb = [[UILabel alloc] init];
    self.titleLb.textColor = kHXBFontColor_333333_100;
    self.titleLb.font = kHXBFont_Bold_PINGFANGSC_REGULAR(15);
    [self.colorBackGroundView addSubview:self.titleLb];
}

- (void)setupConstraints {
    //self
    [self.colorBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kScrAdaptationH(10));
        make.left.right.bottom.equalTo(self);
    }];
    
    //backgroundView
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.colorBackGroundView);
        make.left.equalTo(self.colorBackGroundView).offset(kScrAdaptationW(15));
    }];
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    
    self.titleLb.text = title;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
