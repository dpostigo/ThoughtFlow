//
// Created by Dani Postigo on 4/28/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFTextField.h"
#import "UIView+DPKit.h"
#import "UIColor+TFApp.h"
#import "UIView+DPKitChildren.h"


@interface TFTextFieldHandler : NSObject <UITextFieldDelegate> {
}

@property(nonatomic) BOOL editable;
@property(nonatomic, assign) id <UITextFieldDelegate> delegate;
@end


@implementation TFTextFieldHandler

- (BOOL) textFieldShouldBeginEditing: (UITextField *) textField {

    NSLog(@"textField.leftView = %@", textField.leftView);

    return textField.leftView != nil;
}


@end

CGFloat const leftAccessoryWidth = 30;
CGFloat const TFTextFieldBorderWidth = 0.5;

@interface TFTextField ()

@property(nonatomic, strong) TFTextFieldHandler *privateDelegate;
@end

@implementation TFTextField

- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {

        [self _setup];
    }
    return self;
}

- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self _setup];
    }

    return self;
}


- (void) awakeFromNib {
    [super awakeFromNib];

    [self _setupTextField];

}


#pragma mark Actions

- (void) handleRightAccessoryView: (UIButton *) button {
    button.selected = !button.selected;
    [self becomeFirstResponder];
}



#pragma mark - Setup

- (void) _setup {
    _privateDelegate = [[TFTextFieldHandler alloc] init];
    super.delegate = _privateDelegate;
}

- (void) _setupTextField {

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




#pragma mark Accessory views



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


#pragma mark - Getters

- (UIButton *) rightAccessoryButton {
    return (UIButton *) ([self.rightView isKindOfClass: [UIButton class]] ? self.rightView : nil);
}



#pragma mark Getters

- (UIImageView *) leftAccessoryImageView {
    return [self.leftView firstChildOfClass: [UIImageView class]];
}

- (UIView *) createLeftAccessoryView {

    UIView *ret = [[UIView alloc] initWithFrame: CGRectMake(0,
            0,
            leftAccessoryWidth + self.leftAccessoryPadding,
            self.leftAccessoryHeight)];


    UIView *borderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0,
            TFTextFieldBorderWidth,
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


