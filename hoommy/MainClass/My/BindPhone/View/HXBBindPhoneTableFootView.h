//
//  HXBBindPhoneTableFootView.h
//  hoomxb
//
//  Created by caihongji on 2018/7/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXBBindPhoneTableFootView : UIView

@property (nonatomic, strong) UIColor *buttonBackGroundColor;
@property (nonatomic, strong) UIImage *buttonBackGroundImage;
@property (nonatomic, copy) NSString *buttonTitle;

@property (nonatomic, strong) void (^checkAct)();
@end
