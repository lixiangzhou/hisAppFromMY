//
//  HXBBindPhoneTableViewCell.h
//  hoomxb
//
//  Created by caihongji on 2018/7/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXBBindCardCellModel.h"

@interface HXBBindCardTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) HXBBindCardCellModel *cellModel;

//
@property (nonatomic, assign) BOOL isKeepKeyboardPop;

@property (nonatomic, strong) void (^checkCodeAct)(NSIndexPath *indexPath);
@property (nonatomic, strong) void (^textChange)(NSIndexPath *indexPath, NSString* text);

- (void)bindPrompInfo:(NSString*)imgName prompText:(NSString*)text;

@end
