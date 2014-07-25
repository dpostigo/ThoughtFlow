//
// Created by Dani Postigo on 5/25/14.
//

#import <DPAnimators/BasicModalAnimator.h>
#import "UIViewController+BasicModalAnimator.h"

@implementation UIViewController (BasicModalAnimator)

- (void) presentController: (UIViewController *) controller withAnimator: (BasicModalAnimator *) animator {
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.transitioningDelegate = animator;
    [self presentViewController: controller animated: YES completion: nil];
}
@end