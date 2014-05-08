//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "ToolbarControllerOld.h"
#import "TLFreeformModalAnimator.h"
#import "TFAccountDrawerController.h"
#import "UIView+DPKit.h"
#import "UIView+DPConstraints.h"
#import "UIView+DPKitChildren.h"
#import "Model.h"

@implementation ToolbarControllerOld

@synthesize drawerController;

- (void) loadView {
    [super loadView];

    self.view.layer.borderWidth = 1.0;
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;

    self.buttons = [self.view childrenOfClass: [UIButton class]];
    for (UIButton *button in self.buttons) {
        [button setAttributedTitle: nil forState: UIControlStateNormal];
        [button setTitleColor: [UIColor darkGrayColor] forState: UIControlStateNormal];
        [button setTitleColor: [UIColor whiteColor] forState: UIControlStateSelected];
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];

    [_model addObserver: self forKeyPath: @"selectedProject"
                options: NSKeyValueObservingOptionNew context: NULL];
}


#pragma mark Drawer presentation

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
    [super prepareForSegue: segue sender: sender];

    UIViewController *detailViewController = segue.destinationViewController;
    detailViewController.transitioningDelegate = self;
    detailViewController.modalPresentationStyle = UIModalPresentationCustom;
}

#pragma mark UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController: (UIViewController *) presented presentingController: (UIViewController *) presenting sourceController: (UIViewController *) source {
    TLFreeformModalAnimator *animator = [TLFreeformModalAnimator new];
    animator.presenting = YES;
    animator.fromEdge = UIRectEdgeLeft;
    animator.toEdge = UIRectEdgeRight;
    animator.sourceController = source;
    animator.debug = YES;
    return animator;
}

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController: (UIViewController *) dismissed {
    TLFreeformModalAnimator *animator = [TLFreeformModalAnimator new];
    return animator;
}


//#pragma mark - UIViewControllerTransitioningDelegate Methods
//
//- (id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController: (UIViewController *) presented
//                                                                    presentingController: (UIViewController *) presenting
//                                                                        sourceController: (UIViewController *) source {
//    TLFreeformModalAnimator *animator = [TLFreeformModalAnimator new];
//    animator.presenting = YES;
//    return animator;
//}
//
//- (id <UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController: (UIViewController *) dismissed {
//    TLFreeformModalAnimator *animator = [TLFreeformModalAnimator new];
//    animator.fromEdge = UIRectEdgeBottom;
//    return animator;
//}



#pragma mark Actions

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

- (void) toggleDrawer: (UIButton *) button {

    NSLog(@"%s", __PRETTY_FUNCTION__);
    UIView *drawerView = self.drawerController.view;
    drawerView.translatesAutoresizingMaskIntoConstraints = NO;

    if (button.selected) {
        [self performSegueWithIdentifier: @"DrawerSegue" sender: nil];

    } else {

        [self dismissViewControllerAnimated: YES completion: nil];
    }
}

- (void) testToggleDrawer1: (UIButton *) button {
    UIView *drawerView = self.drawerController.view;
    drawerView.translatesAutoresizingMaskIntoConstraints = NO;

    if (button.selected) {
        if (drawerView.superview == nil) {
            drawerView.width = 290;
            [drawerView updateWidthConstraint: 290];
            [self.view addSubview: drawerView];
            [self.view sendSubviewToBack: drawerView];

            self.view.width = 60 + drawerView.width;

            drawerView.left = 0;

        }

    } else {
        [UIView animateWithDuration: 0.3 delay: 0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations: ^{
                             drawerView.left = -drawerView.width;
                         }
                         completion: ^(BOOL finished) {
                             [drawerView removeFromSuperview];
                             self.view.width = 60;
                         }];
    }
}





#pragma mark Key value



- (void) observeValueForKeyPath: (NSString *) keyPath ofObject: (id) object change: (NSDictionary *) change context: (void *) context {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (object == _model) {
        if ([keyPath isEqualToString: @"selectedProjectDictionary"]) {

        }
    } else {

        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
    }
}

#pragma mark Getters

- (TFAccountDrawerController *) drawerController {
    if (drawerController == nil) {
        drawerController = [self.storyboard instantiateViewControllerWithIdentifier: @"TFAccountDrawerController"];
    }
    return drawerController;
}


@end