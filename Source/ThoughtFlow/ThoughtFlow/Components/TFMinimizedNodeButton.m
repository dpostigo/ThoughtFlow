//
// Created by Dani Postigo on 7/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "TFMinimizedNodeButton.h"
#import "TFBaseNodeView.h"


@interface TFMinimizedNodeButton ()

@property(nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property(nonatomic, strong) NSLayoutConstraint *rightConstraint;
@end

@implementation TFMinimizedNodeButton {
    NSLayoutConstraint *_leftConstraint;
}

- (id) initWithFrame: (CGRect) frame {
    frame.size.width = TFNodeViewWidth;
    frame.size.height = TFNodeViewHeight;
    self = [super initWithFrame: frame];
    if (self) {

        [self _setup];

    }

    return self;
}


#pragma mark - Public

- (void) animateIn: (void (^)(BOOL finished)) completion {
    [self animate: YES completion: completion];
}

- (void) animateOut: (void (^)(BOOL finished)) completion {
    [self animate: NO completion: completion];
}

- (void) animate: (BOOL) isPresenting completion: (void (^)(BOOL finished)) completion {
    _bottomConstraint.constant = isPresenting ? -10 : 0;
    _leftConstraint.constant = isPresenting ? 10 : 0;

    [UIView animateWithDuration: 0.4
            delay: 0.0
            usingSpringWithDamping: 0.4
            initialSpringVelocity: -1.0
            options: UIViewAnimationOptionCurveLinear
            animations: ^{

                [self layoutIfNeeded];

            }
            completion: ^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }

            }];

}


#pragma mark - Setup


- (void) _setup {
    [self _setupGrayViews];
    [self _setupWhiteView];
    //    [self invalidateIntrinsicContentSize];

}

- (void) _setupGrayViews {
    UIView *grayView = [[UIView alloc] initWithFrame: self.bounds];
    grayView.top = 10;
    grayView.left = 10;
    grayView.backgroundColor = [UIColor lightGrayColor];
    grayView.userInteractionEnabled = NO;
    [self addSubview: grayView];
    grayView.translatesAutoresizingMaskIntoConstraints = NO;

    [self addConstraints: @[
            [NSLayoutConstraint constraintWithItem: grayView attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0],
            [NSLayoutConstraint constraintWithItem: grayView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0],
            [NSLayoutConstraint constraintWithItem: grayView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNodeViewWidth],
            [NSLayoutConstraint constraintWithItem: grayView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNodeViewHeight],
    ]];
}

- (void) _setupWhiteView {
    UIView *whiteView = [[UIView alloc] initWithFrame: self.bounds];
    whiteView.left = 10;
    whiteView.top = 10;
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.userInteractionEnabled = NO;
    [self addSubview: whiteView];
    whiteView.translatesAutoresizingMaskIntoConstraints = NO;


    _leftConstraint = [NSLayoutConstraint constraintWithItem: whiteView attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0];
    _rightConstraint = [NSLayoutConstraint constraintWithItem: whiteView attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0];
    _bottomConstraint = [NSLayoutConstraint constraintWithItem: whiteView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0];

    [self addConstraints: @[
            _bottomConstraint,
            _rightConstraint,
            _leftConstraint ,
            [NSLayoutConstraint constraintWithItem: whiteView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0],
            [NSLayoutConstraint constraintWithItem: whiteView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNodeViewWidth],
            [NSLayoutConstraint constraintWithItem: whiteView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNodeViewHeight],

    ]];
}


@end