//
// Created by Dani Postigo on 5/10/14.
//

#import "BasicAnimator.h"

@implementation BasicAnimator

@synthesize transitionDuration;
@synthesize isPresenting;

- (void) animateWithContext: (id <UIViewControllerContextTransitioning>) transitionContext {
    [transitionContext completeTransition: YES];
}


- (void) presentWithContext: (id <UIViewControllerContextTransitioning>) context {

}


- (void) dismissWithContext: (id <UIViewControllerContextTransitioning>) context {

}


#pragma mark Helpers

- (UIViewController *) toViewController: (id <UIViewControllerContextTransitioning>) transitionContext {
    return self.isPresenting ? [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey] : [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
}

- (UIViewController *) fromViewController: (id <UIViewControllerContextTransitioning>) transitionContext {
    return self.isPresenting ? [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey] : [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
}

#pragma mark UIViewControllerAnimatedTransitioning

- (NSTimeInterval) transitionDuration: (id <UIViewControllerContextTransitioning>) transitionContext {
    return self.transitionDuration == 0 ? 0.4 : self.transitionDuration;
}

- (void) animateTransition: (id <UIViewControllerContextTransitioning>) transitionContext {
    [self animateWithContext: transitionContext];
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