//
//  HSJEarningCalculatorView.m
//  hoommy
//
//  Created by lxz on 2018/7/24.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJEarningCalculatorView.h"
#import "UITextField+HxbTextField.h"

@interface HSJEarningCalculatorView ()
@property (nonatomic, copy) void (^buyBlock)(NSString *value);
@property (nonatomic, weak) UITextField *inputField;
@property (nonatomic, weak) UIView *numberView;
@property (nonatomic, weak) UIButton *selectTimeBtn;
@property (nonatomic, weak) UILabel *earnLabel;

@property (nonatomic, weak) UIButton *timeBtn;
@property (nonatomic, assign) double interest;
@end

@implementation HSJEarningCalculatorView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

+ (instancetype)shared {
    static HSJEarningCalculatorView *tipView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tipView = [[HSJEarningCalculatorView alloc] initWithFrame:[HXBRootVCManager manager].mainTabbarVC.view.bounds];
    });
    return tipView;
}

#pragma mark - UI

- (void)setUI {
    self.backgroundColor = RGBA(0, 0, 0, 0.5);
    
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = kHXBFont_36;
    titleLabel.text = @"收益计算器";
    titleLabel.textColor = kHXBColor_333333_100;
    [contentView addSubview:titleLabel];
    
    UIButton *closeBtn = [UIButton new];
    [closeBtn setImage:[UIImage imageNamed:@"calculator_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeBtn];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScrAdaptationW(15), 0)];
    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScrAdaptationW(86), kScrAdaptationW(40))];
    leftView.text = @"买入金额";
    leftView.textAlignment = NSTextAlignmentCenter;
    leftView.textColor = kHXBColor_999999_100;
    leftView.font = kHXBFont_28;
    
    UITextField *inputField = [UITextField new];
    inputField.text = @"¥10,000";
    inputField.textAlignment = NSTextAlignmentRight;
    inputField.textColor = kHXBColor_333333_100;
    inputField.font = kHXBFont_30;
    inputField.backgroundColor = UIColorFromRGB(0xF5F5F5);
    inputField.layer.masksToBounds = YES;
    inputField.layer.cornerRadius = 4;
    inputField.inputView = [UIView new];
    inputField.leftView = leftView;
    inputField.leftViewMode = UITextFieldViewModeAlways;
    inputField.rightView = rightView;
    inputField.rightViewMode = UITextFieldViewModeAlways;
    
    [contentView addSubview:inputField];
    self.inputField = inputField;
    
    NSArray *days = @[@30, @60, @90, @180];
    UIButton *lastBtn = nil;
    for (NSInteger i = 0; i < days.count; i++) {
        UIButton *btn = [UIButton new];
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:[NSString stringWithFormat:@"%zd天", [days[i] integerValue]] forState:UIControlStateNormal];
        btn.titleLabel.font = kHXBFont_28;
        [btn setTitleColor:kHXBColor_D9B171_100 forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"calculator_day_normal_bg"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"calculator_day_selected_bg"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"calculator_day_selected_bg"] forState:UIControlStateSelected];
        btn.tag = [days[i] integerValue];
        [btn addTarget:self action:@selector(selectTimeAction:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
        
        if (i == 0) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(inputField.mas_bottom).offset(kScrAdaptationW(15));
                make.height.equalTo(@kScrAdaptationW(30));
                make.left.equalTo(@kScrAdaptationW(15));
            }];
        } else if (i == 3) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastBtn);
                make.right.equalTo(@kScrAdaptationW(-15));
                make.height.width.equalTo(lastBtn);
                make.left.equalTo(lastBtn.mas_right).offset(kScrAdaptationW(15));
            }];
        } else {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.width.height.equalTo(lastBtn);
                make.left.equalTo(lastBtn.mas_right).offset(kScrAdaptationW(15));
            }];
        }
        
        // 默认选择第三个
        if (i == 2) {
            self.selectTimeBtn = btn;
            self.timeBtn = btn;
            btn.selected = YES;
        }
        
        lastBtn = btn;
    }
    
    UILabel *earnDescLabel = [UILabel new];
    earnDescLabel.font = kHXBFont_28;
    earnDescLabel.text = @"预期收益";
    earnDescLabel.textColor = kHXBColor_999999_100;
    [contentView addSubview:earnDescLabel];
    
    UILabel *earnLabel = [UILabel new];
    earnLabel.font = kHXBFont_34;
    earnLabel.text = @"¥0.00";
    earnLabel.textColor = kHXBColor_FF7055_100;
    [contentView addSubview:earnLabel];
    self.earnLabel = earnLabel;
    
    UIView *numberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 222)];
    [contentView addSubview:numberView];
    self.numberView = numberView;
    
    [self setupNumberBtns];
    
    UIButton *buyBtn = [UIButton new];
    buyBtn.backgroundColor = kHXBColor_FF7055_100;
    buyBtn.titleLabel.font = kHXBFont_30;
    [buyBtn setTitle:@"按此金额购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:buyBtn];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@kScrAdaptationW(20));
        make.centerX.equalTo(contentView);
    }];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(titleLabel);
        make.left.equalTo(@kScrAdaptationW(8));
    }];
    
    [inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(kScrAdaptationW(30));
        make.left.equalTo(@kScrAdaptationW(15));
        make.right.equalTo(@kScrAdaptationW(-15));
        make.height.equalTo(@kScrAdaptationW(40));
    }];
    
    [earnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastBtn.mas_bottom).offset(kScrAdaptationW(20));
        make.right.equalTo(lastBtn);
    }];
    
    [earnDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(earnLabel);
        make.left.equalTo(@kScrAdaptationW(15));
    }];
    
    [numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(earnLabel.mas_bottom).offset(kScrAdaptationW(20));
        make.centerX.equalTo(contentView);
        make.width.equalTo(@(numberView.width));
        make.height.equalTo(@(numberView.height));
    }];
    
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numberView.mas_bottom).offset(kScrAdaptationW(25));
        make.left.right.equalTo(contentView);
        make.height.equalTo(@kScrAdaptationW(44));
        make.bottom.equalTo(@(-HXBBottomAdditionHeight));
    }];
}

- (void)setupNumberBtns {
    CGFloat paddingX = 15;
    CGFloat paddingY = 10;
    CGFloat width = (kScreenWidth - paddingX * 4) / 3;
    CGFloat height = 48;
    CGFloat maxY = 0;
    
    UIImage *normalImg = [UIImage imageNamed:@"calculator_number_normal_bg"];
    UIImage *normalNewImag = [normalImg stretchableImageWithLeftCapWidth:normalImg.size.width * 0.5 topCapHeight:normalImg.size.height * 0.5];
    
    UIImage *selectImg = [UIImage imageNamed:@"calculator_number_selected_bg"];
    UIImage *selectNewImg = [selectImg stretchableImageWithLeftCapWidth:selectImg.size.width * 0.5 topCapHeight:selectImg.size.height * 0.5];
    
    for (NSInteger i = 0; i < 9; i++) {
        UIButton *btn = [UIButton new];
        [btn setTitle:[NSString stringWithFormat:@"%zd", i + 1] forState:UIControlStateNormal];
        btn.titleLabel.font = kHXBFont_40;
        [btn setTitleColor:kHXBColor_333333_100 forState:UIControlStateNormal];
        [btn setBackgroundImage:normalNewImag forState:UIControlStateNormal];
        [btn setBackgroundImage:selectNewImg forState:UIControlStateHighlighted];
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(selectNumberAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.numberView addSubview:btn];
        
        NSInteger row = i / 3;
        NSInteger col = i % 3;
        CGFloat x = paddingX + (width + paddingX) * col;
        CGFloat y = (height + paddingY) * row;
        
        btn.frame = CGRectMake(x, y, width, height);
        maxY = CGRectGetMaxY(btn.frame);
    }
    
    UIButton *btn0 = [UIButton new];
    [btn0 setTitle:@"0" forState:UIControlStateNormal];
    btn0.titleLabel.font = kHXBFont_40;
    [btn0 setTitleColor:kHXBColor_333333_100 forState:UIControlStateNormal];
    [btn0 setBackgroundImage:normalNewImag forState:UIControlStateNormal];
    [btn0 setBackgroundImage:selectNewImg forState:UIControlStateHighlighted];
    btn0.tag = 0;
    [btn0 addTarget:self action:@selector(selectNumberAction:) forControlEvents:UIControlEventTouchUpInside];
    btn0.frame = CGRectMake(paddingX, maxY + paddingY, paddingX + width * 2, height);
    [self.numberView addSubview:btn0];
    
    UIButton *btnDel = [UIButton new];
    [btnDel setImage:[UIImage imageNamed:@"calculator_del"] forState:UIControlStateNormal];
    [btnDel setBackgroundImage:normalNewImag forState:UIControlStateNormal];
    [btnDel setBackgroundImage:selectNewImg forState:UIControlStateHighlighted];
    btnDel.tag = -1;
    [btnDel addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
    btnDel.frame = CGRectMake(CGRectGetMaxX(btn0.frame) + paddingX, maxY + paddingY, width, height);
    [self.numberView addSubview:btnDel];
}

#pragma mark - Action
- (void)closeAction {
    HSJEarningCalculatorView *calculatorView = [HSJEarningCalculatorView shared];
    
    calculatorView.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^{
        calculatorView.alpha = 0;
    } completion:^(BOOL finished) {
        [calculatorView removeFromSuperview];
    }];
}

- (void)selectTimeAction:(UIButton *)btn {
    if ([btn isEqual:self.selectTimeBtn]) {
        return;
    }
    self.selectTimeBtn.selected = NO;
    btn.selected = YES;
    self.selectTimeBtn = btn;
    
    [self updateEarning];
}

- (void)selectNumberAction:(UIButton *)btn {
    NSString *value = [NSString stringWithFormat:@"%zd", btn.tag];
    
    NSRange range = self.inputField.selectedRange;
    // 如果光标位置包括了¥，则处理光标，使其不包含¥，并保证光标永远在¥后面
    if (range.location == 0) {
        range.location = 1;
        if (range.length > 0) {
            range.length -= 1;
        }
    }
    
    // 在¥后面输入0，无响应
    if (range.location == 1 && [value isEqualToString:@"0"]) {
        return;
    } else {
        NSString *currentMoney = [self getFieldValue];
        /// 最大输入金额 999999999
        if (currentMoney.length >= 9) {
            return;
        }
        NSInteger right = self.inputField.text.length - range.location - range.length;
        
        [self.inputField insertText:value];
        
        NSString *newMoney = [self getFieldValue];
        self.inputField.text = [NSString hsj_moneyValuePrefixNoPoint:newMoney.doubleValue];
        
        NSInteger loc = self.inputField.text.length - right;
        self.inputField.selectedRange = NSMakeRange(MAX(loc, 1), 0);
    }
    
    [self updateEarning];
}

- (void)delAction {
    NSRange range = self.inputField.selectedRange;
    if (range.location == 1) {
        return;
    }
    
    NSInteger right = self.inputField.text.length - range.location - range.length;
    
    // 遇到 , 删除 , 前一位
    if (range.location > 1 && [[self.inputField.text substringWithRange:NSMakeRange(range.location - 1, 1)] isEqualToString:@","]) {
        self.inputField.text = [self.inputField.text stringByReplacingCharactersInRange:NSMakeRange(range.location - 2, 1) withString:@""];
        NSString *newMoney = [self getFieldValue];
        self.inputField.text = [NSString hsj_moneyValuePrefixNoPoint:newMoney.doubleValue];
        
        NSInteger loc = self.inputField.text.length - right;
        self.inputField.selectedRange = NSMakeRange(loc - 1, 0);
    } else {
        [self.inputField deleteBackward];
        
        NSString *newMoney = [self getFieldValue];
        self.inputField.text = [NSString hsj_moneyValuePrefixNoPoint:newMoney.doubleValue];
        
        NSInteger loc = self.inputField.text.length - right;
        self.inputField.selectedRange = NSMakeRange(MAX(loc, 1), 0);
    }

    [self updateEarning];
}

- (void)buyAction {
    if (self.buyBlock) {
        self.buyBlock([self getFieldValue]);
    }
}

#pragma mark - Setter / Getter / Lazy


#pragma mark - Helper
- (NSString *)getFieldValue {
    NSString *currentMoney = [self.inputField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    currentMoney = [currentMoney stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    return currentMoney;
}

- (void)updateEarning {
    NSString *money = [self getFieldValue];
    NSString *time = self.selectTimeBtn.currentTitle;
    double value = money.doubleValue * time.integerValue * (self.interest) / 365;
    self.earnLabel.text = [NSString hsj_moneyValuePrefix:value];
}

#pragma mark - Other


#pragma mark - Public
+ (void)showWithInterest:(double)interest buyBlock:(void (^)(NSString *value))buyBlock; {
    HSJEarningCalculatorView *calculatorView = [HSJEarningCalculatorView shared];
    calculatorView.buyBlock = buyBlock;
    
    calculatorView.interest = interest;
    calculatorView.earnLabel.text = @"0.00";
    calculatorView.inputField.text = @"¥10,000";
    [calculatorView selectTimeAction:calculatorView.timeBtn];
    
    [[HXBRootVCManager manager].mainTabbarVC.view addSubview:calculatorView];
    
    calculatorView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        calculatorView.alpha = 1;
    } completion:^(BOOL finished) {
        [calculatorView.inputField becomeFirstResponder];
        [calculatorView updateEarning];
    }];
}
@end
