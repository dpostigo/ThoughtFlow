//
// Created by Dani Postigo on 5/10/14.
//

#import "BasicAnimator+UIViewController.h"

@implementation BasicAnimator (UIViewController)

- (void) setupController: (UIViewController *) controller {
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.transitioningDelegate = self;

}
@end