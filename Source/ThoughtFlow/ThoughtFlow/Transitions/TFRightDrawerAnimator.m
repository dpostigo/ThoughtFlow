//
// Created by Dani Postigo on 5/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "TFRightDrawerAnimator.h"

@implementation TFRightDrawerAnimator

- (void) animateWithContext: (id <UIViewControllerContextTransitioning>) transitionContext {
    UIViewController *fromViewController = self.presenting ? [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey] : [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    self.modalSize = CGSizeMake(self.modalSize.width, fromViewController.view.height);
    self.sourcePoint = CGPointMake(fromViewController.view.window.height + self.modalSize.width, 0);
    self.destinationPoint = CGPointMake(fromViewController.view.window.height - self.modalSize.width, 0);

    [super animateWithContext: transitionContext];
}

@end