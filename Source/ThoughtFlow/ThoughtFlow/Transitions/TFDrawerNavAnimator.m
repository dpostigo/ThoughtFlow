//
// Created by Dani Postigo on 6/14/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFDrawerNavAnimator.h"
#import "UIView+DPConstraints.h"
#import "UIView+DPKit.h"
#import "UIView+DPKitDebug.h"

@implementation TFDrawerNavAnimator

@synthesize presentationOffset;
@synthesize viewSize;
@synthesize presentationEdge;
@synthesize dismissCompletionBlock;

- (void) presentWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super presentWithContext: context];

    UIView *containerView = context.containerView;
    UIView *sourceView = [self fromViewController: context].view;
    UIView *destinationView = [self toViewController: context].view;
    snapshot = [self getSnapshotForSourceController: [self fromViewController: context]];

    [containerView addSubview: sourceView];
    [containerView addSubview: snapshot];
    [containerView addSubview: destinationView];

    destinationView.width = viewSize.width == 0 ? containerView.width : viewSize.width;
    destinationView.height = viewSize.height == 0 ? containerView.height : viewSize.height;
    //    destinationView.left = -destinationView.width;

    //    [containerView addDebugBorder: [UIColor redColor]];
    //    [destinationView addDebugBorder: [UIColor blueColor]];

    destinationView.translatesAutoresizingMaskIntoConstraints = NO;
    [destinationView updateWidthConstraint: viewSize.width];
    [destinationView updateSuperTopConstraint: 0];
    [destinationView updateSuperBottomConstraint: 0];
    [self positionDestinationView: destinationView inContainerView: containerView];
    [containerView layoutIfNeeded];

    [self animateDestinationView: destinationView];

    [UIView animateWithDuration: [self transitionDuration: context]
            delay: 0.0f
            usingSpringWithDamping: 0.8
            initialSpringVelocity: 2.0f
            options: UIViewAnimationOptionCurveLinear
            animations: ^{
                [containerView layoutIfNeeded];
            }
            completion: ^(BOOL finished) {
                [context completeTransition: YES];
            }];

}

- (void) dismissWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super dismissWithContext: context];

    UIView *containerView = context.containerView;
    UIView *sourceView = [self fromViewController: context].view;
    UIView *destinationView = [self toViewController: context].view;

    [containerView addSubview: sourceView];
    [containerView addSubview: destinationView];

    //    [self animateDestinationView: destinationView];
    //    [containerView layoutIfNeeded];


    [self dismissDestinationView: destinationView];

    UIViewController *sourceController = [self fromViewController: context];

    //        sourceView.frame = containerView.bounds;
    //        sourceView.translatesAutoresizingMaskIntoConstraints = NO;
    //    [sourceView updateSuperTopConstraint: 0];
    //    [sourceView updateSuperLeadingConstraint: 0];
    //    [sourceView updateSuperTrailingConstraint: 0];
    //    [sourceView updateSuperBottomConstraint: 0];

    [UIView animateWithDuration: [self transitionDuration: context]
            delay: 0.0f
            usingSpringWithDamping: 0.8
            initialSpringVelocity: 2.0f
            options: UIViewAnimationOptionCurveLinear
            animations: ^{
                [containerView layoutIfNeeded];

            }
            completion: ^(BOOL finished) {

                if (snapshot && snapshot.superview) [snapshot removeFromSuperview];
                [destinationView removeFromSuperview];
                [context completeTransition: YES];
                //                if (dismissCompletionBlock) {
                //                    dismissCompletionBlock();
                //                }
            }];

}


- (void) positionDestinationView: (UIView *) destinationView inContainerView: (UIView *) containerView {
    if (presentationEdge == UIRectEdgeLeft) {
        destinationView.left = -viewSize.width;
        [destinationView updateSuperLeadingConstraint: -viewSize.width];
    } else if (presentationEdge == UIRectEdgeRight) {
        destinationView.left = containerView.width;
        [destinationView updateSuperTrailingConstraint: -viewSize.width];
    }
}


- (void) animateDestinationView: (UIView *) destinationView {
    if (presentationEdge == UIRectEdgeLeft) {
        [destinationView updateSuperLeadingConstraint: 0];
    } else if (presentationEdge == UIRectEdgeRight) {
        [destinationView updateSuperTrailingConstraint: 0];
    }
}


- (void) dismissDestinationView: (UIView *) destinationView {
    NSLayoutConstraint *constraint = [self animationConstraintForDestinationView: destinationView];
    if (constraint) {
        if (presentationEdge == UIRectEdgeLeft) {
            [destinationView updateSuperLeadingConstraint: -destinationView.width];
        } else if (presentationEdge == UIRectEdgeRight) {
            [destinationView updateSuperTrailingConstraint: -destinationView.width];
        }
    }

}

- (NSLayoutConstraint *) animationConstraintForDestinationView: (UIView *) destinationView {
    NSLayoutConstraint *ret = nil;
    if (presentationEdge == UIRectEdgeLeft) {
        ret = destinationView.superLeadingConstraint;
    } else if (presentationEdge == UIRectEdgeRight) {
        ret = destinationView.superTrailingConstraint;
    }

    ret.constant = 0;
    return ret;
}


- (UIView *) getSnapshotForSourceController: (UIViewController *) controller {
    UIView *ret = nil;

    if (controller.navigationController) {
        ret = [controller.navigationController.view snapshotViewAfterScreenUpdates: NO];
    } else {
        ret = [controller.view snapshotViewAfterScreenUpdates: NO];
    }


    return ret;
}



@end