//
// Created by Dani Postigo on 7/22/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "AnimationController.h"


@implementation AnimationController

- (void) presentWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super presentWithContext: context];

    NSLog(@"%s", __PRETTY_FUNCTION__);

    UIView *containerView = context.containerView;
    UIView *sourceView = [self fromViewController: context].view;
    UIView *destinationView = [self toViewController: context].view;

    [containerView addSubview: sourceView];
    [containerView addSubview: destinationView];

    [context completeTransition: YES];

}

- (void) dismissWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super dismissWithContext: context];

    NSLog(@"%s", __PRETTY_FUNCTION__);
    UIView *containerView = context.containerView;
    UIView *sourceView = [self fromViewController: context].view;
    UIView *destinationView = [self toViewController: context].view;

    [containerView addSubview: destinationView];
    [containerView addSubview: sourceView];

    [destinationView removeFromSuperview];

    [context completeTransition: YES];
}


@end