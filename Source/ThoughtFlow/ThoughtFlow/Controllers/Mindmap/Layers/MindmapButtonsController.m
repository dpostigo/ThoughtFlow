//
// Created by Dani Postigo on 6/15/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import <DPKit-UIView/UIView+DPConstraints.h>
#import "MindmapButtonsController.h"
#import "UIViewController+TFControllers.h"
#import "TFDrawerController.h"

@implementation MindmapButtonsController

@synthesize drawerPresenter;

- (void) viewDidLoad {
    [super viewDidLoad];

}


#pragma mark IBActions

- (IBAction) handleGridButton: (UIButton *) sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.navigationController pushViewController: self.mindmapGridController animated: YES];
    //    [[NSNotificationCenter defaultCenter] postNotificationName: TFNavigationNotification
    //                                                        object: nil
    //                                                      userInfo: @{
    //                                                              TFViewControllerTypeName : @"MoodboardController",
    //                                                              TFViewControllerTypeKey : [NSNumber numberWithInteger: TFControllerMoodboard]
    //                                                      }];

    //    [self postNavigationNotificationForType: TFControllerMoodboard];

}

- (IBAction) handleInfoButton: (UIButton *) sender {
    if (self.drawerPresenter) {
        TFDrawerController *controller = (TFDrawerController *) self.imageDrawerController;
        controller.presenter = self.drawerPresenter;
        [self.drawerPresenter presentDrawerController: controller];
    }

}

- (IBAction) handlePinButton: (UIButton *) sender {

}


- (void) presentImageDrawer: (UIViewController *) controller {

    if (isPresenting) return;

    isPresenting = YES;
    UIViewController *presenterController = self.presenterController;
    UIView *presenterView = presenterController.view;
    [presenterController addChildViewController: controller];

    UIView *view = controller.view;
    [presenterView addSubview: view];

    view.width = 450;
    view.height = self.view.height;
    view.left = self.view.width;

    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view updateWidthConstraint: 450];
    [view updateSuperTrailingConstraint: -view.width];
    [presenterView addConstraint: [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: presenterController.topLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0]];
    [presenterView addConstraint: [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: presenterController.bottomLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0]];

    [presenterView layoutIfNeeded];
    [view updateSuperTrailingConstraint: 0];

    [UIView animateWithDuration: 0.4
            delay: 0.0f
            usingSpringWithDamping: 0.8
            initialSpringVelocity: 2.0f
            options: UIViewAnimationOptionCurveLinear
            animations: ^{
                [presenterView layoutIfNeeded];
            }
            completion: ^(BOOL finished) {
            }];

}



#pragma mark TFDrawerPresenter

- (void) dismissDrawerController: (TFDrawerController *) controller {
    UIViewController *presenterController = self.presenterController;
    UIView *presenterView = presenterController.view;

    UIView *view = controller.view;
    [view updateSuperTrailingConstraint: -view.width];

    [UIView animateWithDuration: 0.4
            delay: 0.0f
            usingSpringWithDamping: 0.8
            initialSpringVelocity: 2.0f
            options: UIViewAnimationOptionCurveLinear
            animations: ^{
                [presenterView layoutIfNeeded];

            }
            completion: ^(BOOL finished) {
                [controller removeFromParentViewController];
                isPresenting = NO;
                NSLog(@"Dismissed.");

            }];

}


- (UIViewController *) presenterController {
    UIViewController *ret = self;
    if (self.parentViewController) {
        ret = self.parentViewController;
    }
    return ret;
}


@end