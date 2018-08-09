//
//  HSJBuyHeadView.m
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBuyHeadView.h"
#import "HXBCustomTextField.h"

@interface HSJBuyHeadView()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *prompBackGroundImv;
@property (nonatomic, strong) UILabel *prompLb;

@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UILabel *inputTitleLb;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) HXBCustomTextField *contentTf;
@property (nonatomic, strong) UIImageView *lineImv;

@end

@implementation HSJBuyHeadView

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
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.prompBackGroundImv];
    [self addSubview:self.inputView];
}

- (void)setupConstraints {
    //self
    [self.prompBackGroundImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(kScrAdaptationH(30));
    }];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.prompBackGroundImv.mas_bottom).offset(kScrAdaptationH(36));
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-kScrAdaptationH(15));
    }];
    
    //prompBackGroundImv
    [self.prompLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.prompBackGroundImv).offset(kScrAdaptationW(15));
        make.top.bottom.equalTo(self.prompBackGroundImv);
    }];
    
    //inputView
    [self.inputTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputView).offset(kScrAdaptationW(15));
        make.top.equalTo(self.inputView);
        make.height.mas_equalTo(kScrAdaptationH(15));
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTitleLb);
        make.top.equalTo(self.inputTitleLb.mas_bottom).offset(kScrAdaptationH(30));
        make.width.mas_equalTo(kScrAdaptationW(15));
        make.height.mas_equalTo(kScrAdaptationH(25));
    }];
    [self.contentTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb.mas_right).offset(kScrAdaptationW(10));
        make.top.height.equalTo(self.titleLb);
        make.right.equalTo(self.inputView).offset(-kScrAdaptationW(15));
    }];
    [self.lineImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb);
        make.top.equalTo(self.titleLb.mas_bottom).offset(kScrAdaptationH(10));
        make.right.equalTo(self.contentTf);
        make.height.mas_equalTo(0.5);
    }];
}

- (UIImageView *)prompBackGroundImv {
    if(!_prompBackGroundImv) {
        _prompBackGroundImv = [[UIImageView alloc] init];
        _prompBackGroundImv.backgroundColor = kHXBColor_FCF4E5_100;
        
        self.prompLb = [[UILabel alloc] init];
        self.prompLb.textColor = kHXBFontColor_C5AB71_100;
        self.prompLb.font = kHXBFont_26;
        [_prompBackGroundImv addSubview:self.prompLb];
    }
    return _prompBackGroundImv;
}

- (UIView *)inputView {
    if(!_inputView) {
        _inputView = [[UIView alloc] init];
        
        self.inputTitleLb = [[UILabel alloc] init];
        self.inputTitleLb.text = @"转入金额(元)";
        self.inputTitleLb.textColor = kHXBFontColor_333333_100;
        self.inputTitleLb.font = kHXBFont_Bold_PINGFANGSC_REGULAR(15);
        [_inputView addSubview:self.inputTitleLb];
        
        self.titleLb = [[UILabel alloc] init];
        self.titleLb.text = @"¥";
        self.titleLb.textColor = kHXBFontColor_333333_100;
        self.titleLb.font = kHXBFont_Bold_PINGFANGSC_REGULAR(25);
        [_inputView addSubview:self.titleLb];
        
        [_inputView addSubview:self.contentTf];
        
        self.lineImv = [[UIImageView alloc] init];
        self.lineImv.backgroundColor = kHXBColor_ECECEC_100;
        [_inputView addSubview:self.lineImv];
        
    }
    return _inputView;
}

- (HXBCustomTextField *)contentTf {
    if(!_contentTf) {
        _contentTf = [[HXBCustomTextField alloc] init];
        _contentTf.isHiddenLeftImage = YES;
        _contentTf.font = kHXBFont_Bold_PINGFANGSC_REGULAR(25);
        _contentTf.textColor = kHXBFontColor_333333_100;
        _contentTf.placeholder = @"1000元起投，100元递增";
        _contentTf.isHidenLine = YES;
        _contentTf.limitStringLength = 9;
        _contentTf.keyboardType = UIKeyboardTypeNumberPad;
        _contentTf.delegate = self;
        
        kWeakSelf
        _contentTf.block = ^(NSString *text1) {
            [weakSelf textChange:text1];
        };
        
        _contentTf.keyBoardChange = ^(BOOL isEditState) {
            if(isEditState) {
                weakSelf.lineImv.backgroundColor = kHXBColor_F55151_100;
            }
            else{
                weakSelf.lineImv.backgroundColor = kHXBSpacingLineColor_DDDDDD_100;
            }
        };
    }
    
    return _contentTf;
}

- (void)textChange:(NSString*)text {
    _inputMoney = text;
    if(self.textChange) {
        self.textChange(text);
    }
}

- (void)setAddUpLimitMoney:(float)addUpLimitMoney {
    _addUpLimitMoney = addUpLimitMoney;
    
    NSString *tempStr = [NSString hxb_getPerMilWithIntegetNumber:addUpLimitMoney];
    self.prompLb.text = [NSString stringWithFormat:@"可转入上限：%@", tempStr];
}

- (void)setIsKeepKeyboard:(BOOL)isKeepKeyboard {
    _isKeepKeyboard = isKeepKeyboard;
    
    if(self.contentTf.textField.isFirstResponder) {
        [self.contentTf becomeFirstResponder];
    }
}

- (void)setAddCondition:(NSString *)addCondition {
    _addCondition = [addCondition copy];
    
    self.contentTf.placeholder = addCondition;
}

- (void)setInputMoney:(NSString *)inputMoney {
    _inputMoney = inputMoney;
    
    self.contentTf.text = inputMoney;
}

- (void)setEnableContentTf:(BOOL)enableContentTf {
    _enableContentTf = enableContentTf;
    
    self.contentTf.userInteractionEnabled = enableContentTf;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_BuyAmountTextFieldClick];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
