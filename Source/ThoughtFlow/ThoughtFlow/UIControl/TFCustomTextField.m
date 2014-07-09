//
// Created by Dani Postigo on 4/28/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFCustomTextField.h"
#import "UIView+DPKit.h"
#import "UIColor+TFApp.h"
#import "UIView+DPKitChildren.h"


CGFloat const leftAccessoryWidth = 30;
CGFloat const TFTextFieldBorderWidth = 0.5;

@implementation TFCustomTextField

- (void) awakeFromNib {
    [super awakeFromNib];

    self.layer.cornerRadius = 2;

    self.leftView = [self createLeftAccessoryView];
    self.leftViewMode = UITextFieldViewModeAlways;

    self.rightView = [self createRightAccessoryView];
    self.rightViewMode = UITextFieldViewModeUnlessEditing;

}




#pragma mark UITextFieldDelegate
//
//- (void) setDelegate: (id <UITextFieldDelegate>) delegate {
//    __delegate = delegate;
//}



#pragma mark IBActions

- (void) handleRightAccessoryView: (UIButton *) button {
    button.selected = !button.selected;
    [self becomeFirstResponder];

}


#pragma mark Accesory views

- (UIButton *) rightAccessoryButton {
    return (UIButton *) ([self.rightView isKindOfClass: [UIButton class]] ? self.rightView : nil);
}


- (UIView *) createRightAccessoryView {
    UIButton *ret = [UIButton buttonWithType: UIButtonTypeCustom];
    ret.frame = CGRectMake(0, 0, self.rightAccessoryWidth + self.rightAccessoryPadding, 36);

    UIView *borderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.rightBorderWidth,
            self.rightAccessoryHeight - 11)];

    borderView.backgroundColor = [UIColor tfInputTextColor];
    borderView.alpha = 0.5;
    [ret addSubview: borderView];

    borderView.left = self.rightAccessoryPadding;
    borderView.centerY = borderView.superview.height / 2;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0,
            16, 16)];
    imageView.image = [UIImage imageNamed: @"edit-icon"];
    imageView.centerX = self.rightAccessoryPadding + (self.rightAccessoryWidth / 2);
    imageView.centerY = ret.height / 2;
    [ret addSubview: imageView];

    [ret addTarget: self action: @selector(handleRightAccessoryView:) forControlEvents: UIControlEventTouchUpInside];
    return ret;
}


#pragma mark Getters

- (UIImageView *) leftAccessoryImageView {
    return [self.leftView firstChildOfClass: [UIImageView class]];
}

- (UIView *) createLeftAccessoryView {

    UIView *ret = [[UIView alloc] initWithFrame: CGRectMake(0, 0, leftAccessoryWidth + self.leftAccessoryPadding,
            self.leftAccessoryHeight)];


    UIView *borderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, TFTextFieldBorderWidth,
            25)];

    borderView.alpha = 0.5;
    borderView.backgroundColor = [UIColor tfInputTextColor];
    [ret addSubview: borderView];

    borderView.right = borderView.superview.width - self.leftBorderWidth - self.leftAccessoryPadding;
    borderView.centerY = borderView.superview.height / 2;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0,
            16, 16)];
    imageView.image = [UIImage imageNamed: @"default-user"];
    imageView.centerX = (ret.width - self.leftAccessoryPadding) / 2;
    imageView.centerY = ret.height / 2;
    [ret addSubview: imageView];
    return ret;
}


#pragma mark Values

- (CGFloat) rightBorderWidth {
    return TFTextFieldBorderWidth;
}

- (CGFloat) rightAccessoryPadding {
    return 15;
}

- (CGFloat) rightAccessoryWidth {
    return 38.0;
}

- (CGFloat) rightAccessoryHeight {
    return 36.0;
}


#pragma mark Left accessory prefs
- (CGFloat) leftBorderWidth {
    return TFTextFieldBorderWidth;
}


- (CGFloat) leftAccessoryPadding {
    return 12.0;
}

- (CGFloat) leftAccessoryWidth {
    return leftAccessoryWidth;
}

- (CGFloat) leftAccessoryHeight {
    return 36.0;
}

@end