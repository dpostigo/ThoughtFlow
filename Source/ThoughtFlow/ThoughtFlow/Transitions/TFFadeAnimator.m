//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFFadeAnimator.h"
#import "NSObject+TFAnimators.h"


static const NSInteger TFSnapshotTag = 100004;

@implementation TFFadeAnimator

- (NSTimeInterval) transitionDuration: (id <UIViewControllerContextTransitioning>) transitionContext {
    return 0.4;
}

- (void) animateTransition: (id <UIViewControllerContextTransitioning>) context {
    UIView *containerView = context.containerView;
    UIView *sourceView = [self fromViewController: context presenting: _presenting].view;
    UIView *destinationView = [self toViewController: context presenting: _presenting].view;


    if (_presenting) {


        containerView.backgroundColor = [UIColor clearColor];
        containerView.opaque = NO;

        UIView *move = [sourceView snapshotViewAfterScreenUpdates: YES];
        move.frame = sourceView.frame;
        move.tag = TFSnapshotTag;
        [containerView addSubview: move];
        [containerView addSubview: sourceView];
        [containerView addSubview: destinationView];

        destinationView.alpha = 0;

        [UIView animateWithDuration: [self transitionDuration: context] animations: ^{
            destinationView.alpha = 1;
            sourceView.alpha = 0;

        } completion: ^(BOOL finished) {
            [sourceView removeFromSuperview];
            sourceView.alpha = 1;
            [context completeTransition: YES];
        }];
    }
}

@end