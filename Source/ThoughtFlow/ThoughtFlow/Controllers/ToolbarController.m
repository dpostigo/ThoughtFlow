//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPTransitions/CustomModalSegue.h>
#import "ToolbarController.h"
#import "UIView+DPConstraints.h"
#import "NSLayoutConstraint+DPUtils.h"
#import "UIView+DPKit.h"
#import "UIView+TFFonts.h"
#import "UIView+DPKitChildren.h"
#import "TLFreeformModalAnimator.h"
#import "TFDrawerModalAnimator.h"

NSString *const TFToolbarProjectsNotification = @"TFToolbarProjectsNotification";


@implementation ToolbarController

- (void) loadView {
    [super loadView];

    buttonsView.layer.borderWidth = 1.0;
    buttonsView.layer.borderColor = [UIColor lightGrayColor].CGColor;

}


- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view updateWidthConstraint: buttonsView.width];
    [self.view setNeedsUpdateConstraints];

    self.buttons = [buttonsView childrenOfClass: [UIButton class]];
    [self setupButtons];

    [self.view convertFonts];
}


#pragma mark Setup

- (void) setupButtons {
    for (UIButton *button in self.buttons) {
        NSArray *actions = [button actionsForTarget: self forControlEvent: UIControlEventTouchUpInside];
        if ([actions count] == 0) {
            [button addTarget: self action: @selector(handleButton:)
             forControlEvents: UIControlEventTouchUpInside];
        }
        [button setAttributedTitle: nil forState: UIControlStateNormal];
        [button setTitleColor: [UIColor darkGrayColor] forState: UIControlStateNormal];
        [button setTitleColor: [UIColor whiteColor] forState: UIControlStateSelected];
    }
}


#pragma mark IBActions


- (IBAction) handleProjectsButton: (UIButton *) button {
    [[NSNotificationCenter defaultCenter] postNotificationName: TFToolbarProjectsNotification object: nil];
}


- (IBAction) handleNotesButton: (UIButton *) button {

}

- (IBAction) handleButton: (id) sender {
    [self deselectAll: sender];

    UIButton *button = sender;
    button.selected = !button.selected;

    [self toggleDrawer: button];

}

- (void) deselectAll: (id) sender {
    for (UIButton *button in self.buttons) {
        if (button != sender) {
            button.selected = NO;
        }
    }
}

- (IBAction) toggleDrawer: (id) sender {
    //    UIButton *button = sender;
    //    if (button.selected) {
    //        [self openDrawer: nil];
    //
    //    } else {
    //        [self closeDrawer: nil];
    //    }
    UIButton *button = sender;
    if (button.selected) {

        UIViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"ToolbarDrawerController"];
        detailViewController.transitioningDelegate = self;
        detailViewController.modalPresentationStyle = UIModalPresentationCustom;
        toolbarDrawer = detailViewController;

        [self presentViewController: toolbarDrawer animated: YES
                         completion: nil];

    } else {

        if (toolbarDrawer) {
            if (!toolbarDrawer.isBeingDismissed) {
                [self dismissViewControllerAnimated: YES completion: nil];
            }
        }
    }
}


#pragma mark Drawer presentation

//- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
//    [super prepareForSegue: segue sender: sender];
//
//    if ([segue isKindOfClass: [CustomModalSegue class]]) {
//        NSLog(@"%s", __PRETTY_FUNCTION__);
//
//        CustomModalSegue *customSegue = (CustomModalSegue *) segue;
//        //        customSegue.modalOrigin = CGPointMake(60, 0);
//
//
//
//        UIViewController *detailViewController = segue.destinationViewController;
//        detailViewController.transitioningDelegate = self;
//        detailViewController.modalPresentationStyle = UIModalPresentationCustom;
//        toolbarDrawer = detailViewController;
//
//    }
//}

#pragma mark UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController: (UIViewController *) presented presentingController: (UIViewController *) presenting sourceController: (UIViewController *) source {
    TFDrawerModalAnimator *animator = [TFDrawerModalAnimator new];
    animator.debug = YES;
    animator.presenting = YES;
    animator.modalSize = CGSizeMake(290, self.view.height);
    animator.sourceModalOrigin = CGPointMake(-450, 0);
    animator.destinationModalOrigin = CGPointMake(60, 0);
    animator.sourceController = source;

    //    NSLog(@"self.view.width = %f", self.view.width);
    //    NSLog(@"self.view.height = %f", self.view.height);
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



#pragma mark Open close
- (void) openDrawer: (id) sender {
    CGFloat widthValue = buttonsView.width + drawerView.width;
    NSLayoutConstraint *widthConstraint = [self.view staticWidthConstraint];

    if (widthConstraint.constant != widthValue) {
        widthConstraint.constant = widthValue;
        [self.view setNeedsUpdateConstraints];

        [UIView animateWithDuration: 0.25f
                         animations: ^{
                             [self.view layoutIfNeeded];

                         }
                         completion: ^(BOOL finished) {

                         }];

    }
}


- (void) closeDrawer: (id) sender {
    CGFloat widthValue = buttonsView.width;
    NSLayoutConstraint *widthConstraint = [self.view staticWidthConstraint];

    if (widthConstraint.constant != widthValue) {
        widthConstraint.constant = widthValue;
        [self.view setNeedsUpdateConstraints];

        [UIView animateWithDuration: 0.25f
                         animations: ^{
                             [self.view layoutIfNeeded];

                         }
                         completion: ^(BOOL finished) {

                         }];

    }

}


@end