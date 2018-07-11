//
//  HXBBindPhoneTableViewCell.h
//  hoomxb
//
//  Created by caihongji on 2018/7/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXBBindPhoneCellModel.h"

@interface HXBBindPhoneTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) HXBBindPhoneCellModel *cellModel;

@property (nonatomic, strong) void (^checkCodeAct)(NSIndexPath *indexPath);
@property (nonatomic, strong) void (^textChange)(NSIndexPath *indexPath, NSString* text);

//校验码倒计时
- (void)checkCodeCountDown:(BOOL)isStart;
//验证码按钮是否可用
- (void)enableCheckButton:(BOOL)isEnable;
@end
