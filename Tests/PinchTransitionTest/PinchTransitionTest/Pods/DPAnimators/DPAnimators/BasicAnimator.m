//
// Created by Dani Postigo on 5/10/14.
//

#import "BasicAnimator.h"


@implementation BasicAnimator

@synthesize isPresenting;
@synthesize releasesAnimator;

- (id) init {
    self = [super init];
    if (self) {
        _transitionDuration = 0.4;

    }

    return self;
}

- (void) animateWithContext: (id <UIViewControllerContextTransitioning>) transitionContext {
    [transitionContext completeTransition: YES];
}


- (void) presentWithContext: (id <UIViewControllerContextTransitioning>) context {

}


- (void) dismissWithContext: (id <UIViewControllerContextTransitioning>) context {

}

- (void) animationEnded: (BOOL) transitionCompleted {

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
    return _transitionDuration;
}

- (void) animateTransition: (id <UIViewControllerContextTransitioning>) transitionContext {
    [self animateWithContext: transitionContext];
}


@end