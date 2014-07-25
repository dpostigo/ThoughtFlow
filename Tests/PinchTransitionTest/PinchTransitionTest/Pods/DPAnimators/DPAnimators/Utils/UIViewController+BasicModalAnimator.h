//
// Created by Dani Postigo on 5/25/14.
//

#import <Foundation/Foundation.h>

@class BasicModalAnimator;

@interface UIViewController (BasicModalAnimator)

- (void) presentController: (UIViewController *) controller withAnimator: (BasicModalAnimator *) animator;
@end