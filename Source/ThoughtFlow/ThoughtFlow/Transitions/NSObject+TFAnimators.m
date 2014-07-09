//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "NSObject+TFAnimators.h"


@implementation NSObject (TFAnimators)

- (UIViewController *) toViewController: (id <UIViewControllerContextTransitioning>) transitionContext presenting: (BOOL) presenting {
    return presenting ? [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey] : [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
}

- (UIViewController *) fromViewController: (id <UIViewControllerContextTransitioning>) transitionContext presenting: (BOOL) presenting {
    return presenting ? [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey] : [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
}
@end