//
// Created by Dani Postigo on 4/28/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFCustomTextField.h"
#import "UIView+DPKit.h"
#import "UIView+DPConstraints.h"
#import "DPBorderedView.h"
#import "UIColor+TFApp.h"

@implementation TFCustomTextField

- (void) awakeFromNib {
    [super awakeFromNib];

    self.layer.cornerRadius = 2;

    self.leftView = self.leftAccessoryView;
    self.leftViewMode = UITextFieldViewModeAlways;

    self.rightView = self.rightAccessoryView;
    //    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightViewMode = UITextFieldViewModeUnlessEditing;

    //    self.enabled = NO;
    super.delegate = self;

}


- (void) setDelegate: (id <UITextFieldDelegate>) delegate {
    //    _delegate = delegate;
    __delegate = delegate;
}



#pragma mark UITextFieldDelegate

- (BOOL) textFieldShouldBeginEditing: (UITextField *) textField {
    return self.rightAccessoryButton.selected;
}


- (BOOL) textFieldShouldReturn: (UITextField *) textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (__delegate && [__delegate respondsToSelector: @selector(textFieldShouldReturn:)]) {
        return [__delegate performSelector: @selector(textFieldShouldReturn:) withObject: self];
    }
    [self resignFirstResponder];
    return YES;
}


#pragma mark IBActions

- (void) handleRightAccessoryView: (UIButton *) button {
    button.selected = !button.selected;
    NSLog(@"button.selected = %d", button.selected);
    [self becomeFirstResponder];

}


- (UIButton *) rightAccessoryButton {
    return (UIButton *) ([self.rightView isKindOfClass: [UIButton class]] ? self.rightView : nil);
}
#pragma mark Accesory views


- (UIView *) rightAccessoryView {

    CGFloat padding = 15;
    CGFloat borderWidth = 0.5;

    CGFloat accessoryWidth = 38;
    CGFloat accesoryHeight = 36;


    //    UIView *button = [[UIView alloc] initWithFrame: CGRectMake(0, 0, accessoryWidth + padding, 36)];
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, accessoryWidth + padding, 36);

    UIView *borderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, borderWidth,
            accesoryHeight - 11)];

    borderView.backgroundColor = [UIColor tfInputTextColor];
    borderView.alpha = 0.5;
    [button addSubview: borderView];

    borderView.left = padding;
    borderView.centerY = borderView.superview.height / 2;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0,
            16, 16)];
    imageView.image = [UIImage imageNamed: @"default-user"];
    imageView.centerX = padding + (accessoryWidth / 2);
    imageView.centerY = button.height / 2;
    [button addSubview: imageView];

    [button addTarget: self action: @selector(handleRightAccessoryView:) forControlEvents: UIControlEventTouchUpInside];
    return button;
}


- (UIView *) leftAccessoryView {

    CGFloat leftPadding = 12;
    CGFloat borderWidth = 0.5;

    CGFloat accessoryWidth = 30;
    CGFloat accesoryHeight = 36;

    UIView *accesoryView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, accessoryWidth + leftPadding, 36)];


    UIView *borderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, borderWidth,
            25)];

    borderView.alpha = 0.5;
    borderView.backgroundColor = [UIColor tfInputTextColor];
    [accesoryView addSubview: borderView];

    borderView.right = borderView.superview.width - borderWidth - leftPadding;
    borderView.centerY = borderView.superview.height / 2;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0,
            16, 16)];
    imageView.image = [UIImage imageNamed: @"default-user"];
    imageView.centerX = (accesoryView.width - leftPadding) / 2;
    imageView.centerY = accesoryView.height / 2;
    [accesoryView addSubview: imageView];
    return accesoryView;
}

- (void) test1 {
    CGFloat leftPadding = 10;
    CGFloat borderWidth = 0.5;

    CGRect leftViewFrame = CGRectMake(0, 0, 30, 35);
    //    leftViewFrame.size.width += leftPadding + borderWidth;
    UIView *leftView = [[UIView alloc] initWithFrame: leftViewFrame];
    leftView.backgroundColor = [UIColor clearColor];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0,
            16, 16)];
    imageView.image = [UIImage imageNamed: @"default-user"];
    imageView.centerX = (leftView.width / 2);
    imageView.centerY = leftView.height / 2;
    [leftView addSubview: imageView];

    CGRect borderFrame = CGRectInset(imageView.bounds, 0, -3);
    borderFrame.size.width = borderWidth;
    borderFrame.origin.x = leftView.width - borderFrame.size.width - leftPadding;

    UIView *borderView = [[UIView alloc] initWithFrame: borderFrame];
    borderView.backgroundColor = [UIColor whiteColor];
    [imageView addSubview: borderView];

    leftView.width += leftPadding + borderWidth;

    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void) testBorderedView {
    DPBorderedView *borderedView = [[DPBorderedView alloc] initWithFrame: CGRectMake(0, 0,
            30, 35)];

    borderedView.backgroundColor = [UIColor clearColor];
    borderedView.borderOptions = UIRectEdgeRight;
    borderedView.borderColor = [UIColor whiteColor];
    borderedView.borderWidth = 1;

}


@end