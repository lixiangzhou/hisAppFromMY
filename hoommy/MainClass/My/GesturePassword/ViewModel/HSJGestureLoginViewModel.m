//
//  HSJGestureLoginViewModel.m
//  hoommy
//
//  Created by lxz on 2018/7/30.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJGestureLoginViewModel.h"
#import "HSJBaseViewModel+HSJNetWorkApi.h"
#import "HXBRootVCManager.h"

@implementation HSJGestureLoginViewModel
- (UIView *)getHugView {
    return [HXBRootVCManager manager].gesturePwdVC.view;
}
@end
