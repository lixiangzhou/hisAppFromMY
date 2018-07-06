//
//  HSJTopFragmentNavgationView.h
//  BaichengVisa_v121
//
//  Created by caihongji on 16/4/28.
//  Copyright © 2016年 Beijing Byecity International Travel CO., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSJTopFragmentNavgationViewProto;

@interface HSJTopFragmentNavgationView : UIView

@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, assign) int fontSize;
@property(nonatomic, assign) BOOL isCanScroll;
@property (nonatomic, assign) int leftDis;
@property (nonatomic, assign) int itemDis;

@property (nonatomic, strong) UIColor *fontColor;
@property (nonatomic, strong) UIColor *fontSelColor;
@property (nonatomic, strong) UIColor *selLineColor;
@property (nonatomic, strong) UIColor *bottomLineColor;

@property (nonatomic, assign) BOOL isShowMoreBtn;
@property (nonatomic, assign) BOOL isShowTopLine;

@property (nonatomic, weak) IBOutlet id<HSJTopFragmentNavgationViewProto> protoDelegate;

- (void)updateTopBar;
- (void)setCurSelection:(NSInteger)index;
- (NSString *)getCurSectctionTitle:(NSInteger)index;
@end

@protocol HSJTopFragmentNavgationViewProto <NSObject>

@required
- (NSArray*)getTitleList;

@optional
- (CGFloat)getFontSize;
- (void)itemClick:(NSInteger)index;
- (void)rightButtonClickAct;
@end
