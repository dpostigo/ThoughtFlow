//
// Created by Dani Postigo on 6/14/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "UINavigationController+TFDrawerNavAnimator.h"
#import "TFLeftDrawerNavAnimator.h"

@implementation UINavigationController (TFDrawerNavAnimator)

- (void) pushViewController: (UIViewController *) viewController withAnimator: (TFLeftDrawerNavAnimator *) animator {

    self.delegate = animator;
    [self pushViewController: viewController animated: YES];
}

- (void) popViewControllerWithAnimator: (TFLeftDrawerNavAnimator *) animator completion: (void (^)()) completion {
    animator.dismissCompletionBlock = completion;
    self.delegate = animator;
    [self popViewControllerAnimated: YES];
}
@end