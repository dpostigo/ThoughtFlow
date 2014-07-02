//
// Created by Dani Postigo on 7/1/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-UIView/UIView+DPConstraints.h>
#import "TFContentView.h"
#import "UIView+DPKit.h"
#import "TFNewDrawerController.h"

@implementation TFContentView

- (void) awakeFromNib {
    [super awakeFromNib];

    self.clipsToBounds = YES;
    _leftContainerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 290, self.height)];
    _leftContainerView.backgroundColor = [UIColor blackColor];
    _leftContainerView.translatesAutoresizingMaskIntoConstraints = NO;

    _rightContainerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 450, self.height)];
    _rightContainerView.backgroundColor = [UIColor blackColor];
    _rightContainerView.translatesAutoresizingMaskIntoConstraints = NO;

}


- (void) openLeftContainer {
    [self openLeftContainer: nil];
}

- (void) openLeftContainer: (void (^)()) completion {
    if (_leftContainerView.superview) {
        [self closeLeftContainer: nil];
        return;
    }

    _leftContainerView.left = -_leftContainerView.width;
    [self addSubview: _leftContainerView];

    [self addConstraints: @[
            [NSLayoutConstraint constraintWithItem: _leftContainerView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: 290.0],
            [NSLayoutConstraint constraintWithItem: _leftContainerView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _leftContainerView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0]
    ]];

    [_leftContainerView updateSuperLeadingConstraint: -_leftContainerView.width];
    [self layoutIfNeeded];
    [_leftContainerView updateSuperLeadingConstraint: 0];

    [UIView animateWithDuration: 0.4
            delay: 0.0
            usingSpringWithDamping: 0.9
            initialSpringVelocity: 1.0
            options: UIViewAnimationOptionCurveLinear
            animations: ^{
                [self layoutIfNeeded];
            }
            completion: ^(BOOL finished) {
                [self _notifyDidOpenLeftController: _leftDrawerController];

                if (completion) {
                    completion();
                }

            }];

}


- (void) openRightContainer {
    [self openRightContainer: nil];
}

- (void) openRightContainer: (void (^)()) completion {
    if (_rightContainerView.superview) {
        [self closeRightContainer: nil];
        return;
    }

    _rightContainerView.left = self.width;
    [self addSubview: _rightContainerView];

    [self addConstraints: @[
            [NSLayoutConstraint constraintWithItem: _rightContainerView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: 450.0],
            [NSLayoutConstraint constraintWithItem: _rightContainerView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _rightContainerView attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _rightContainerView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0]
    ]];

    [_rightContainerView updateSuperTrailingConstraint: _rightContainerView.width];
    [self layoutIfNeeded];
    [_rightContainerView updateSuperTrailingConstraint: 0];

    [UIView animateWithDuration: 0.4
            delay: 0.0
            usingSpringWithDamping: 0.8
            initialSpringVelocity: 2.0
            options: UIViewAnimationOptionCurveLinear
            animations: ^{
                [self layoutIfNeeded];
            }
            completion: ^(BOOL finished) {

                [self _notifyDidOpenRightController: _rightDrawerController];
                if (completion) {
                    completion();
                }
            }];

}

- (void) closeLeftContainer: (void (^)()) completion {

    [_leftContainerView updateSuperLeadingConstraint: -_leftContainerView.width];
    [UIView animateWithDuration: 0.4
            delay: 0.0
            usingSpringWithDamping: 0.8
            initialSpringVelocity: 2.0
            options: UIViewAnimationOptionCurveLinear
            animations: ^{
                [self layoutIfNeeded];
            }
            completion: ^(BOOL finished) {

                [self _notifyDidCloseLeftController: _leftDrawerController];
                if (_leftDrawerController.parentViewController) {
                    [_leftDrawerController removeFromParentViewController];
                }
                self.leftDrawerController = nil;
                [_leftContainerView removeFromSuperview];

                if (completion) {
                    completion();
                }

            }];
}


- (void) closeRightContainer: (void (^)()) completion {

    [_rightContainerView updateSuperTrailingConstraint: _rightContainerView.width];
    [UIView animateWithDuration: 0.4
            delay: 0.0
            usingSpringWithDamping: 0.8
            initialSpringVelocity: 2.0
            options: UIViewAnimationOptionCurveLinear
            animations: ^{
                [self layoutIfNeeded];
            }
            completion: ^(BOOL finished) {

                [self _notifyDidCloseLeftController: _rightDrawerController];
                self.rightDrawerController = nil;
                [_rightContainerView removeFromSuperview];

                if (completion) {
                    completion();
                }
            }];
}


- (void) setLeftDrawerController: (TFNewDrawerController *) leftDrawerController {
    if (_leftDrawerController && _leftDrawerController.view.superview) {
        [_leftDrawerController.view removeFromSuperview];
    }

    _leftDrawerController = leftDrawerController;

    if (_leftDrawerController) {
        _leftDrawerController.drawerDelegate = self;

        UIView *view = _leftDrawerController.view;
        view.frame = _leftContainerView.bounds;
        [_leftContainerView addSubview: view];
        view.translatesAutoresizingMaskIntoConstraints = NO;

        [_leftContainerView addConstraints: @[
                [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: _leftContainerView attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
                [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: _leftContainerView attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0.0],
                [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: _leftContainerView attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0],
                [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: _leftContainerView attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0]
        ]];
    }
}


- (void) setRightDrawerController: (TFNewDrawerController *) rightDrawerController {

    if (_rightDrawerController && _rightDrawerController.view.superview) {
        [_rightDrawerController.view removeFromSuperview];
    }

    _rightDrawerController = rightDrawerController;

    if (_rightDrawerController) {
        _rightDrawerController.drawerDelegate = self;
        UIView *view = _rightDrawerController.view;
        view.frame = _rightContainerView.bounds;
        [_rightContainerView addSubview: view];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [_rightContainerView addConstraints: @[
                [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: _rightContainerView attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
                [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: _rightContainerView attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0.0],
                [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: _rightContainerView attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0],
                [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: _rightContainerView attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0]
        ]];
    }
}


#pragma mark - TFNewDrawerControllerDelegate

- (void) drawerControllerShouldDismiss: (TFNewDrawerController *) drawerController {

    if (drawerController == _leftDrawerController) {
        [self closeLeftContainer: ^{
        }];

    } else if (drawerController == _rightDrawerController) {
        [self closeRightContainer: ^{
        }];

    }
}



#pragma mark - Notify

- (void) _notifyDidOpenLeftController: (TFNewDrawerController *) leftController {
    if (_delegate && [_delegate respondsToSelector: @selector(contentView:didOpenLeftController:)]) {
        [_delegate contentView: self didOpenLeftController: leftController];
    }
}


- (void) _notifyDidOpenRightController: (TFNewDrawerController *) rightController {
    if (_delegate && [_delegate respondsToSelector: @selector(contentView:didOpenRightController:)]) {
        [_delegate contentView: self didOpenRightController: rightController];
    }
}


- (void) _notifyDidCloseLeftController: (TFNewDrawerController *) leftController {
    if (_delegate && [_delegate respondsToSelector: @selector(contentView:didCloseLeftController:)]) {
        [_delegate contentView: self didCloseLeftController: leftController];
    }
}

- (void) _notifyDidCloseRightController: (TFNewDrawerController *) rightController {
    if (_delegate && [_delegate respondsToSelector: @selector(contentView:didCloseRightController:)]) {
        [_delegate contentView: self didCloseRightController: rightController];
    }
}
@end