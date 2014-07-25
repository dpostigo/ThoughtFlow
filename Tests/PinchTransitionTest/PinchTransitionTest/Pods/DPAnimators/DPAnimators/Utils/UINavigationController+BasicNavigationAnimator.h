//
// Created by Dani Postigo on 5/25/14.
//

#import <Foundation/Foundation.h>

@interface UINavigationController (BasicNavigationAnimator)

- (void) pushViewController: (UIViewController *) viewController withAnimator: (BasicNavigationAnimator *) animator;
@end