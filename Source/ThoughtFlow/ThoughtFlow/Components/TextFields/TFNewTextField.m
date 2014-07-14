//
// Created by Dani Postigo on 7/13/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import <DPKit-UIFont/UIFont+DPKitFonts.h>
#import "TFNewTextField.h"
#import "TFBarButtonItem.h"
#import "UIView+DPConstraints.h"
#import "TFString.h"
#import "UIColor+TFApp.h"


@interface TFNewTextFieldObject : NSObject <UITextFieldDelegate>

@property(nonatomic, strong) NSMutableDictionary *colors;
@property(nonatomic, assign) id <UITextFieldDelegate> delegate;
@property(nonatomic) BOOL editable;
@end

@implementation TFNewTextFieldObject

- (id) init {
    self = [super init];
    if (self) {

        _colors = [[NSMutableDictionary alloc] init];
    }

    return self;
}


- (void) setTextColor: (UIColor *) color forState: (UIControlState) state {
    [_colors setObject: color forKey: @(state)];
}

- (UIColor *) textColorForState: (UIControlState) state {
    UIColor *color = [_colors objectForKey: @(state)];
    if (color == nil) {
        color = [_colors objectForKey: @(UIControlStateNormal)];
    }
    return color;
}

- (BOOL) textFieldShouldBeginEditing: (UITextField *) textField {
    return _editable;
}

- (void) textFieldDidBeginEditing: (UITextField *) textField {
    if (_delegate && [_delegate respondsToSelector: @selector(textFieldDidBeginEditing:)]) {
        [_delegate textFieldDidBeginEditing: textField];
    }
    textField.textColor = [self textColorForState: UIControlStateSelected];
}

//- (BOOL) textFieldShouldEndEditing: (UITextField *) textField {
//    return !_editable;
//}

- (void) textFieldDidEndEditing: (UITextField *) textField {
    if (_delegate && [_delegate respondsToSelector: @selector(textFieldDidEndEditing:)]) {
        [_delegate textFieldDidEndEditing: textField];
    }

    textField.textColor = [self textColorForState: UIControlStateNormal];
}

//- (BOOL) textField: (UITextField *) textField shouldChangeCharactersInRange: (NSRange) range replacementString: (NSString *) string {
//    return NO;
//}
//
//- (BOOL) textFieldShouldClear: (UITextField *) textField {
//    return NO;
//}

- (BOOL) textFieldShouldReturn: (UITextField *) textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (_delegate && [_delegate respondsToSelector: @selector(textFieldShouldReturn:)]) {
        NSLog(@"_delegate = %@", _delegate);
        return [_delegate textFieldShouldReturn: textField];
    }
    return YES;
}


@end


@interface TFNewTextField ()

@property(nonatomic, strong) TFNewTextFieldObject *handler;
@property(nonatomic, strong) UIImageView *imageView;

@property(nonatomic, strong) UIView *imageContainer;
@end

@implementation TFNewTextField

- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self _setup];
        [self _setupLeftView];
        [self _setupRightView];
    }

    return self;
}

- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
        [self _setup];
    }
    return self;
}


- (void) awakeFromNib {
    [super awakeFromNib];
    [self _setupLeftView];
    [self _setupRightView];
}


#pragma mark - Delegate

- (void) setDelegate: (id <UITextFieldDelegate>) delegate {
    _handler.delegate = delegate;

    if ([delegate conformsToProtocol: @protocol(TFNewTextFieldDelegate)]) {
        _textFieldDelegate = (id <TFNewTextFieldDelegate>) delegate;
    }
}


- (void) setTextColor: (UIColor *) textColor {
    [super setTextColor: textColor];
}


- (void) setTextColor: (UIColor *) color forState: (UIControlState) state {
    [_handler setTextColor: color forState: state];
}

- (UIColor *) colorForState: (UIControlState) state {
    return [_handler textColorForState: state];
}

- (UIImage *) image {
    return _imageView.image;
}

- (void) setImage: (UIImage *) image {
    _imageView.image = image;
    [_imageView updateWidthConstraint: image.size.width];
    [_imageView updateHeightConstraint: image.size.height];

}

- (void) setImageInsets: (UIEdgeInsets) imageInsets {
    _imageInsets = imageInsets;

    UIImage *image = _imageView.image;
    CGRect rect = CGRectMake(0, 0, image.size.width + _imageInsets.left + _imageInsets.right, image.size.height + _imageInsets.top + _imageInsets.bottom);
    _imageContainer = [[UIView alloc] initWithFrame: rect];
    [_imageContainer embedView: _imageView withInsets: _imageInsets];

    self.leftView = _imageContainer;
}


- (void) setEditable: (BOOL) editable {
    _editable = editable;
    if (_editable) {
        [self _setupRightView];
    } else {
        self.rightView = nil;
    }
}


#pragma mark - Setup

- (void) _setup {
    _editable = YES;
    _handler = [[TFNewTextFieldObject alloc] init];
    super.delegate = _handler;

}

- (void) _setupLeftView {
    _imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"email-icon"]];

    UIImage *image = _imageView.image;
    CGRect rect = CGRectMake(0, 0, image.size.width + _imageInsets.left + _imageInsets.right, image.size.height + _imageInsets.top + _imageInsets.bottom);
    _imageContainer = [[UIView alloc] initWithFrame: rect];
    [_imageContainer embedView: _imageView withInsets: _imageInsets];

    self.leftView = _imageContainer;
    self.leftViewMode = UITextFieldViewModeAlways;

}

- (void) _setupRightView {
    UIButton *button = [TFBarButtonItem defaultButton];


    NSDictionary *normalAttributes = [TFString attributesWithAttributes: nil
            font: [UIFont gothamRoundedLightFontOfSize: 10.0]
            color: [UIColor whiteColor]
            kerning: 100
            lineSpacing: 1
            textAlignment: NSTextAlignmentCenter];

    NSDictionary *selectedAttributes = [TFString attributesWithAttributes: nil
            font: [UIFont gothamRoundedLightFontOfSize: 10.0]
            color: [UIColor tfGreenColor]
            kerning: 100
            lineSpacing: 1
            textAlignment: NSTextAlignmentCenter];


    NSAttributedString *normalString = [[NSAttributedString alloc] initWithString: @"EDIT" attributes: normalAttributes];
    NSAttributedString *selectedString = [[NSAttributedString alloc] initWithString: @"SAVE" attributes: selectedAttributes];
    [button setAttributedTitle: normalString forState: UIControlStateNormal];
    [button setAttributedTitle: selectedString forState: UIControlStateSelected];

    [button addTarget: self action: @selector(handleLeftButton:) forControlEvents: UIControlEventTouchUpInside];
    [button setContentHorizontalAlignment: UIControlContentHorizontalAlignmentCenter];

    self.rightView = button;
    self.rightViewMode = UITextFieldViewModeAlways;
    //    self.rightViewMode = UITextFieldViewModeUnlessEditing;

    //    self.clearButtonMode = UITextFieldViewModeAlways;
}

- (void) handleLeftButton: (UIButton *) button {
    if (!_editable) return;

    button.selected = !button.selected;
    _handler.editable = button.selected;

    if (button.selected) {
        [self becomeFirstResponder];
    } else {
        [self resignFirstResponder];
        [self _notifyDidSave];
    }
}


#pragma mark - Notify

- (void) _notifyDidSave {
    if (_textFieldDelegate && [_textFieldDelegate respondsToSelector: @selector(textFieldDidSave:)]) {
        [_textFieldDelegate textFieldDidSave: self];
    }
}

@end