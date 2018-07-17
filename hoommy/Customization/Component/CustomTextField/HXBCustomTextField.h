//
//  HXBCustomTextField.h
//  hoomxb
//
//  Created by HXB-C on 2017/7/14.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTextField.h"

typedef void(^isLimitText)(NSString *text1);

@interface HXBCustomTextField : UIView

@property (nonatomic, strong,readonly) UITextField *textField;
@property (nonatomic, strong, readonly) BXTextField *idTextField;
@property (nonatomic, strong,readonly) UIImageView *leftImageView;


@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) UIImage *leftImage;
@property (nonatomic, strong) UIImage *rightImage;
@property (nonatomic, assign) BOOL isHidenLine;
@property (nonatomic, assign) BOOL secureTextEntry;
@property(nonatomic) UIKeyboardType keyboardType;
@property (nonatomic, assign) BOOL isIDCardTextField;
@property (nonatomic, assign) BOOL isGetCode;
@property (nonatomic, assign) BOOL isCleanAllBtn;
@property(nullable, nonatomic,weak)   id<UITextFieldDelegate> delegate;
//@property (nonatomic, copy) NSString * _Nullable typeTextField;
@property (nonatomic, assign) int number; // 必须要设置
@property (nonatomic, assign) int limitStringLength;
@property (nonatomic, assign) BOOL disableEdit;
@property (nonatomic, assign) BOOL hideEye;

/// 底部分割线的颜色
@property (nonatomic, strong) UIColor *bottomLineEditingColor;
@property (nonatomic, strong) UIColor *bottomLineNormalColor;
/// 底部分割线距离自身左右的距离
@property (nonatomic, assign) CGFloat bottomLineRightOffset;
@property (nonatomic, assign) CGFloat bottomLineLeftOffset;
/// TextField 右边的距离
@property (nonatomic, assign) CGFloat textFieldRightOffset;

/// 清除按钮距离右边的距离
@property (nonatomic, assign) NSInteger clearRightMargin;
// 是否大字号展示
@property (nonatomic, assign) BOOL isLagerText;
//字体颜色
@property (nonatomic, strong) UIColor *textColor;
//字体
@property (nonatomic, strong) UIFont *font;
//是否隐藏图片
@property (nonatomic, assign) BOOL isHiddenLeftImage;
/**
 SVG图片
 */
@property (nonatomic, copy) NSString *svgImageName;
/**
 返回当前输入text值的block
 */
@property (nonatomic, copy) isLimitText block;

/**
 背景按钮点击
 */
@property (nonatomic, copy) void(^btnClick)();
//键盘编辑状态
@property (nonatomic, copy) void(^ keyBoardChange)(BOOL isEditState);

@end
