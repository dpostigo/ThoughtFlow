//
// Created by Dani Postigo on 7/22/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "InteractionController.h"
#import "UIGestureRecognizer+BlocksKit.h"


@interface InteractionController ()

@property(nonatomic) CGFloat startScale;
@property(nonatomic) BOOL shouldCompleteTransition;
@end

@implementation InteractionController

- (id) init {
    self = [super init];
    if (self) {

        _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget: self action: @selector(handlePinchGesture:)];

    }

    return self;
}


- (void) handlePinchGesture: (UIPinchGestureRecognizer *) recognizer {

    switch (recognizer.state) {

        case UIGestureRecognizerStateBegan : {
            _startScale = recognizer.scale;
            self.interactionInProgress = YES;

            break;
        }
        case UIGestureRecognizerStateChanged : {

            CGFloat fraction = 1.0 - recognizer.scale / _startScale;
            _shouldCompleteTransition = (fraction > 0.5);

            [self updateInteractiveTransition: fraction];
            break;
        }
        case UIGestureRecognizerStateEnded :
        case UIGestureRecognizerStateCancelled : {
            NSLog(@"%s", __PRETTY_FUNCTION__);
            self.interactionInProgress = NO;
            if (!_shouldCompleteTransition || recognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            }
            else {
                [self finishInteractiveTransition];
            }
            break;
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStatePossible:
            break;
    }

}


#pragma mark -  UIViewControllerInteractiveTransitioning
- (CGFloat) completionSpeed {
    return 1 - self.percentComplete;
}

- (UIViewAnimationCurve) completionCurve {
    return UIViewAnimationCurveEaseInOut;
}


#pragma mark - UIViewControllerInteractiveTransitioning

- (void) startInteractiveTransition: (id <UIViewControllerContextTransitioning>) transitionContext {

    NSLog(@"%s, transitionContext = %@", __PRETTY_FUNCTION__, transitionContext);

}

@end