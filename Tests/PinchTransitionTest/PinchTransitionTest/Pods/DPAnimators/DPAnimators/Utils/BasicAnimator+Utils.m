//
// Created by Dani Postigo on 5/22/14.
//

#import "BasicAnimator+Utils.h"
#import "NSObject+InterfaceUtils.h"

@implementation BasicAnimator (Utils)

- (NSString *) toOrientationAsString: (id <UIViewControllerContextTransitioning>) context {
    return [self stringForInterfaceOrientation: [self toOrientation: context]];
}

- (NSString *) fromOrientationAsString: (id <UIViewControllerContextTransitioning>) context {
    return [self stringForInterfaceOrientation: [self fromOrientation: context]];
}

- (UIInterfaceOrientation) toOrientation: (id <UIViewControllerContextTransitioning>) context {
    return [self toViewController: context].interfaceOrientation;
}

- (UIInterfaceOrientation) fromOrientation: (id <UIViewControllerContextTransitioning>) context {
    return [self fromViewController: context].interfaceOrientation;
}

- (CGRect) rectForDismissedState: (id) transitionContext size: (CGSize) size {
    UIViewController *fromViewController;
    UIView *containerView = [transitionContext containerView];
    if (self.presenting) fromViewController = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey]; else fromViewController = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    switch (fromViewController.interfaceOrientation) {
        case UIInterfaceOrientationLandscapeRight :
            return CGRectMake(-size.height,
                    0,
                    size.height,
                    containerView.bounds.size.height);
            break;

        case UIInterfaceOrientationLandscapeLeft :
            return CGRectMake(containerView.bounds.size.width,
                    0,
                    size.height,
                    containerView.bounds.size.height);
            break;

        case UIInterfaceOrientationPortraitUpsideDown :
            return CGRectMake(0, -size.height, containerView.bounds.size.width, size.height);
        case UIInterfaceOrientationPortrait:
            return CGRectMake(0, containerView.bounds.size.height, containerView.bounds.size.width, size.height);
        default:
            return CGRectZero;
    }
}

- (CGRect) rectForPresentedState: (id) transitionContext size: (CGSize) size {
    UIViewController *fromViewController;
    if (self.presenting) fromViewController = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey]; else fromViewController = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    switch (fromViewController.interfaceOrientation) {
        case UIInterfaceOrientationLandscapeRight:
            return CGRectOffset([self rectForDismissedState: transitionContext size: size], size.height, 0);
        case UIInterfaceOrientationLandscapeLeft:
            return CGRectOffset([self rectForDismissedState: transitionContext size: size], -size.height, 0);
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGRectOffset([self rectForDismissedState: transitionContext size: size], 0, size.height);
        case UIInterfaceOrientationPortrait:
            return CGRectOffset([self rectForDismissedState: transitionContext size: size], 0, -size.height);
        default:
            return CGRectZero;
    }
}


@end