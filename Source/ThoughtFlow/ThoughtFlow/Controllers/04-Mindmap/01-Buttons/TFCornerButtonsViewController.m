//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/DPPassThroughView.h>
#import "TFCornerButtonsViewController.h"


@implementation TFCornerButtonsViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {

        self.view = [[DPPassThroughView alloc] init];
        _edgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    }

    return self;
}


#pragma mark - Buttons

- (void) handleButton: (UIButton *) button {

    TFCornerType type = TFCornerTypeNone;

    if (button == _topLeftButton) {
        type = TFCornerTypeTopLeft;

    } else if (button == _topRightButton) {
        type = TFCornerTypeTopRight;

    } else if (button == _bottomLeftButton) {
        type = TFCornerTypeBottomLeft;

    } else if (button == _bottomRightButton) {
        type = TFCornerTypeBottomRight;
    }

    [self _notifyClickedButtonWithType: type];

}

- (void) _notifyClickedButtonWithType: (TFCornerType) type {
    if (_delegate && [_delegate respondsToSelector: @selector(buttonsController:clickedButtonWithType:)]) {
        [_delegate buttonsController: self clickedButtonWithType: type];
    }
}

- (UIButton *) topLeftButton {
    if (_topLeftButton == nil) {
        _topLeftButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [self.view addSubview: _topLeftButton];
        _topLeftButton.translatesAutoresizingMaskIntoConstraints = NO;

        [self.view addConstraints: @[
                [NSLayoutConstraint constraintWithItem: _topLeftButton attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.topLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: _edgeInsets.top],
                [NSLayoutConstraint constraintWithItem: _topLeftButton attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: _edgeInsets.left]
        ]];

        [_topLeftButton addTarget: self action: @selector(handleButton:) forControlEvents: UIControlEventTouchUpInside];
    }
    return _topLeftButton;
}

- (UIButton *) topRightButton {
    if (_topRightButton == nil) {
        _topRightButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [self.view addSubview: _topRightButton];
        _topRightButton.translatesAutoresizingMaskIntoConstraints = NO;

        [self.view addConstraints: @[
                [NSLayoutConstraint constraintWithItem: _topRightButton attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.topLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: _edgeInsets.top],
                [NSLayoutConstraint constraintWithItem: _topRightButton attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: -_edgeInsets.right]
        ]];
        [_topRightButton addTarget: self action: @selector(handleButton:) forControlEvents: UIControlEventTouchUpInside];

    }
    return _topRightButton;
}

- (UIButton *) bottomRightButton {
    if (_bottomRightButton == nil) {
        _bottomRightButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [self.view addSubview: _bottomRightButton];
        _bottomRightButton.translatesAutoresizingMaskIntoConstraints = NO;

        [self.view addConstraints: @[
                [NSLayoutConstraint constraintWithItem: _bottomRightButton attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self.bottomLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: -_edgeInsets.bottom],
                [NSLayoutConstraint constraintWithItem: _bottomRightButton attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: -_edgeInsets.right]
        ]];
        [_bottomRightButton addTarget: self action: @selector(handleButton:) forControlEvents: UIControlEventTouchUpInside];

    }
    return _bottomRightButton;
}


@end