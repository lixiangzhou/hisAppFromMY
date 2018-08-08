//
//  IQKeyboardManagerExtent.m
//  hoommy
//
//  Created by caihongji on 2018/8/8.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "IQKeyboardManagerExtent.h"

@interface IQKeyboardManagerExtent()
@property (nonatomic, weak) UIView *editView;
@end

@implementation IQKeyboardManagerExtent

+ (instancetype)sharedInstance
{
    static IQKeyboardManagerExtent *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textFieldViewDidBeginEditing:(NSNotification*)notify {
    self.editView = notify.object;
}

- (void)keyboardWillShow:(NSNotification*)notify {
    if([self isIphoneX]) {
        CGRect rect = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        id<KeyboardSizeChange> delegate = (id<KeyboardSizeChange>)self.editView.viewController;
        if([delegate respondsToSelector:@selector(keyboardShow:)]) {
            [delegate keyboardShow:rect];
        }
    }
    
}

- (void)keyboardDidShow:(NSNotification*)notify {
    
}

- (void)keyboardWillHide:(NSNotification*)notify {
    if([self isIphoneX]) {
        id<KeyboardSizeChange> delegate = (id<KeyboardSizeChange>)self.editView.viewController;
        if([delegate respondsToSelector:@selector(keyboardHidden)]) {
            [delegate keyboardHidden];
        }
    }
    
}

- (void)keyboardDidHide:(NSNotification*)notify {
    
}

- (BOOL)isIphoneX {
    CGSize size = [UIScreen mainScreen].bounds.size;
    if(812 == size.height) {//iphoneX
        return YES;
    }
    return NO;
}

- (void)setEnable:(BOOL)enable {
    if([self isIphoneX]) {
        enable = NO;
    }
    _enable = enable;
    [IQKeyboardManager sharedManager].enable = enable;
}

- (void)setKeyboardManager {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    self.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}
@end
