//
//  HXBBankView.m
//  hoomxb
//
//  Created by HXB-C on 2017/8/10.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBankView.h"
#import "HXBBankCardViewModel.h"

@interface HXBBankView ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIButton *limitBtn; //限额按钮

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *bankName;

@property (nonatomic, strong) UILabel *realName;

@property (nonatomic, strong) UILabel *bankNum;

@property (nonatomic, strong) UILabel *bankTip;

@property (nonatomic, strong) UIButton *unBindBtn;

@property (nonatomic, strong) CALayer *colorLayer;


@property (nonatomic, strong) HXBBankCardViewModel *viewModel;

@end

@implementation HXBBankView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 345, kScrAdaptationH(150))];
//        self.backImageView.image = [UIImage imageNamed:@"hxb_card_bg"];
//        self.backImageView.backgroundColor = [UIColor orangeColor];
        
        self.backImageView.userInteractionEnabled = YES;
        [self addSubview:self.backImageView];
        
        //
        self.limitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScrAdaptationH(170), 112, kScrAdaptationH(30))];
        [self.limitBtn setTitleColor:kHXBFontColor_FE7E5E_100 forState:UIControlStateNormal];
        [self.limitBtn setTitleColor:kHXBFontColor_FE7E5E_100 forState:UIControlStateHighlighted];
        self.limitBtn.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
        [self.limitBtn setTitle:@"查看其他银行限额" forState:UIControlStateNormal];
        [self.limitBtn addTarget:self action:@selector(limitButtonAct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.limitBtn];

        [self.backImageView addSubview:self.iconView];
        [self.backImageView addSubview:self.bankName];
//        [self.backImageView addSubview:self.realName];
        [self.backImageView addSubview:self.bankNum];
        [self.backImageView addSubview:self.bankTip];
        [self.backImageView addSubview:self.unBindBtn];
        [self setupSubViewFrame];
        [self loadBankData];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.colorLayer removeFromSuperlayer];
    self.colorLayer = [HSJCALayerTool gradualChangeColor:kHXBColor_FE7E5E_100 toColor:kHXBColor_FFE6A4_100 cornerRadius:4 layerSize:self.backImageView.size];
    [self.backImageView.layer insertSublayer:self.colorLayer atIndex:0];
}

- (void)setupSubViewFrame
{
    //self
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.offset(kScrAdaptationW(150));
    }];
    [self.limitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backImageView.mas_bottom).offset(kScrAdaptationW(10));
        make.left.equalTo(self.backImageView);
        make.height.offset(kScrAdaptationW(30));
        make.width.offset(kScrAdaptationW(115));
    }];
    //backImageView
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kScrAdaptationW(25));
        make.top.equalTo(self).offset(kScrAdaptationH(18));
        make.width.offset(kScrAdaptationW(30));
        make.height.offset(kScrAdaptationW(30));
    }];
    [self.bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(kScrAdaptationW(10));
        make.top.equalTo(self.iconView);
        make.height.offset(kScrAdaptationH(32));
    }];
//    [self.realName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bankName.mas_left);
//        make.top.equalTo(self.bankName.mas_bottom).offset(kScrAdaptationH(4));
//        make.height.offset(kScrAdaptationH(16));
//    }];
    [self.bankNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_left);
        make.right.equalTo(self).offset(-kScrAdaptationH(30));
        make.top.equalTo(self.iconView.mas_bottom).offset(kScrAdaptationH(22));
        make.height.offset(kScrAdaptationH(31));
    }];
    [self.bankTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_left);
        make.top.equalTo(self.bankNum.mas_bottom).offset(kScrAdaptationH(15));
        make.right.equalTo(self).offset(-kScrAdaptationH(30));
        make.height.offset(kScrAdaptationH(16));
    }];
    [self.unBindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backImageView).offset(-kScrAdaptationW(15));
        make.top.equalTo(self.backImageView).offset(kScrAdaptationH(18));
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(24);
    }];
}

- (void)limitButtonAct:(UIButton*)button {
    if(self.bankCardListAct) {
        self.bankCardListAct();
    }
}

- (void)loadBankData
{
    kWeakSelf
    [self.viewModel requestBankDataResultBlock:^(id responseData, NSError *erro) {
        if(!erro) {
            //设置绑卡信息
            weakSelf.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_white", weakSelf.viewModel.bankCardModel.bankCode]];
            weakSelf.bankName.text = weakSelf.viewModel.bankCardModel.bankType;
            weakSelf.realName.text = [NSString stringWithFormat:@"持卡人：%@",[weakSelf.viewModel.bankCardModel.name replaceStringWithStartLocation:0 lenght:weakSelf.viewModel.bankCardModel.name.length - 1]];
            if (weakSelf.viewModel.bankCardModel.name.length > 4) {
                weakSelf.realName.text = [NSString stringWithFormat:@"持卡人：***%@",[weakSelf.viewModel.bankCardModel.name substringFromIndex:weakSelf.viewModel.bankCardModel.name.length - 1]];
            }
            weakSelf.bankNum.textAlignment = NSTextAlignmentCenter;
            NSString *str = [weakSelf.viewModel.bankCardModel.cardId stringByReplacingOccurrencesOfString:[weakSelf.viewModel.bankCardModel.cardId substringWithRange:NSMakeRange(0,weakSelf.viewModel.bankCardModel.cardId.length - 4)]withString:@"****  ****  ****  "];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            [style setLineBreakMode:NSLineBreakByCharWrapping];
            NSDictionary *attribute = @{NSFontAttributeName: kHXBFont_PINGFANGSC_REGULAR(24),NSParagraphStyleAttributeName:style};
            CGSize size = [str boundingRectWithSize:CGSizeMake(weakSelf.bankNum.bounds.size.width, kScrAdaptationH(31)) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            float width = weakSelf.bankNum.bounds.size.width - ceil(size.width);
            float space = width / (str.length-1);
            weakSelf.bankNum.text = str;
            [weakSelf changeWordSpaceForLabel:weakSelf.bankNum WithSpace:space];
            weakSelf.bankTip.text = weakSelf.viewModel.bankCardModel.quota;
            
            if (weakSelf.unbundBankBlock) {
                weakSelf.unbundBankBlock(weakSelf.viewModel.bankCardModel);
            }
        }
    }];
}

- (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    if (labelText) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        label.attributedText = attributedString;
        [label sizeToFit];
    }
    
}

#pragma mark 解绑动作
- (void)unBindAct:(UIButton*)button {
    if(self.unBindCardAct) {
        self.unBindCardAct();
    }
}

#pragma mark - 懒加载
- (HXBBankCardViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HXBBankCardViewModel alloc] init];
    }
    return _viewModel;
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}

- (UIButton *)unBindBtn
{
    if (!_unBindBtn) {
        _unBindBtn  = [[UIButton alloc] init];
        [_unBindBtn setTitle:@"解绑" forState:UIControlStateNormal];
        _unBindBtn.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(16);
        _unBindBtn.layer.borderWidth = 1;
        _unBindBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _unBindBtn.layer.cornerRadius = 2;
        [_unBindBtn addTarget:self action:@selector(unBindAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unBindBtn;
}

- (UILabel *)bankName
{
    if (!_bankName) {
        _bankName = [[UILabel alloc] init];
        _bankName.font = kHXBFont_PINGFANGSC_REGULAR(18);
        _bankName.textColor = [UIColor whiteColor];
    }
    return _bankName;
}

- (UILabel *)realName
{
    if (!_realName) {
        _realName = [[UILabel alloc] init];
        _realName.font = kHXBFont_PINGFANGSC_REGULAR(12);
        _realName.textColor = COR7;
    }
    return _realName;
}

- (UILabel *)bankNum
{
    if (!_bankNum) {
        _bankNum = [[UILabel alloc] init];
        _bankNum.font = kHXBFont_PINGFANGSC_REGULAR(24);
        _bankNum.numberOfLines = 1;
        _bankNum.textColor = [UIColor whiteColor];
    }
    return _bankNum;
}

- (UILabel *)bankTip
{
    if (!_bankTip) {
        _bankTip = [[UILabel alloc] init];
        _bankTip.font = kHXBFont_PINGFANGSC_REGULAR(12);
        _bankTip.textColor = [UIColor whiteColor];
    }
    return _bankTip;
}

@end
