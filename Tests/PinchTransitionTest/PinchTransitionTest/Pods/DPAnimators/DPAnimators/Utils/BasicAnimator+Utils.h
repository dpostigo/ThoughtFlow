//
// Created by Dani Postigo on 5/22/14.
//

#import <Foundation/Foundation.h>
#import "BasicAnimator.h"

@interface BasicAnimator (Utils)
- (CGRect) rectForDismissedState: (id) transitionContext size: (CGSize) size;
- (CGRect) rectForPresentedState: (id) transitionContext size: (CGSize) size;
@end