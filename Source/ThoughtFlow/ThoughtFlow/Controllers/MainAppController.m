//
// Created by Dani Postigo on 5/4/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPTransitions/CustomModalSegue.h>
#import "CustomModalAnimator.h"
#import "MainAppController.h"
#import "ToolbarController.h"

@implementation MainAppController

- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    showsPrelogin = YES;

    if (showsPrelogin) {
        //        self.view.hidden = YES;
    }
}

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    if (showsPrelogin) {
        animator = [CustomModalAnimator new];
        animator.modalPresentationSize = CGSizeMake(300, 380);
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier: @"PreloginController"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        controller.transitioningDelegate = animator;
        [self presentViewController: controller animated: YES completion: ^{

        }];
    }

}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
    [super prepareForSegue: segue sender: sender];

    NSLog(@"%s, segue = %@", __PRETTY_FUNCTION__, segue);

    UIViewController *controller = segue.destinationViewController;

    if ([segue isKindOfClass: [CustomModalSegue class]]) {

        CustomModalSegue *customSegue = (CustomModalSegue *) segue;
        customSegue.modalSize = CGSizeMake(340, 340);

        UIViewController *destinationController = segue.destinationViewController;
        destinationController.modalPresentationStyle = UIModalPresentationFormSheet;
        destinationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    } else if ([segue.identifier isEqualToString: @"ContentEmbedSegue"]) {
        contentController = controller;

    } else if ([segue.identifier isEqualToString: @"ToolbarEmbedSegue"]) {
        toolbarController = (ToolbarController *) controller;

    }
}


//
//#pragma mark UIViewControllerTransitioningDelegate
//
//- (id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController: (UIViewController *) presented presentingController: (UIViewController *) presenting sourceController: (UIViewController *) source {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    TFDrawerModalAnimator *animator = [TFDrawerModalAnimator new];
//    animator.debug = YES;
//    animator.presenting = YES;
//    animator.modalSize = CGSizeMake(60, 768);
//    animator.sourceModalOrigin = CGPointMake(-60, 0);
//    animator.destinationModalOrigin = CGPointMake(0, 0);
//    animator.sourceController = source;
//    return animator;
//}
//
//- (id <UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController: (UIViewController *) dismissed {
//    TFDrawerModalAnimator *animator = [TFDrawerModalAnimator new];
//    animator.debug = YES;
//    animator.modalSize = CGSizeMake(290, self.view.height);
//    animator.sourceModalOrigin = CGPointMake(-450, 0);
//    animator.destinationModalOrigin = CGPointMake(60, 0);
//    return animator;
//}

@end