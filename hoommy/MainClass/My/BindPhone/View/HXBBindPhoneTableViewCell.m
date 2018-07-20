//
//  HXBBindPhoneTableViewCell.m
//  hoomxb
//
//  Created by caihongji on 2018/7/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HXBBindPhoneTableViewCell.h"
#import "HXBCustomTextField.h"
#import "HXBNsTimerManager.h"

@interface HXBBindPhoneTableViewCell()

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) HXBCustomTextField* contentTf;
@property (nonatomic, strong) UIButton *codeBt;
@property (nonatomic, strong) UILabel *codeLb;
@property (nonatomic, strong) UIImageView *topLineImv;
@property (nonatomic, strong) UIImageView *lineImv;

@property (nonatomic, strong) HXBNsTimerManager* timeManager;

@end

@implementation HXBBindPhoneTableViewCell

- (void)dealloc
{
    if(self.timeManager.isTimerWorking) {
        [self.timeManager stopTimer];
    }
}

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
    [self.codeBt setTitleColor:kHXBFontColor_FF413C_100 forState:UIControlStateNormal];
    [self.codeBt setTitleColor:kHXBFontColor_FF413C_100 forState:UIControlStateHighlighted];
    self.codeBt.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(13);
    [self.codeBt addTarget:self action:@selector(codeButtonAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.codeBt];
    [self enableCheckButton:NO];
    
    self.codeLb = [[UILabel alloc] init];
    self.codeLb.textColor = kHXBFontColor_9295A2_100;
    self.codeLb.font = kHXBFont_PINGFANGSC_REGULAR(12);
    self.codeLb.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.codeLb];
    
    self.lineImv = [[UIImageView alloc] init];
    self.lineImv.backgroundColor = kHXBColor_EEEEF5_100;
    [self.contentView addSubview:self.lineImv];
    
    self.topLineImv = [[UIImageView alloc] init];
    self.topLineImv.backgroundColor = kHXBColor_EEEEF5_100;
    [self.contentView addSubview:self.topLineImv];
}

- (void)setupConstraints {
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kScrAdaptationW(15));
        make.width.mas_equalTo(kScrAdaptationW(58));
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.codeBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kScrAdaptationW(13.5));
        make.width.mas_equalTo(kScrAdaptationW(90));
        make.height.mas_equalTo(kScrAdaptationH(34));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb.mas_right).offset(kScrAdaptationW(13));
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.codeBt.mas_left).offset(kScrAdaptationW(5));
    }];
    
    [self.codeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.codeBt);
    }];
    
    [self.lineImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kScrAdaptationW(15));
        make.right.equalTo(self.contentView).offset(-kScrAdaptationW(15));
        make.height.mas_equalTo(0.5);
    }];
    
    [self.topLineImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

- (HXBCustomTextField *)contentTf {
    if(!_contentTf) {
        _contentTf = [[HXBCustomTextField alloc] init];
        _contentTf.isHiddenLeftImage = YES;
        _contentTf.font = kHXBFont_PINGFANGSC_REGULAR(14);
        _contentTf.textColor = kHXBFontColor_333333_100;
        _contentTf.isHidenLine = YES;
        
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

- (void)codeButtonAct:(UIButton*)button {
   
    if(self.checkCodeAct) {
        self.checkCodeAct(self.indexPath);
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    if(indexPath.row != 0) {
        self.topLineImv.hidden = YES;
    }
}

- (void)setCellModel:(HXBBindPhoneCellModel *)cellModel {
    _cellModel = cellModel;
    
    self.titleLb.text = cellModel.title;
    self.contentTf.placeholder = cellModel.placeText;
    self.contentTf.text = cellModel.text;
    _contentTf.keyboardType = UIKeyboardTypeDecimalPad;
    _contentTf.limitStringLength = cellModel.limtTextLenght;
    
    if(cellModel.isShowCheckCodeView) {
        [self.codeBt mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScrAdaptationW(90));
        }];
        if(self.timeManager.isTimerWorking) {
            self.codeLb.hidden = NO;
            self.codeBt.hidden = YES;
        }
        else {
            self.codeLb.hidden = YES;
            self.codeBt.hidden = NO;
            [self.codeBt setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
    }
    else{
        [self.codeBt mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        self.codeLb.hidden = YES;
        self.codeBt.hidden = YES;
    }
    
    if(cellModel.isCanEdit) {
        self.contentTf.userInteractionEnabled = YES;
    }
    else{
        self.contentTf.userInteractionEnabled = NO;
    }
}

//校验码倒计时
- (void)checkCodeCountDown:(BOOL)isStart {
    self.codeLb.hidden = NO;
    self.codeBt.hidden = YES;
    if(isStart) {
        kWeakSelf
        self.timeManager = [HXBNsTimerManager createTimer:1 startSeconds:60 countDownTime:YES notifyCall:^(NSString *times) {
            NSString* codeLableText = [NSString stringWithFormat:@"%@s", times];
            self.codeLb.text = codeLableText;
            
            if(!self.timeManager.isTimerWorking) {
                weakSelf.codeLb.hidden = YES;
                weakSelf.codeBt.hidden = NO;
            }
        }];
        [self.timeManager startTimer];
    }
    else{
        [self.timeManager stopTimer];
        self.codeLb.hidden = YES;
        self.codeBt.hidden = NO;
    }
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
