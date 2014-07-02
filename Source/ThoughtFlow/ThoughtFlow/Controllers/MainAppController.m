//
// Created by Dani Postigo on 5/4/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPTransitions/CustomModalSegue.h>
#import <DPAnimators/NavigationFadeAnimator.h>
#import <DPAnimators/ModalChildDrawerAnimator.h>
#import "ModalDrawerAnimator.h"
#import "CustomModalAnimator.h"
#import "MainAppController.h"
#import "Model.h"
#import "ProjectLibrary.h"
#import "UIViewController+TFControllers.h"
#import "UINavigationController+BasicNavigationAnimator.h"
#import "TFRightDrawerAnimator.h"
#import "TFLeftDrawerAnimator.h"
#import "TFLeftDrawerNavAnimator.h"
#import "UINavigationController+TFDrawerNavAnimator.h"
#import "UIViewController+BasicModalAnimator.h"
#import "TFDrawerModalAnimator.h"
#import "TFNewToolbarController.h"
#import "TFDrawerController.h"
#import "NotesDrawerController.h"
#import "ImageDrawerController.h"

@implementation MainAppController

- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    showsPrelogin = YES;

}

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    //    if (!_model.loggedIn && showsPrelogin) {
    //        animator.viewSize = CGSizeMake(300, 380);
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
    navController.delegate = self;
    if (navController) {
        [self setupNotifications];
    }

    if ([_model.projects count] > 0) {
        [navController setViewControllers: @[self.projectsController] animated: YES];
    }

}


- (void) setupTestAnimator {

    navAnimator = [TFDrawerNavAnimator new];
    navAnimator.presentationEdge = UIRectEdgeLeft;
    navAnimator.presentationOffset = CGPointMake(60, 0);
    navAnimator.viewSize = CGSizeMake(300, 0);

    rightNavAnimator = [TFDrawerNavAnimator new];
    rightNavAnimator.presentationEdge = UIRectEdgeRight;
    rightNavAnimator.presentationOffset = CGPointMake(60, 0);
    rightNavAnimator.viewSize = CGSizeMake(450, 0);

    testAnimator = [TFDrawerModalAnimator new];
    testAnimator.presentationEdge = UIRectEdgeLeft;
    testAnimator.presentationOffset = CGPointMake(60, 0);
    testAnimator.viewSize = CGSizeMake(300, 0);


    //
    //    testAnimator.presentationEdge = UIRectEdgeRight;
    //    testAnimator.presentationOffset = CGPointMake(-60, 0);
    //    testAnimator.viewSize = CGSizeMake(300, 0);


    //    testAnimator.presentationEdge = UIRectEdgeTop;
    //    testAnimator.viewSize = CGSizeMake(0, 300);

    //    testAnimator.presentationEdge = UIRectEdgeBottom;
    //    testAnimator.viewSize = CGSizeMake(0, 300);

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
        //        toolbarController = (TFToolbarController *) controller;
        //        toolbarController.delegate = self;
        newToolbarController = (TFNewToolbarController *) controller;

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

    NSLog(@"navController.delegate = %@", navController.delegate);
    if (selected) {
        [self openLeftDrawerWithController: controller];
    } else {
        [self closeDrawers];
    }
}


- (void) closeDrawers {

    if ([navController.visibleViewController isKindOfClass: [TFDrawerController class]]) {
        [navController popViewControllerAnimated: YES];
    }
    //
    //    if (navController.delegate == navAnimator) {
    //        //        [navController popViewControllerAnimated: YES];
    //        [navController popViewControllerWithAnimator: navAnimator completion: ^{
    //
    //            //            navController.delegate = slidingNavigationAnimator;
    //        }];
    //    }
    //    if (self.presentedViewController) {
    //        [self dismissViewControllerAnimated: YES completion: nil];
    //    }
}


- (void) openLeftDrawerWithController: (UIViewController *) controller {
    [self openDrawerWithController: controller animator: navAnimator];
}

- (void) openRightDrawerWithController: (UIViewController *) controller {
    [self openDrawerWithController: controller animator: rightNavAnimator];
}


- (void) openDrawerWithController: (UIViewController *) controller animator: (BasicNavigationAnimator *) anAnimator {
    //    [navController pushViewController: controller withAnimator: anAnimator];

    [navController pushViewController: controller animated: YES];
    //    NSLog(@"navController.view.frame = %@", NSStringFromCGRect(navController.view.frame));
    //    [navController presentController: controller withAnimator: testAnimator];

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



#pragma mark UINavigationController delegate

- (id <UIViewControllerAnimatedTransitioning>) navigationController: (UINavigationController *) navigationController
                                    animationControllerForOperation: (UINavigationControllerOperation) operation
                                                 fromViewController: (UIViewController *) fromVC
                                                   toViewController: (UIViewController *) toVC {

    BasicAnimator *ret = nil;

    if ([fromVC isKindOfClass: [NotesDrawerController class]] ||
            [toVC isKindOfClass: [NotesDrawerController class]] ||
            [fromVC isKindOfClass: [ImageDrawerController class]] ||
            [toVC isKindOfClass: [ImageDrawerController class]]) {
        ret = rightNavAnimator;
    } else if ([fromVC isKindOfClass: [TFDrawerController class]] || [toVC isKindOfClass: [TFDrawerController class]]) {
        ret = navAnimator;
    } else {
        ret = navigationAnimator;
        //        slidingNavigationAnimator = [NavigationFadeAnimator new];
    }

    ret.isPresenting = operation == UINavigationControllerOperationPush;

    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"toVC = %@", toVC);
    NSLog(@"fromVC = %@", fromVC);

    return ret;
}


@end