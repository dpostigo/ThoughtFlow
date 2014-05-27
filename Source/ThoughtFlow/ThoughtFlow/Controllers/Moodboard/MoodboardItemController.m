//
// Created by Dani Postigo on 5/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "MoodboardItemController.h"
#import "TFRightDrawerAnimator.h"

@implementation MoodboardItemController

- (void) viewDidLoad {
    [super viewDidLoad];

    drawerAnimator = [TFRightDrawerAnimator new];
    //    drawerAnimator.modalSize = CGSizeMake(300, self.view.height);
}


- (IBAction) handleInfoButton: (UIButton *) button {

    UIViewController *controller = self.drawerController;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.transitioningDelegate = drawerAnimator;
    [self presentViewController: controller animated: YES completion: nil];
    //    [drawerAnimator setupController: controller];

}

- (UIViewController *) drawerController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"ImageDrawerController"];
}

@end