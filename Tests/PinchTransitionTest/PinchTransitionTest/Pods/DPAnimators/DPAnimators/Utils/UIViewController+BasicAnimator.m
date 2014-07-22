//
// Created by Dani Postigo on 5/10/14.
//

#import "BasicAnimator.h"
#import "UIViewController+BasicAnimator.h"
#import "BasicAnimator+UIViewController.h"

@implementation UIViewController (BasicAnimator)

- (void) presentController: (UIViewController *) controller withAnimator: (BasicAnimator *) animator {
    [animator setupController: controller];
    [self presentViewController: controller animated: YES completion: nil];
}
@end