//
//  HSJRollOutPlanDetailRowModel.m
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJRollOutPlanDetailRowModel.h"

@implementation HSJRollOutPlanDetailRowModel
- (instancetype)initWithType:(HSJRollOutPlanDetailRowType)type left:(NSString *)left right:(NSString *)right protocol:(NSString *)protocol className:(NSString *)className {
    self = [super init];
    
    self.type = type;
    self.left = left;
    self.right = right;
    self.protocol = protocol;
    self.className = className;
    self.rightLabelColor = kHXBColor_666666_100;
    
    return self;
}
@end
