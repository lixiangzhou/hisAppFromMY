//
//  HXBBindPhoneTableViewCell.m
//  hoomxb
//
//  Created by caihongji on 2018/7/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HXBBindCardTableViewCell.h"
#import "HXBCustomTextField.h"
#import "HXBNsTimerManager.h"

@interface HXBBindCardTableViewCell()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) HXBCustomTextField* contentTf;
@property (nonatomic, strong) UIButton *codeBt;
@property (nonatomic, strong) UIImageView *lineImv;
@property (nonatomic, strong) HXBCustomTextField* prompTf;

@end

@implementation HXBBindCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        [self setupUI];
        [self setupConstraints];
    }
    
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLb = [[UILabel alloc] init];
    self.titleLb.textColor = kHXBFontColor_2D2F46_100;
    self.titleLb.font = kHXBFont_PINGFANGSC_REGULAR(14);
    [self.contentView addSubview:self.titleLb];
    
    [self.contentView addSubview:self.contentTf];
    
    self.codeBt = [[UIButton alloc] init];
    [self.codeBt setTitleColor:kHXBFontColor_FE7E5E_100 forState:UIControlStateNormal];
    self.codeBt.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
    self.codeBt.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.codeBt addTarget:self action:@selector(codeButtonAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.codeBt];
    
    [self.contentView addSubview:self.prompTf];
    
    self.lineImv = [[UIImageView alloc] init];
    self.lineImv.backgroundColor = kHXBColor_EEEEF5_100;
    [self.contentView addSubview:self.lineImv];
}

- (void)setupConstraints {

    [self.prompTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(0);
    }];
    
    [self.lineImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.prompTf.mas_top);
        make.left.equalTo(self.contentView).offset(kScrAdaptationW(15));
        make.right.equalTo(self.contentView).offset(-kScrAdaptationW(15));
        make.height.mas_equalTo(0.5);
    }];
    
    [self.contentTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb.mas_right).offset(kScrAdaptationW(15));
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.lineImv.mas_top);
        make.right.equalTo(self.codeBt.mas_left).offset(kScrAdaptationW(5));
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kScrAdaptationW(15));
        make.width.mas_equalTo(kScrAdaptationW(56));
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.lineImv.mas_top);
    }];
    
    [self.codeBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kScrAdaptationW(13.5));
        make.width.mas_equalTo(kScrAdaptationW(0));
        make.height.mas_equalTo(kScrAdaptationH(34));
        make.centerY.equalTo(self.titleLb.mas_centerY);
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == self.contentTf.textField) {
        if(self.cellModel.isBankCardNoField) {
            return [UITextField numberFormatTextField:textField shouldChangeCharactersInRange:range replacementString:string textFieldType:kBankCardNumberTextFieldType];
        }
    }
    return YES;
}

- (HXBCustomTextField *)contentTf {
    if(!_contentTf) {
        _contentTf = [[HXBCustomTextField alloc] init];
        _contentTf.isHiddenLeftImage = YES;
        _contentTf.font = kHXBFont_PINGFANGSC_REGULAR(14);
        _contentTf.textColor = kHXBFontColor_333333_100;
        _contentTf.isHidenLine = YES;
        _contentTf.delegate = self;
        
        kWeakSelf
        _contentTf.block = ^(NSString *text1) {
            weakSelf.cellModel.text = text1;
            if(weakSelf.textChange) {
                weakSelf.textChange(weakSelf.indexPath, text1);
            }
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

- (HXBCustomTextField *)prompTf {
    if(!_prompTf) {
        _prompTf = [[HXBCustomTextField alloc] init];
        _prompTf.font = kHXBFont_PINGFANGSC_REGULAR(12);
        _prompTf.isHidenLine = YES;
        _prompTf.hidden = YES;
    }
    return _prompTf;
}

- (void)codeButtonAct:(UIButton*)button {
   
    if(self.checkCodeAct) {
        self.checkCodeAct(self.indexPath);
    }
}

- (void)setIsKeepKeyboardPop:(BOOL)isKeepKeyboardPop {
    _isKeepKeyboardPop = isKeepKeyboardPop;
    if(isKeepKeyboardPop) {
        [self.contentTf.textField becomeFirstResponder];
    }
}

- (void)setCellModel:(HXBBindCardCellModel *)cellModel {
    _cellModel = cellModel;
    
    self.titleLb.text = cellModel.title;
    self.contentTf.placeholder = cellModel.placeText;
    self.contentTf.text = cellModel.text;
    _contentTf.keyboardType = UIKeyboardTypeDecimalPad;
    _contentTf.limitStringLength = cellModel.limtTextLenght;
    
    if(cellModel.rightButtonText) {
        [self.codeBt setTitle:cellModel.rightButtonText forState:UIControlStateNormal];
        [self.codeBt mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScrAdaptationW(90));
        }];
        self.codeBt.hidden = NO;
    }
    else{
        [self.codeBt mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        self.codeBt.hidden = YES;
    }
    
    if(cellModel.isCanEdit) {
        self.contentTf.userInteractionEnabled = YES;
    }
    else{
        self.contentTf.userInteractionEnabled = NO;
    }
}

- (void)bindPrompInfo:(NSString*)imgName prompText:(NSString*)text {
    if(imgName.length > 0) {
        [self.prompTf mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(37);
        }];
        self.prompTf.hidden = NO;
    }
    else{
        self.prompTf.hidden = YES;
        [self.prompTf mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    self.prompTf.leftImageView.svgImageString = imgName;
    self.prompTf.placeholder = text;
}

//验证码按钮是否可用
- (void)enableCheckButton:(BOOL)isEnable {
    self.codeBt.enabled = isEnable;
    if(isEnable) {
        [self.codeBt setTitleColor:kHXBFontColor_FF413C_100 forState:UIControlStateNormal];
        [self.codeBt setTitleColor:kHXBFontColor_FF413C_100 forState:UIControlStateHighlighted];
    }
    else {
        [self.codeBt setTitleColor:kHXBFontColor_9295A2_100 forState:UIControlStateNormal];
        [self.codeBt setTitleColor:kHXBFontColor_9295A2_100 forState:UIControlStateHighlighted];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
