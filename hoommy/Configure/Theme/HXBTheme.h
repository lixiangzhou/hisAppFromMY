//
//  HXBTheme.h
//  HXBCriterionProject
//
//  Created by caihongji on 2017/11/28.
//  Copyright © 2017年 caihongji. All rights reserved.
//

#ifndef HXBTheme_h
#define HXBTheme_h

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "HSJString.h"
#import "HXBScreenAdaptation.h"
#import "HXBSpacingMacro.h"
#import "HXBThemAdapterManager.h"
#import "HXBFontMacro.h"
#import "HXBBackgroundColorMacros.h"
#import "HXBFontColorMacros.h"
#import "HXBColorMacro.h"
#import "MacroDefinition.h"
#endif /* HXBTheme_h */
