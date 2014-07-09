//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (TFAnimators)

- (UIViewController *) toViewController: (id <UIViewControllerContextTransitioning>) transitionContext presenting: (BOOL) presenting;
- (UIViewController *) fromViewController: (id <UIViewControllerContextTransitioning>) transitionContext presenting: (BOOL) presenting;
@end