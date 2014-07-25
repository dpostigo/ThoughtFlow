//
// Created by Dani Postigo on 5/25/14.
//

#import <DPAnimators/BasicNavigationAnimator.h>
#import "UINavigationController+BasicNavigationAnimator.h"

@implementation UINavigationController (BasicNavigationAnimator)

- (void) pushViewController: (UIViewController *) viewController withAnimator: (BasicNavigationAnimator *) animator {
    self.delegate = animator;
    [self pushViewController: viewController animated: YES];
}
@end