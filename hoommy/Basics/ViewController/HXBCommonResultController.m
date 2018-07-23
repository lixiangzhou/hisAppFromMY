//
//  HXBCommonResultController.m
//  hoomxb
//
//  Created by lxz on 2018/4/26.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HXBCommonResultController.h"

@implementation HXBCommonResultContentModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.descAlignment = NSTextAlignmentCenter;
        self.descHasMark = NO;
    }
    return self;
}

- (instancetype)initWithImageName:(NSString *)imageName titleString:(NSString *)titleString descString:(NSString *)descString firstBtnTitle:(NSString *)firstBtnTitle
{
    self = [self init];
    
    self.imageName = imageName;
    self.titleString = titleString;
    self.descString = descString;
    self.firstBtnTitle = firstBtnTitle;
    
    return self;
}
@end

@interface HXBCommonResultController ()
/// 图标
@property (nonatomic, weak) UIImageView *iconView;
/// 大号文字
@property (nonatomic, weak) UILabel *titleLabel;

/// 小号描述文字容器
@property (nonatomic, weak) UIView *descView;
/// !
@property (nonatomic, weak) UIImageView *maskView;
/// 小号描述文字
@property (nonatomic, weak) UILabel *descLabel;

/// 中间比较特殊的View，需要自定义
@property (nonatomic, weak) UIView *customView;
/// 第一个按钮
@property (nonatomic, weak) UIButton *firstBtn;
/// 第二个按钮
@property (nonatomic, weak) UIButton *secondBtn;

/// 按钮底部的小号描述文字
@property (nonatomic, weak) UILabel *btnDescLabel;
@end

@implementation HXBCommonResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self setConstraints];
    [self setData];
}

#pragma mark - UI

- (void)setUI {
    
    // 图标
    // INPUT:
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:iconView];
    self.iconView = iconView;
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kHXBColor_333333_100;
    titleLabel.font = kHXBFont_38;
    [self.view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    // 描述
    UIView *descView = [UIView new];
    [self.view addSubview:descView];
    self.descView = descView;
    
    UILabel *descLabel = [UILabel new];
    descLabel.numberOfLines = 0;
    descLabel.font = kHXBFont_28;
    descLabel.textColor = kHXBColor_999999_100;
    [descView addSubview:descLabel];
    self.descLabel = descLabel;
    
    // ！
    UIImageView *maskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"result_prompt"]];
    [descView addSubview:maskView];
    self.maskView = maskView;
    
    UIView *customView = [UIView new];
    [self.view addSubview:customView];
    self.customView = customView;
    
    if (self.contentModel.firstBtnTitle) {
        // 第一个按钮
        UIButton *firstBtn = [UIButton new];
        firstBtn.layer.cornerRadius = 4;
        firstBtn.layer.masksToBounds = YES;
        [firstBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        firstBtn.backgroundColor = kHXBColor_FF7055_100;
        firstBtn.titleLabel.font = kHXBFont_32;
        [firstBtn addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:firstBtn];
        
        self.firstBtn = firstBtn;
    }
    
    
    // 如果有第二个按钮就显示，否则不显示
    if (self.contentModel.secondBtnTitle) {
        UIButton *secondBtn = [UIButton new];
        secondBtn.layer.cornerRadius = 4;
        secondBtn.layer.masksToBounds = YES;
        [secondBtn setTitleColor:kHXBColor_FF7055_100 forState:UIControlStateNormal];
        secondBtn.backgroundColor = [UIColor whiteColor];
        secondBtn.layer.borderColor = kHXBColor_FF7055_100.CGColor;
        secondBtn.layer.borderWidth = kXYBorderWidth;
        secondBtn.titleLabel.font = kHXBFont_32;
        [secondBtn addTarget:self action:@selector(secondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:secondBtn];
        
        self.secondBtn = secondBtn;
    }
    
    if (self.contentModel.btnDescString) {
        UILabel *btnDescLabel = [UILabel new];
        btnDescLabel.numberOfLines = 0;
        btnDescLabel.font = kHXBFont_24;
        btnDescLabel.textColor = kHXBColor_999999_100;
        [self.view addSubview:btnDescLabel];
        self.btnDescLabel = btnDescLabel;
    }
}
- (void)setConstraints {
    kWeakSelf
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(HXBStatusBarAndNavigationBarHeight + kScrAdaptationH750(120)));
        make.centerX.equalTo(weakSelf.view);
//        make.width.equalTo(@(kScrAdaptationW750(295)));
//        make.height.equalTo(@(kScrAdaptationH750(182)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).offset(kScrAdaptationH(40));
        make.centerX.equalTo(weakSelf.view);
    }];
    
    // 如果有描述，就显示
    if (self.contentModel.descString) {
        [self.descView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
            make.left.equalTo(@20);
            make.right.equalTo(@-20);
        }];
        
        if (self.contentModel.descAlignment == NSTextAlignmentLeft) {   // 左对齐，若有 ！，创建ImageView，因为这种情况下，文本要求一直在 ！ 右边
            [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.descView);
                make.height.equalTo(@14);
                make.width.equalTo(self.contentModel.descHasMark ? @14 : @0);
                make.top.equalTo(self.descView).offset(2);
            }];
            
            [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.bottom.equalTo(self.descView);
                make.left.equalTo(self.maskView.mas_right).offset(self.contentModel.descHasMark ? 7 : 0);
            }];
        } else {    // 居中，使用富文本，此时 ！ 和文本一起居中的
            self.maskView.hidden = YES;
            [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.descView);
            }];
        }

    } else {    // 没有描述就隐藏
        [self.descView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
            make.left.greaterThanOrEqualTo(@20);
            make.right.lessThanOrEqualTo(@-20);
            make.centerX.equalTo(self.view);
            make.height.equalTo(@0);
        }];
        self.descView.hidden = YES;
    }
    
    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@0);
    }];
    
    UIButton *btn = nil;
    if (self.contentModel.firstBtnTitle) {    
        [self.firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.customView.mas_bottom).offset(40);
            make.left.equalTo(@20);
            make.right.equalTo(@-20);
            make.height.equalTo(@41);
        }];
        btn = self.firstBtn;
    }
    
    // 如果有第二个按钮就显示，否则不显示
    if (self.contentModel.secondBtnTitle) {
        [self.secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.firstBtn.mas_bottom).offset(20);
            make.left.equalTo(@20);
            make.right.equalTo(@-20);
            make.height.equalTo(@41);
        }];
        
        btn = self.secondBtn;
    }
    
    [self.btnDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom).offset(10);
        make.left.equalTo(btn);
    }];
    
}

- (void)setData {
    self.iconView.image = [UIImage imageNamed:self.contentModel.imageName];
    self.titleLabel.text = self.contentModel.titleString;
    
    self.descLabel.textAlignment = self.contentModel.descAlignment;
    self.descLabel.text = self.contentModel.descString;
    
    if (self.contentModel.descString) {
        if (self.contentModel.descAlignment == NSTextAlignmentCenter) {
            // 居中样式使用富文本，居左模式使用ImageView
            NSMutableAttributedString *descAttr = [[NSMutableAttributedString alloc] init];
            if (self.contentModel.descHasMark) {
                NSTextAttachment *mask = [NSTextAttachment new];
                mask.image = [UIImage imageNamed:@"tip"];
                mask.bounds = CGRectMake(0, -2, 14, 14);
                [descAttr appendAttributedString:[NSAttributedString attributedStringWithAttachment:mask]];
            }
            [descAttr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", self.contentModel.descString]]];
            self.descLabel.attributedText = descAttr;
        }
    }
    
    [self.firstBtn setTitle:self.contentModel.firstBtnTitle forState:UIControlStateNormal];
    if (self.contentModel.secondBtnTitle) {
        [self.secondBtn setTitle:self.contentModel.secondBtnTitle forState:UIControlStateNormal];
    }
    
    if (self.configCustomView) {
        self.configCustomView(self.customView);
    }
    
    if (self.contentModel.btnDescString) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
        if (self.contentModel.btnDescHasMark) {
            NSTextAttachment *attachment = [NSTextAttachment new];
            attachment.image = [UIImage imageNamed:@"result_prompt"];
            attachment.bounds = CGRectMake(0, -3, attachment.image.size.width, attachment.image.size.height);
            [attr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
        }
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", self.contentModel.btnDescString] attributes:nil]];
        self.btnDescLabel.attributedText = attr;
    }
}


#pragma mark - Action
- (void)firstBtnClick:(UIButton *)btn {
    if (self.contentModel.firstBtnBlock) {
        self.contentModel.firstBtnBlock(self);
    }
}

- (void)secondBtnClick:(UIButton *)btn {
    if (self.contentModel.secondBtnBlock) {
        self.contentModel.secondBtnBlock(self);
    }
}

- (void)leftBackBtnClick
{
    if (self.contentModel.navBackBlock) {
        self.contentModel.navBackBlock(self);
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
