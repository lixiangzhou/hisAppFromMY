//
//  HSJMyHomeInfoTableViewCell.h
//  hoommy
//
//  Created by hxb on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HSJMyHomeInfoType) {
    HSJMyHomeInfoTypeModifyBank = 0,    /// 修改手机号
    HSJMyHomeInfoTypeLoginEvaluating,   /// 风险测评
};

typedef void(^HSJMyHomeInfoBlock)(NSInteger type);

@interface HSJMyHomeInfoModel : NSObject
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) HSJMyHomeInfoType type;
@property (nonatomic, copy) HSJMyHomeInfoBlock infoBlock;
@end


@interface HSJMyHomeInfoTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray<HSJMyHomeInfoModel *> *infoModelArr;

@end
