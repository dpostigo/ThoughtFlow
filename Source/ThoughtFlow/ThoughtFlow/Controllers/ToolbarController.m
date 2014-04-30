//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "ToolbarController.h"
#import "TLFreeformModalAnimator.h"
#import "ToolbarDrawerController.h"
#import "UIView+DPKit.h"
#import "UIView+DPConstraints.h"
#import "UIView+DPKitChildren.h"
#import "Model.h"

@implementation ToolbarController

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


- (void) observeValueForKeyPath: (NSString *) keyPath ofObject: (id) object change: (NSDictionary *) change context: (void *) context {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (object == _model) {
        if ([keyPath isEqualToString: @"selectedProject"]) {

        }
    } else {

        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
    }
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

- (void) toggleDrawer: (id) sender {

    UIButton *button = sender;

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
//            NSLog(@"drawerView = %@", NSStringFromCGRect(drawerView));

            //            [drawerView updateSuperTrailingConstraint: 0];
            //            [drawerView updateSuperHeightConstraint: 0];

            //            drawerView.backgroundColor = [UIColor blueColor];
            //
            //            [UIView animateWithDuration: 0.3 delay: 0.0
            //                                options: UIViewAnimationOptionCurveEaseOut
            //                             animations: ^{
            //                                 drawerView.left = self.view.width;
            //                             }
            //                             completion: ^(BOOL finished) {
            //                                 NSLog(@"drawerView.width = %f", drawerView.width);
            //                                 //                                 NSLog(@"drawerView.right = %f", drawerView.right);
            //                                 self.view.width = 60 + drawerView.width;
            //                             }];
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


#pragma mark Getters

- (ToolbarDrawerController *) drawerController {
    if (drawerController == nil) {
        drawerController = [self.storyboard instantiateViewControllerWithIdentifier: @"ToolbarDrawerController"];
    }
    return drawerController;
}


@end