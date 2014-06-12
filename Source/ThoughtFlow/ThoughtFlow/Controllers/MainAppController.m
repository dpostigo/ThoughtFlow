//
// Created by Dani Postigo on 5/4/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPTransitions/CustomModalSegue.h>
#import <DPAnimators/NavigationFadeAnimator.h>
#import <DPAnimators/ModalChildDrawerAnimator.h>
#import <DPKit-Utils/UIView+DPKit.h>
#import "ModalDrawerAnimator.h"
#import "CustomModalAnimator.h"
#import "MainAppController.h"
#import "Model.h"
#import "ProjectLibrary.h"
#import "UIViewController+TFControllers.h"
#import "UINavigationController+BasicNavigationAnimator.h"
#import "TFRightDrawerAnimator.h"
#import "TFLeftDrawerAnimator.h"
#import "UIView+DPKit.h"

@implementation MainAppController

- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    showsPrelogin = YES;

}

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

//    if (!_model.loggedIn && showsPrelogin) {
//        animator.modalPresentationSize = CGSizeMake(300, 380);
//
//        UIViewController *controller = self.preloginController;
//        controller.modalPresentationStyle = UIModalPresentationCustom;
//        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        controller.transitioningDelegate = animator;
//        [self presentViewController: controller animated: YES completion: nil];
//    }

}


- (void) viewDidLoad {
    [super viewDidLoad];

    animator = [CustomModalAnimator new];
    navigationAnimator = [NavigationFadeAnimator new];
    navigationAnimator.releasesAnimator = YES;

    rightDrawerAnimator = [TFRightDrawerAnimator new];
    leftDrawerAnimator = [TFLeftDrawerAnimator new];

    [self setupTestAnimator];
    [self testModalChildDrawer];

    navController = (UINavigationController *) ([contentController isKindOfClass: [UINavigationController class]] ? contentController : nil);
    if (navController) {
        [self setupNotifications];
    }
}


- (void) setupTestAnimator {

    testAnimator = [ModalDrawerAnimator new];

    testAnimator.presentationEdge = UIRectEdgeLeft;
    testAnimator.presentationOffset = CGPointMake(60, 0);
    testAnimator.modalPresentationSize = CGSizeMake(300, 0);


    //
    //    testAnimator.presentationEdge = UIRectEdgeRight;
    //    testAnimator.presentationOffset = CGPointMake(-60, 0);
    //    testAnimator.modalPresentationSize = CGSizeMake(300, 0);


    //    testAnimator.presentationEdge = UIRectEdgeTop;
    //    testAnimator.modalPresentationSize = CGSizeMake(0, 300);

    //    testAnimator.presentationEdge = UIRectEdgeBottom;
    //    testAnimator.modalPresentationSize = CGSizeMake(0, 300);

}


- (void) testModalChildDrawer {
    childDrawerAnimator = [ModalChildDrawerAnimator new];
}


#pragma mark Notifications

- (void) setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleNavNotification:) name: TFNavigationNotification object: nil];

}

- (void) handleNavNotification: (NSNotification *) notification {

    BOOL pushes = [[notification.userInfo objectForKey: TFViewControllerShouldPushKey] boolValue];
    NSNumber *number = [notification.userInfo objectForKey: TFViewControllerTypeKey];
    TFViewControllerType type = (TFViewControllerType) [number intValue];

    [_model.projectLibrary save];

    if (pushes) {
        NSString *name = [notification.userInfo objectForKey: TFViewControllerTypeName];
        [self goToViewControllerClass: NSClassFromString(name)];
    }
}


#pragma mark Custom NavigationController Transitions

- (void) goToViewControllerClass: (Class) class {
    if (navController.presentedViewController) [navController dismissViewControllerAnimated: YES completion: nil];

    NSArray *controllers = [NSArray arrayWithArray: navController.viewControllers];
    NSArray *classes = [controllers valueForKeyPath: @"@unionOfObjects.class"];

    if ([classes containsObject: class]) {
        NSUInteger index = [classes indexOfObject: class];
        [navController popToViewController: [controllers objectAtIndex: index] animated: YES];
    } else {

        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier: NSStringFromClass(
                class)];
        [navController pushViewController: controller animated: YES];

    }
}




#pragma mark Segue


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
    [super prepareForSegue: segue sender: sender];

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
        toolbarController = (TFToolbarController *) controller;
        toolbarController.delegate = self;

    }
}



#pragma mark Toolbar drawers

- (void) toggleRightDrawer: (BOOL) selected withController: (UIViewController *) controller {
    if (selected) {
        [self openRightDrawerWithController: controller];
    } else {
        [self closeDrawers];
    }
}

- (void) toggleLeftDrawer: (BOOL) selected withController: (UIViewController *) controller {
    if (selected) {
        [self openLeftDrawerWithController: controller];
    } else {
        [self closeDrawers];
    }
}


- (void) closeDrawers {
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated: YES completion: nil];
    }
}


- (void) openLeftDrawerWithController: (UIViewController *) controller {
    [self openDrawerWithController: controller animator: leftDrawerAnimator];
}

- (void) openRightDrawerWithController: (UIViewController *) controller {
    [self openDrawerWithController: controller animator: rightDrawerAnimator];
}


- (void) openDrawerWithController: (UIViewController *) controller animator: (TFDrawerModalAnimator *) anAnimator {
    //
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
    //    UIRectEdge edge = anAnimator.presentationEdge;
    //    UIView *view = controller.view;
    //    view.size = anAnimator.modalPresentationSize;
    //
    //    view.width = anAnimator.modalPresentationSize.width == 0 ? self.view.width : anAnimator.modalPresentationSize.width;
    //    view.height = anAnimator.modalPresentationSize.height == 0 ? self.view.height : anAnimator.modalPresentationSize.height;
    //
    //    [view positionAtEdge: edge hidden: YES];
    //
    //    [self.view addSubview: view];
    //    [self addChildViewController: controller];
    //
    //    NSLog(@"view.frame = %@", NSStringFromCGRect(view.frame));
    //
    //    [UIView animateWithDuration: 0.4 animations: ^{
    //        [view positionAtEdge: edge];
    //    }];
    //
    //



    UIViewController *presenter = self;
    controller.transitioningDelegate = anAnimator;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    void (^presentBlock)() = ^{
        [self presentViewController: controller animated: YES completion: nil];
    };

    NSLog(@"presenter.presentedViewController = %@", presenter.presentedViewController);

    if (presenter.presentedViewController) {
        [presenter dismissViewControllerAnimated: YES completion: ^{
            presentBlock();
        }];
    } else {
        presentBlock();
    }

    //    if (self.presentedViewController && self.presentedViewController.transitioningDelegate == anAnimator) {
    //        [self dismissViewControllerAnimated: NO completion: presentBlock];
    //    } else {
    //        presentBlock();
    //    }

}


#pragma mark Fullscreen modals


- (void) toggleFullscreenTransition: (BOOL) selected withController: (UIViewController *) controller {
    if (selected) {
        [navController pushViewController: controller withAnimator: navigationAnimator];
    } else if ([[navController.viewControllers lastObject] isKindOfClass: [controller class]]) {
        [navController popViewControllerAnimated: YES];
    }
}

#pragma mark TFToolbarDelegate

- (void) toolbarChangeSelection: (BOOL) selected forType: (TFToolbarButtonType) type {
    switch (type) {
        case TFToolbarButtonInfo :
            [self closeDrawers];
            [self toggleFullscreenTransition: selected withController: self.infoViewController];
            break;

        case TFToolbarButtonMoodboard :
            [self closeDrawers];
            [self toggleFullscreenTransition: selected withController: self.moodboardController];
            break;

        case TFToolbarButtonNotes  :
            [self toggleRightDrawer: selected withController: self.notesViewController];
            //            [self toggleLeftDrawer: selected withController: self.notesViewController];
            break;

        case TFToolbarButtonAccount :
            [self toggleLeftDrawer: selected withController: self.accountViewController];
            break;

        case TFToolbarButtonSettings :
            [self toggleLeftDrawer: selected withController: self.imageSettingsController];
            break;

        default :
            break;
    }

}


- (void) toolbarDidSelectButtonWithType: (NSNumber *) numberType {
    TFToolbarButtonType type = (TFToolbarButtonType) [numberType integerValue];

}

- (void) toolbarDidDeselectButtonWithType: (NSNumber *) numberType {
    TFToolbarButtonType type = (TFToolbarButtonType) [numberType integerValue];

}


@end