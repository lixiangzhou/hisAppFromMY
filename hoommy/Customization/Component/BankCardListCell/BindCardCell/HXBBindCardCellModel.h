//
//  HXBBindPhoneCellModel.h
//  hoomxb
//
//  Created by caihongji on 2018/7/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXBBindCardCellModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeText;
@property (nonatomic, copy) NSString* text;
@property (nonatomic, copy) NSString* rightButtonText;

@property (nonatomic, assign) BOOL isShowBottomView;
@property (nonatomic, assign) int limtTextLenght;//默认值999999, 无限制
@property (nonatomic, assign) BOOL isCanEdit;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) BOOL isBankCardNoField;
@property (nonatomic, assign) BOOL secureTextEntry;//安全文本

- (instancetype)initModel:(NSString*)title placeText:(NSString*)place text:(NSString*)content;
@end
