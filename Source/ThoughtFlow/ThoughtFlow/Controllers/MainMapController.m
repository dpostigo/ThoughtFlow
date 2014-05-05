//
// Created by Dani Postigo on 5/4/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPTransitions/CustomModalSegue.h>
#import "MainMapController.h"
#import "TFDrawerModalAnimator.h"
#import "UIView+DPKit.h"
#import "ToolbarController.h"

@implementation MainMapController

- (void) viewDidLoad {
    [super viewDidLoad];

    NSLog(@"contentController = %@", contentController);



}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    //    toolbarController = [self.storyboard instantiateViewControllerWithIdentifier: @"TestController"];
    //    toolbarController.transitioningDelegate = self;
    //    toolbarController.modalPresentationStyle = UIModalPresentationCustom;
    //    //        toolbarController.modalPresentationStyle = UIModalPresentationFormSheet;
    //    //    toolbarController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    //
    //    //    [self presentViewController: toolbarController animated: YES completion: nil];
    //
    //    [self presentViewController: toolbarController animated: YES
    //                     completion: ^() {
    //
    //
    //                         //                         toolbarController.view.frame = CGRectMake(0, 0, 768, 60);
    //                         //                         toolbarController.view.backgroundColor = [UIColor blueColor];
    //                     }];

    //    toolbarController.view.frame = CGRectMake(0, 0, 60, 768);



    //    [self performSegueWithIdentifier: @"ToolbarSegue" sender: nil];
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
    [super prepareForSegue: segue sender: sender];

    UIViewController *controller = segue.destinationViewController;
    NSLog(@"segue.identifier = %@", segue.identifier);
    if ([segue.identifier isEqualToString: @"ContentEmbedSegue"]) {

        contentController = controller;

    } else if ([segue.identifier isEqualToString: @"ToolbarEmbedSegue"]) {
        toolbarController = (ToolbarController *) controller;

    }

}



#pragma mark UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController: (UIViewController *) presented presentingController: (UIViewController *) presenting sourceController: (UIViewController *) source {
    TFDrawerModalAnimator *animator = [TFDrawerModalAnimator new];
    animator.debug = YES;
    animator.presenting = YES;
    animator.modalSize = CGSizeMake(60, 768);
    animator.sourceModalOrigin = CGPointMake(-60, 0);
    animator.destinationModalOrigin = CGPointMake(0, 0);
    animator.sourceController = source;
    return animator;
}

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController: (UIViewController *) dismissed {
    TFDrawerModalAnimator *animator = [TFDrawerModalAnimator new];
    animator.debug = YES;
    animator.modalSize = CGSizeMake(290, self.view.height);
    animator.sourceModalOrigin = CGPointMake(-450, 0);
    animator.destinationModalOrigin = CGPointMake(60, 0);
    return animator;
}

@end