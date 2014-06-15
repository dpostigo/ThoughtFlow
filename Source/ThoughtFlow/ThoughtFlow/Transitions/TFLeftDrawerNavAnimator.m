//
// Created by Dani Postigo on 6/14/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFLeftDrawerNavAnimator.h"
#import "UIView+DPKit.h"
#import "UIView+DPConstraints.h"
#import "UIView+DPKitDebug.h"

@implementation TFLeftDrawerNavAnimator

- (void) presentWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super presentWithContext: context];

    UIView *containerView = context.containerView;
    UIView *sourceView = [self fromViewController: context].view;
    UIView *destinationView = [self toViewController: context].view;
    snapshot = [sourceView snapshotViewAfterScreenUpdates: NO];

    [containerView addSubview: sourceView];
    [containerView addSubview: snapshot];
    [containerView addSubview: destinationView];

    destinationView.width = viewSize.width == 0 ? containerView.width : viewSize.width;
    destinationView.height = viewSize.height == 0 ? containerView.height : viewSize.height;
    destinationView.left = -destinationView.width;

    [containerView addDebugBorder: [UIColor redColor]];
    [destinationView addDebugBorder: [UIColor blueColor]];

    BOOL useConstraints = NO;
    if (useConstraints) {
        destinationView.translatesAutoresizingMaskIntoConstraints = NO;
        [destinationView updateWidthConstraint: viewSize.width];
        [destinationView updateSuperTopConstraint: 0];
        [destinationView updateSuperBottomConstraint: 0];
        [destinationView updateSuperLeadingConstraint: 0];

        [UIView animateWithDuration: [self transitionDuration: context]
                delay: 0.0f
                usingSpringWithDamping: 0.8
                initialSpringVelocity: 2.0f
                options: UIViewAnimationOptionCurveLinear
                animations: ^{
                    destinationView.left = 0;

                }
                completion: ^(BOOL finished) {

                    //        [self positionDestinationView: destinationView inContainerView: containerView];
                    //                    [containerView layoutIfNeeded];
                    //                    [self animateDestinationView: destinationView];
                    [context completeTransition: YES];


                    //                    destinationView.translatesAutoresizingMaskIntoConstraints = NO;
                    //                    [destinationView updateWidthConstraint: viewSize.width];
                    //                    [destinationView updateSuperTopConstraint: 0];
                    //                    [destinationView updateSuperBottomConstraint: 0];
                    //                    [destinationView updateSuperLeadingConstraint: 0];
                }];

    } else {
        [UIView animateWithDuration: [self transitionDuration: context]
                delay: 0.0f
                usingSpringWithDamping: 0.8
                initialSpringVelocity: 2.0f
                options: UIViewAnimationOptionCurveLinear
                animations: ^{
                    destinationView.left = 0;
                }
                completion: ^(BOOL finished) {


                    //                    destinationView.translatesAutoresizingMaskIntoConstraints = NO;
                    //                    [destinationView updateWidthConstraint: viewSize.width];
                    //                    [destinationView updateSuperTopConstraint: 0];
                    //                    [destinationView updateSuperBottomConstraint: 0];
                    //                    [destinationView updateSuperLeadingConstraint: 0];
                    //
                    [context completeTransition: YES];
                }];

    }

}

- (void) dismissWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super dismissWithContext: context];

    NSLog(@"%s", __PRETTY_FUNCTION__);
    UIView *containerView = context.containerView;
    UIView *sourceView = [self fromViewController: context].view;
    UIView *destinationView = [self toViewController: context].view;

    [containerView addSubview: sourceView];
    [containerView addSubview: destinationView];
    [snapshot removeFromSuperview];

    NSLayoutConstraint *constraint = destinationView.superLeadingConstraint;
    NSLog(@"constraint = %@", constraint);

    if (constraint) {

        constraint.constant = -destinationView.width;

        [UIView animateWithDuration: [self transitionDuration: context]
                delay: 0.0f
                usingSpringWithDamping: 0.8
                initialSpringVelocity: 2.0f
                options: UIViewAnimationOptionCurveLinear
                animations: ^{
                    //                    destinationView.left = -destinationView.width;
                    [containerView layoutIfNeeded];

                }
                completion: ^(BOOL finished) {
                    [context completeTransition: YES];
                    if (dismissCompletionBlock) {
                        dismissCompletionBlock();
                    }
                }];

    }
}


- (void) positionDestinationView: (UIView *) destinationView inContainerView: (UIView *) containerView {
    if (presentationEdge == UIRectEdgeLeft) {
        [destinationView updateSuperLeadingConstraint: -viewSize.width];
    } else if (presentationEdge == UIRectEdgeRight) {
        [destinationView updateSuperTrailingConstraint: viewSize.width];
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
    if (presentationEdge == UIRectEdgeLeft) {
        [destinationView updateSuperLeadingConstraint: 0];
    } else if (presentationEdge == UIRectEdgeRight) {
        [destinationView updateSuperTrailingConstraint: 0];
    }
}

@end