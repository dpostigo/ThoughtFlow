//
// Created by Dani Postigo on 5/25/14.
//

#import "BasicNavigationAnimator.h"


@implementation BasicNavigationAnimator

- (void) animateWithContext: (id <UIViewControllerContextTransitioning>) transitionContext {
    if (self.isPresenting) {
        [self presentWithContext: transitionContext];
    } else {


        [self dismissWithContext: transitionContext];
    }
}


- (id <UIViewControllerAnimatedTransitioning>) navigationController: (UINavigationController *) navigationController animationControllerForOperation: (UINavigationControllerOperation) operation fromViewController: (UIViewController *) fromVC toViewController: (UIViewController *) toVC {
    if (operation == UINavigationControllerOperationPush) {
        self.isPresenting = YES;

    } else if (operation == UINavigationControllerOperationPop) {
        self.isPresenting = NO;
    }
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>) navigationController: (UINavigationController *) navigationController interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>) animationController {
    return nil;
}

@end