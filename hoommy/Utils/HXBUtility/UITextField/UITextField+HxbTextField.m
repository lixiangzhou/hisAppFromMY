//
//  UITextField+HxbTextField.m
//  hoomxb
//
//  Created by HXB-C on 2017/5/2.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "UITextField+HxbTextField.h"

@implementation UITextField (HxbTextField)

+ (UITextField *)hxb_lineTextFieldWithFrame:(CGRect)frame{
    UITextField *textField = [[self alloc]initWithFrame:frame];
    textField.font = [UIFont systemFontOfSize:22];
    textField.tintColor = COR11;
    textField.textColor = COR6;
    //        _phoneTextField.rightView = self.textFieldRightImageView;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.rightView.hidden = YES;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, textField.height - 1, textField.width, 0.5)];
    lineView.backgroundColor = COR11;
    [textField addSubview:lineView];
    return textField;
}


- (void)setSelectedRange:(NSRange) range
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}
- (NSRange)selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}
@end
