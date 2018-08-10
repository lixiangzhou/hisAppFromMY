//
//  HXBAgreementView.m
//  hoomxb
//
//  Created by HXB-C on 2017/8/4.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBAgreementView.h"
#import "CJLabel.h"
@interface HXBAgreementView ()

@property (nonatomic, strong) UIButton *agreeBtn;

@property (nonatomic, strong) CJLabel *negotiateView;
@property (nonatomic, strong) UIButton *allScreenClickBtn;

/**
 需要添加点击事件的富文本
 */
@property (nonatomic, copy) NSMutableAttributedString *attributedString;

@end

@implementation HXBAgreementView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.agreeBtn];
        [self addSubview:self.negotiateView];
        [self addSubview:self.allScreenClickBtn];
        [self setupSubViewFrame];
    }
    return self;
}

- (void)setupSubViewFrame
{
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(2);
        make.top.equalTo(@3);
        make.width.height.offset(kScrAdaptationW(12));
    }];
    [self.negotiateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreeBtn.mas_right).offset(kScrAdaptationW(7));
        make.top.right.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
    [self.allScreenClickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

+ (NSMutableAttributedString *)configureLinkAttributedString:(NSAttributedString *)attrStr
                                                  withString:(NSString *)withString
                                            sameStringEnable:(BOOL)sameStringEnable
                                              linkAttributes:(NSDictionary *)linkAttributes
                                        activeLinkAttributes:(NSDictionary *)activeLinkAttributes
                                                   parameter:(id)parameter
                                              clickLinkBlock:(void(^)())clickLinkBlock
{
    NSMutableAttributedString *attributedString = [CJLabel configureLinkAttributedString:attrStr
                                withString:withString
                          sameStringEnable:sameStringEnable
                            linkAttributes:linkAttributes
                      activeLinkAttributes:activeLinkAttributes
                                 parameter:parameter
                            clickLinkBlock:^(CJLabelLinkModel *linkModel){
                                //点击事件
                                clickLinkBlock();
                            }longPressBlock:^(CJLabelLinkModel *linkModel){
                                //点击事件
                                clickLinkBlock();
                            }];
    
    return attributedString;
}

+ (NSMutableAttributedString *)configureLinkAttributedString:(NSAttributedString *)attrStr
                                            withDefaultAttributes:(NSDictionary*)defaultAttributes
                                                  withString:(NSString *)withString
                                            sameStringEnable:(BOOL)sameStringEnable
                                              linkAttributes:(NSDictionary *)linkAttributes
                                        activeLinkAttributes:(NSDictionary *)activeLinkAttributes
                                                   parameter:(id)parameter
                                              clickLinkBlock:(void(^)(void))clickLinkBlock
{
    NSMutableAttributedString *attributedString = [self configureLinkAttributedString:attrStr withString:withString sameStringEnable:sameStringEnable linkAttributes:linkAttributes activeLinkAttributes:activeLinkAttributes parameter:parameter clickLinkBlock:clickLinkBlock];
    NSRange range = [attrStr.string rangeOfString:withString];
    if(range.location != NSNotFound) {
        [attributedString addAttributes:defaultAttributes range:NSMakeRange(0, range.location)];
    }
    return attributedString;
}

- (void)setText:(id)text
{
    _text = text;
    self.negotiateView.text = text;
}

- (void)setIsAllowAllScreenClick:(BOOL)isAllowAllScreenClick {
    _isAllowAllScreenClick = isAllowAllScreenClick;
    
    self.allScreenClickBtn.userInteractionEnabled = isAllowAllScreenClick;
}

#pragma mark - 懒加载
- (UIButton *)agreeBtn
{
    if (!_agreeBtn) {
        _agreeBtn = [[UIButton alloc] init];
//        _agreeBtn.backgroundColor = [UIColor whiteColor];
//        _agreeBtn.layer.borderColor = COR10.CGColor;
//        _agreeBtn.layer.borderWidth = kXYBorderWidth;
//        _agreeBtn.layer.cornerRadius = kScrAdaptationW(3);
//        _agreeBtn.layer.masksToBounds = YES;
        _agreeBtn.selected = YES;
        _agreeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_agreeBtn setImage:[UIImage imageNamed:@"duigou"] forState:UIControlStateSelected];
        [_agreeBtn setImage:[UIImage imageNamed:@"Rectangle"] forState:(UIControlStateNormal)];
        [_agreeBtn addTarget:self action:@selector(agreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _agreeBtn;
}

- (void)agreeBtnClick
{
    self.agreeBtn.selected = !self.agreeBtn.selected;
    self.selectState = self.agreeBtn.selected;
    if (self.agreeBtnBlock) {
        self.agreeBtnBlock(self.agreeBtn.selected);
    }
}

- (UIButton *)allScreenClickBtn {
    if(!_allScreenClickBtn) {
        _allScreenClickBtn = [[UIButton alloc] init];
        
        _allScreenClickBtn.userInteractionEnabled = NO;
        [_allScreenClickBtn addTarget:self action:@selector(allScreenClickAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _allScreenClickBtn;
}

- (void)allScreenClickAct:(UIButton*)button {
    [self agreeBtnClick];
}

- (void)setSelectState:(BOOL)selectState {
    _selectState = selectState;
    
    self.agreeBtn.selected = selectState;
}

- (CJLabel *)negotiateView
{
    if (!_negotiateView) {
        _negotiateView = [[CJLabel alloc] initWithFrame:CGRectZero];
        _negotiateView.numberOfLines = 0;
    }
    return _negotiateView;
}

@end
