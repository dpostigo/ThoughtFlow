//
// Created by Dani Postigo on 5/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "TFDrawerAnimator.h"
#import "NSObject+InterfaceUtils.h"

@implementation TFDrawerAnimator

@synthesize modalSize;
@synthesize sourcePoint;
@synthesize destinationPoint;

- (void) animateWithContext: (id <UIViewControllerContextTransitioning>) transitionContext {
    //    [super animateWithContext: transitionContext];

    UIViewController *fromViewController = self.presenting ? [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey] : [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    UIViewController *toViewController = self.presenting ? [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey] : [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];


    UIView *containerView = transitionContext.containerView;

    UIView *clippingView = [[UIView alloc] initWithFrame: containerView.bounds];
    clippingView.clipsToBounds = YES;
    clippingView.height -= 60;
    if (self.isLandscapeRight) clippingView.top -= 60;

    __block CGRect sourceFrame = CGRectZero;
    __block CGRect destinationFrame = CGRectZero;

    sourceFrame = CGRectMake(
            self.isLandscape ? sourcePoint.y : sourcePoint.x,
            self.isLandscape ? sourcePoint.x : sourcePoint.y,
            self.isLandscape ? self.modalSize.height : self.modalSize.width,
            self.isLandscape ? self.modalSize.width : self.modalSize.height);

    destinationFrame = CGRectMake(
            self.isLandscape ? destinationPoint.y : destinationPoint.x,
            self.isLandscape ? destinationPoint.x : destinationPoint.y,
            self.isLandscape ? self.modalSize.height : self.modalSize.width,
            self.isLandscape ? self.modalSize.width : self.modalSize.height);

    destinationFrame.origin.x = 0;
    CGFloat containerViewWidth = self.isLandscape ? containerView.height : containerView.width;

    if (self.isLandscapeLeft) {
        sourceFrame.origin.y = containerViewWidth - CGRectGetWidth(sourceFrame) - sourcePoint.x;
        destinationFrame.origin.y = containerView.height - modalSize.width - destinationPoint.x;
    }

    UIView *destinationView = toViewController.view;

    if (self.presenting) {
        destinationView.frame = sourceFrame;

        [containerView addSubview: fromViewController.view];
        [containerView addSubview: clippingView];
        [clippingView addSubview: toViewController.view];

        [UIView animateWithDuration: [self transitionDuration: transitionContext]
                         animations: ^{
                             destinationView.frame = destinationFrame;
                         }
                         completion: ^(BOOL finished) {
                             [transitionContext completeTransition: YES];
                         }];

    } else {

        [transitionContext.containerView addSubview: fromViewController.view];
        [transitionContext.containerView addSubview: clippingView];
        [clippingView addSubview: toViewController.view];

        [UIView animateWithDuration: [self transitionDuration: transitionContext] delay: 0.0f
                            options: UIViewAnimationOptionCurveEaseOut
                         animations: ^{
                             destinationView.alpha = 0;
                             destinationView.frame = sourceFrame;

                         }
                         completion: ^(BOOL finished) {
                             [transitionContext completeTransition: YES];
                         }];
    }
}
//
//
//- (void) presentWithContext: (id <UIViewControllerContextTransitioning>) transitionContext {
//
//    UIViewController *fromViewController = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
//    UIViewController *toViewController = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
//
//    UIView *containerView = transitionContext.containerView;
//
//    UIView *clippingView = [[UIView alloc] initWithFrame: containerView.bounds];
//    clippingView.clipsToBounds = YES;
//    clippingView.height -= 60;
//}
//
//- (CGRect) sourceFrame: (id <UIViewControllerContextTransitioning>) transitionContext {
//
//    UIView *containerView = transitionContext.containerView;
//
//    CGRect sourceFrame = CGRectMake(
//            self.isLandscape ? sourcePoint.y : sourcePoint.x,
//            self.isLandscape ? sourcePoint.x : sourcePoint.y,
//            self.isLandscape ? self.modalSize.height : self.modalSize.width,
//            self.isLandscape ? self.modalSize.width : self.modalSize.height);
//
//
//    CGFloat containerViewWidth = self.isLandscape ? containerView.height : containerView.width;
//
//    if (self.isLandscapeLeft) {
//        sourceFrame.origin.y = containerViewWidth - CGRectGetWidth(sourceFrame) - sourcePoint.x;
//    }
//    return sourceFrame;
//}
//
//- (void) dismissWithContext: (id <UIViewControllerContextTransitioning>) transitionContext {
//
//    UIViewController *fromViewController = self.presenting ? [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey] : [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
//    UIViewController *toViewController = self.presenting ? [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey] : [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
//
//
//    UIView *containerView = transitionContext.containerView;
//
//    UIView *clippingView = [[UIView alloc] initWithFrame: containerView.bounds];
//    clippingView.clipsToBounds = YES;
//    clippingView.height -= 60;
//    if (self.isLandscapeRight) clippingView.top -= 60;
//
//    __block CGRect sourceFrame = CGRectZero;
//    __block CGRect destinationFrame = CGRectZero;
//
//    sourceFrame = CGRectMake(
//            self.isLandscape ? sourcePoint.y : sourcePoint.x,
//            self.isLandscape ? sourcePoint.x : sourcePoint.y,
//            self.isLandscape ? self.modalSize.height : self.modalSize.width,
//            self.isLandscape ? self.modalSize.width : self.modalSize.height);
//
//    destinationFrame = CGRectMake(
//            self.isLandscape ? destinationPoint.y : destinationPoint.x,
//            self.isLandscape ? destinationPoint.x : destinationPoint.y,
//            self.isLandscape ? self.modalSize.height : self.modalSize.width,
//            self.isLandscape ? self.modalSize.width : self.modalSize.height);
//
//    destinationFrame.origin.x = 0;
//    CGFloat containerViewWidth = self.isLandscape ? containerView.height : containerView.width;
//
//    if (self.isLandscapeLeft) {
//        sourceFrame.origin.y = containerViewWidth - CGRectGetWidth(sourceFrame) - sourcePoint.x;
//        destinationFrame.origin.y = containerView.height - modalSize.width - destinationPoint.x;
//    }
//
//    UIView *destinationView = toViewController.view;
//
//    if (self.presenting) {
//        destinationView.frame = sourceFrame;
//
//        [containerView addSubview: fromViewController.view];
//        [containerView addSubview: clippingView];
//        [clippingView addSubview: toViewController.view];
//
//        [UIView animateWithDuration: [self transitionDuration: transitionContext]
//                         animations: ^{
//                             destinationView.frame = destinationFrame;
//                         }
//                         completion: ^(BOOL finished) {
//                             [transitionContext completeTransition: YES];
//                         }];
//
//    } else {
//
//        [transitionContext.containerView addSubview: fromViewController.view];
//        [transitionContext.containerView addSubview: clippingView];
//        [clippingView addSubview: toViewController.view];
//
//        [UIView animateWithDuration: [self transitionDuration: transitionContext] delay: 0.0f
//                            options: UIViewAnimationOptionCurveEaseOut
//                         animations: ^{
//                             destinationView.alpha = 0;
//                             destinationView.frame = sourceFrame;
//
//                         }
//                         completion: ^(BOOL finished) {
//                             [transitionContext completeTransition: YES];
//                         }];
//    }
//}


#pragma mark Getters

- (CGSize) modalSize {
    if (modalSize.width == 0) modalSize.width = 400;
    if (modalSize.height == 0) modalSize.height = 400;
    return modalSize;
}

@end