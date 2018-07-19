//
//  HSJBuyCellModel.h
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSJBuyCellModel : NSObject

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSAttributedString *title;
@property (nonatomic, copy) NSString *descripText;
@property (nonatomic, copy) NSString *arrowText;

@property (nonatomic, assign) BOOL isSvnImage;
@property (nonatomic, assign) BOOL isShowArrow;

- initCellModel:(BOOL)isSvnImage showArrow:(BOOL)isShowArrow;
@end
