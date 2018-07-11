//
//  HXBBindPhoneCellModel.h
//  hoomxb
//
//  Created by caihongji on 2018/7/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXBBindPhoneCellModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeText;
@property (nonatomic, copy) NSString* text;

@property (nonatomic, assign) BOOL isShowCheckCodeView;
@property (nonatomic, assign) BOOL isLastItem;
@property (nonatomic, assign) int limtTextLenght;//默认值999999, 无限制
@property (nonatomic, assign) BOOL isCanEdit;
@property (nonatomic, assign) UIKeyboardType keyboardType;

- (instancetype)initModel:(NSString*)title placeText:(NSString*)place isLastItem:(BOOL)isLast text:(NSString*)content;
@end
