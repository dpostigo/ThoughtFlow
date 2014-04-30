//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "FirstViewController.h"
#import "TLFreeformModalAnimator.h"
#import "DPSegueManager.h"

@implementation FirstViewController

- (void) viewDidLoad {
    [super viewDidLoad];

}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    [self performSegueWithIdentifier: @"LoginModalSegue" sender: nil];
}


- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
    [super prepareForSegue: segue sender: sender];

    UIViewController *detailViewController = segue.destinationViewController;
    detailViewController.transitioningDelegate = self;
    detailViewController.modalPresentationStyle = UIModalPresentationCustom;
}


#pragma mark - UIViewControllerTransitioningDelegate Methods

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController: (UIViewController *) presented
                                                                    presentingController: (UIViewController *) presenting
                                                                        sourceController: (UIViewController *) source {
    TLFreeformModalAnimator *animator = [TLFreeformModalAnimator new];
    animator.presenting = YES;
    return animator;
}

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController: (UIViewController *) dismissed {
    TLFreeformModalAnimator *animator = [TLFreeformModalAnimator new];
    animator.fromEdge = UIRectEdgeBottom;
    return animator;
}


@end