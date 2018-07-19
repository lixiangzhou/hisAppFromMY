//
//  HXBBindPhoneCellModel.m
//  hoomxb
//
//  Created by caihongji on 2018/7/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HXBBindCardCellModel.h"

@implementation HXBBindCardCellModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.limtTextLenght = 999999;
        self.keyboardType = UIKeyboardTypeDefault;
    }
    return self;
}

- (instancetype)initModel:(NSString*)title placeText:(NSString*)place text:(NSString*)content{
    self = [self init];
    
    if(self) {
        self.title = title;
        self.placeText = place;
        self.text = content;
    }
    return self;
}
@end
