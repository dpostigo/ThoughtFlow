//
// Created by Dani Postigo on 5/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPTransitions/TestAnimator.h>
#import "MainController.h"
#import "UIView+DPKit.h"
#import "CustomModalSegue.h"
#import "TestAnimator.h"

@implementation MainController

- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    //    [self performSegueWithIdentifier: @"PreloginSegue" sender: nil];

    animator = [TestAnimator new];
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier: @"LoginModal"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.transitioningDelegate = animator;
    [self presentViewController: controller animated: YES completion: ^{

    }];

}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
    [super prepareForSegue: segue sender: sender];

    if ([segue isKindOfClass: [CustomModalSegue class]]) {
        CustomModalSegue *customSegue = (CustomModalSegue *) segue;
        customSegue.modalSize = CGSizeMake(200, 200);

        UIViewController *destinationController = segue.destinationViewController;
        destinationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        destinationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        NSLog(@"%s", __PRETTY_FUNCTION__);

    }
}


@end