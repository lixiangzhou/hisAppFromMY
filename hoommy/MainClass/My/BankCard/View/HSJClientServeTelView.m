//
//  HSJClientServeTelView.m
//  hoommy
//
//  Created by caihongji on 2018/7/16.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJClientServeTelView.h"

@interface HSJClientServeTelView()

@property (nonatomic, strong) UIButton *clientBtn;
@property (nonatomic, strong) UIImageView *clientImv;
@property (nonatomic, strong) UILabel *clientLb;

@property (nonatomic, strong) UILabel *telLb;
@end

@implementation HSJClientServeTelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupConstraints];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.clientBtn];
    
    self.telLb = [[UILabel alloc] init];
    self.telLb.textColor = kHXBFontColor_7F85A1_100;
    self.telLb.font = kHXBFont_PINGFANGSC_REGULAR(10);
    self.telLb.textAlignment = NSTextAlignmentCenter;
    self.telLb.text = @"客服电话时间：工作日 9:00-18:00 ";
    [self addSubview:self.telLb];
}

- (void)setupConstraints {
    //self约束
    [self.clientBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.mas_equalTo(kScrAdaptationW(114));
        make.height.mas_equalTo(kScrAdaptationH(35));
        make.centerX.equalTo(self);
    }];
    
    [self.telLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.clientBtn.mas_bottom).offset(kScrAdaptationH(12));
    }];
    
    //clientBtn约束
    [self.clientImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.clientBtn).offset(kScrAdaptationW(15));
        make.width.height.mas_equalTo(kScrAdaptationW(17));
        make.centerY.equalTo(self.clientBtn);
    }];
    
    [self.clientLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.clientImv.mas_right).offset(kScrAdaptationW(6));
        make.centerY.equalTo(self.clientBtn);
    }];
}

- (UIButton *)clientBtn {
    if(!_clientBtn) {
        _clientBtn = [[UIButton alloc] init];
        _clientBtn.layer.borderWidth = 0.5;
        _clientBtn.layer.borderColor = kHXBColor_7F85A1_100.CGColor;
        [_clientBtn addTarget:self action:@selector(clientButtonAct:) forControlEvents:UIControlEventTouchUpInside];
        
        self.clientImv = [[UIImageView alloc] init];
        self.clientImv.image = [UIImage imageNamed:@"icon_service"];
        [_clientBtn addSubview:self.clientImv];
        
        self.clientLb = [[UILabel alloc] init];
        self.clientLb.textColor = kHXBFontColor_7F85A1_100;
        self.clientLb.font = kHXBFont_PINGFANGSC_REGULAR(12);
        self.clientLb.text = @"红小宝客服";
        [_clientBtn addSubview:self.clientLb];
    }
    
    return _clientBtn;
}

- (void)clientButtonAct:(UIButton*)button {
    if(self.callTelNumber) {
        self.callTelNumber();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.clientBtn.layer.cornerRadius = self.clientBtn.height/2;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
