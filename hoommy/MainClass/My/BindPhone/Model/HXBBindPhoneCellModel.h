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
@end
