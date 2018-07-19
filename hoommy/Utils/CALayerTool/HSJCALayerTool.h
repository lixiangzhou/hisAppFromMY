//
//  HSJCALayerTool.h
//  hoommy
//
//  Created by caihongji on 2018/7/16.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSJCALayerTool : NSObject

+ (CAGradientLayer*)gradualChangeColor:(UIColor*)beginColor toColor:(UIColor*)endColor cornerRadius:(float)radiu layerSize:(CGSize)size;
@end
