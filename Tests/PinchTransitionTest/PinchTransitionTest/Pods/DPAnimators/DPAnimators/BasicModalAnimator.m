//
// Created by Dani Postigo on 5/25/14.
//

#import "BasicModalAnimator.h"

@implementation BasicModalAnimator

- (void) animateWithContext: (id <UIViewControllerContextTransitioning>) transitionContext {
    if (self.isPresenting) {
        [self presentWithContext: transitionContext];
    } else {
        [self dismissWithContext: transitionContext];
    }
}

#pragma mark UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController: (UIViewController *) presented presentingController: (UIViewController *) presenting sourceController: (UIViewController *) source {
    self.isPresenting = YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController: (UIViewController *) dismissed {
    self.isPresenting = NO;
    return self;
}


@end