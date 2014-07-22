//
// Created by Dani Postigo on 5/22/14.
//

#import "BasicAnimator+Utils.h"


@implementation BasicAnimator (Utils)

- (CGRect) rectForDismissedState: (id) transitionContext size: (CGSize) size {
    UIViewController *fromViewController;
    UIView *containerView = [transitionContext containerView];
    if (self.presenting) fromViewController = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey]; else fromViewController = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    switch (fromViewController.interfaceOrientation) {
        case UIInterfaceOrientationLandscapeRight:
            return CGRectMake(-size.height, 0, size.height, containerView.bounds.size.height);
        case UIInterfaceOrientationLandscapeLeft:
            return CGRectMake(containerView.bounds.size.width, 0, size.height, containerView.bounds.size.height);
        case UIInterfaceOrientationPortraitUpsideDown:
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