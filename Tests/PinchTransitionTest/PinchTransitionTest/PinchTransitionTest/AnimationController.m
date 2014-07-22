//
// Created by Dani Postigo on 7/22/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "AnimationController.h"


@implementation AnimationController

- (void) presentWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super presentWithContext: context];

    UIView *containerView = context.containerView;
    UIView *sourceView = [self fromViewController: context].view;

    UIView *destinationView = [self toViewController: context].view;

    [destinationView removeFromSuperview];

    [context completeTransition: YES];

}

- (void) dismissWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super dismissWithContext: context];

    UIView *containerView = context.containerView;
    UIView *sourceView = [self fromViewController: context].view;

    UIView *destinationView = [self toViewController: context].view;

    [sourceView removeFromSuperview];

    [context completeTransition: YES];
}


@end