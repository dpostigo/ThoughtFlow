//
// Created by Dani Postigo on 7/15/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <BlocksKit/UIControl+BlocksKit.h>
#import <DPKit-Utils/UIView+DPKitDebug.h>
#import "TFCharacterCountTextField.h"


@interface TFCharacterCountTextField ()

@property(nonatomic, strong) NSArray *labelConstraints;
@property(nonatomic, strong) UIView *countRightView;
@end

@implementation TFCharacterCountTextField

- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self _setup];
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

    [self _setupRightView];
    [self _refreshCharactersLabel: nil];
}





#pragma mark - Setters

- (void) setCharacterCountInsets: (UIEdgeInsets) characterCountInsets {
    _characterCountInsets = characterCountInsets;
    [self _refreshConstraints];
}

- (void) setCharacterLimit: (NSInteger) characterLimit {
    _characterLimit = characterLimit;
    [self _refreshCharactersLabel: nil];
}


- (void) setUpdateBlock: (void (^)(NSInteger)) updateBlock {
    _updateBlock = updateBlock;
    [self _refreshCharactersLabel: nil];
}



#pragma mark - Getters

- (NSInteger) charactersLeft {
    return _characterLimit - [self.text length];
}

#pragma mark - Setup

- (void) _setup {

    //    _recalculatesBounds = YES;

    _textLabel = [[UILabel alloc] init];
    _textLabel.text = [NSString stringWithFormat: @"%i", _characterLimit];
    _textLabel.textColor = self.textColor;
    _textLabel.font = self.font;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [_textLabel sizeToFit];

    [self _setupUpdateBlock];

}

- (void) _setupUpdateBlock {
    __weak __typeof__ (self) weakSelf = self;
    _updateBlock = ^(NSInteger charactersLeft) {
        __strong __typeof__ (self) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.textLabel.text = [NSString stringWithFormat: @"%i", charactersLeft];
        }
    };

    [self bk_addEventHandler: ^(id sender) {
        NSInteger charactersLeft = _characterLimit - [self.text length];
        _updateBlock(charactersLeft);
    } forControlEvents: UIControlEventEditingChanged];
}

- (void) _setupRightView {

    _textLabel.text = [NSString stringWithFormat: @"%i", _characterLimit];
    [_textLabel sizeToFit];

    CGRect bounds = CGRectInset(_textLabel.bounds, -(_characterCountInsets.left + _characterCountInsets.right), -(_characterCountInsets.top + _characterCountInsets.bottom));
    _countRightView = [[UIView alloc] initWithFrame: bounds];
    [_countRightView addSubview: _textLabel];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self _refreshConstraints];
    self.rightView = _countRightView;
    self.rightViewMode = UITextFieldViewModeAlways;

    //    [_countRightView addDebugBorder: [UIColor redColor]];
    //    [_textLabel addDebugBorder: [UIColor yellowColor]];

}


#pragma mark - Refresh

- (void) _refreshConstraints {
    if (_labelConstraints) {
        [_countRightView removeConstraints: _labelConstraints];
    }

    _labelConstraints = @[
            [NSLayoutConstraint constraintWithItem: _textLabel attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: _textLabel.superview attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: _characterCountInsets.left],
            [NSLayoutConstraint constraintWithItem: _textLabel attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: _textLabel.superview attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: -_characterCountInsets.right],
            [NSLayoutConstraint constraintWithItem: _textLabel attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: _textLabel.superview attribute: NSLayoutAttributeTop multiplier: 1.0 constant: _characterCountInsets.top],
            [NSLayoutConstraint constraintWithItem: _textLabel attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: _textLabel.superview attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: -_characterCountInsets.bottom]
    ];

    //    _labelConstraints = @[
    //            [NSLayoutConstraint constraintWithItem: _textLabel attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem: _textLabel.superview attribute: NSLayoutAttributeCenterX multiplier: 1.0 constant: 0],
    //            [NSLayoutConstraint constraintWithItem: _textLabel attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: _textLabel.superview attribute: NSLayoutAttributeCenterY multiplier: 1.0 constant: 0]
    //    ];

    [_countRightView addConstraints: _labelConstraints];

}


- (void) _refreshUpdateBlock {

}


- (void) _refreshCharactersLabel: (id) sender {
    NSInteger charactersLeft = _characterLimit - [self.text length];

    if (_updateBlock) {
        _updateBlock(charactersLeft);
    }

}



#pragma mark - Overrides

- (CGRect) rightViewRectForBounds: (CGRect) bounds {
    CGRect ret = [super rightViewRectForBounds: bounds];

    if (self.rightView == _countRightView) {
        CGSize size = [_textLabel intrinsicContentSize];
        size.width = _characterLabelSize.width == 0 ? size.width : _characterLabelSize.width;
        size.height = _characterLabelSize.height == 0 ? size.height : _characterLabelSize.height;

        size.width += _characterCountInsets.left + _characterCountInsets.right;
        size.height += _characterCountInsets.top + _characterCountInsets.bottom;
        ret = CGRectMake(CGRectGetWidth(bounds) - size.width, (CGRectGetHeight(bounds) - size.height) / 2, size.width, size.height);
    }

    return ret;
}
@end