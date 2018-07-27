//
//  HXBNoticeCell.m
//  hoomxb
//
//  Created by HXB-C on 2017/7/26.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBNoticeCell.h"

@interface HXBNoticeCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation HXBNoticeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setNoticModel:(HSJNoticeListModel *)noticModel {
    _noticModel = noticModel;
    self.titleLabel.text = noticModel.title;
    self.messageLabel.text = [[HXBBaseHandDate sharedHandleDate] millisecond_StringFromDate:noticModel.date andDateFormat:@"MM-dd"];
}

- (void)setupUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kScrAdaptationW750(30));
        make.right.equalTo(self.contentView).offset(-kScrAdaptationW750(30));
        make.height.offset(kHXBDivisionLineHeight);
        make.bottom.equalTo(self.contentView).offset(-1);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kScrAdaptationW(15));
        make.top.equalTo(self.contentView).offset(kScrAdaptationH(15));
        make.width.offset(kScrAdaptationW(263));
        make.bottom.equalTo(self.lineView.mas_top);
        
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(kScrAdaptationW(-15));
        make.width.offset(kScrAdaptationW(70));
        make.top.equalTo(self.contentView).offset(kScrAdaptationH(16));
        make.bottom.equalTo(self.lineView.mas_top);
    }];
    
   
    
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(15);
        _titleLabel.textColor = COR8;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = kHXBFont_PINGFANGSC_REGULAR(12);
        _messageLabel.textColor = COR10;
        _messageLabel.textAlignment = NSTextAlignmentRight;
    }
    return _messageLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COR12;
    }
    return _lineView;
}

@end
