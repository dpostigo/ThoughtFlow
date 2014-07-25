//
// Created by Dani Postigo on 5/22/14.
//

#import <Foundation/Foundation.h>
#import "BasicAnimator.h"

@interface BasicAnimator (Utils)

- (NSString *) toOrientationAsString: (id <UIViewControllerContextTransitioning>) context;
- (NSString *) fromOrientationAsString: (id <UIViewControllerContextTransitioning>) context;
- (UIInterfaceOrientation) toOrientation: (id <UIViewControllerContextTransitioning>) context;
- (UIInterfaceOrientation) fromOrientation: (id <UIViewControllerContextTransitioning>) context;
- (CGRect) rectForDismissedState: (id) transitionContext size: (CGSize) size;
- (CGRect) rectForPresentedState: (id) transitionContext size: (CGSize) size;
@end