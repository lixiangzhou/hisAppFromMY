//
//  HSJCALayerTool.m
//  hoommy
//
//  Created by caihongji on 2018/7/16.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJCALayerTool.h"

@implementation HSJCALayerTool

+ (CAGradientLayer*)gradualChangeColor:(UIColor*)beginColor toColor:(UIColor*)endColor cornerRadius:(float)radiu layerSize:(CGSize)size {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, size.width, size.height);
    gradient.cornerRadius = radiu;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)beginColor.CGColor,
                       (id)endColor.CGColor, nil];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
//    gradient.locations = @[@0.1, @0.3];
    
    return gradient;
}
@end
