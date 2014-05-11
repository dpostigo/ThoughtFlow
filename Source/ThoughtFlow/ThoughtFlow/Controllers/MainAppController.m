//
// Created by Dani Postigo on 5/4/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPTransitions/CustomModalSegue.h>
#import "CustomModalAnimator.h"
#import "MainAppController.h"
#import "ToolbarController.h"
#import "Model.h"
#import "ProjectLibrary.h"

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


- (void) viewDidLoad {
    [super viewDidLoad];
    navController = (UINavigationController *) ([contentController isKindOfClass: [UINavigationController class]] ? contentController : nil);
    if (navController) {
        [self setupNotifications];
    }

}

- (void) setupNotifications {

    void (^block)(NSNotification *) = ^(NSNotification *notification) {

        BOOL pushes = [[notification.userInfo objectForKey: TFViewControllerShouldPushKey] boolValue];
        NSNumber *number = [notification.userInfo objectForKey: TFViewControllerTypeKey];
        TFViewControllerType type = (TFViewControllerType) [number intValue];

        // [_model.projectLibrary save];

        if (pushes) {
            NSString *name = [notification.userInfo objectForKey: TFViewControllerTypeName];
            [self goToViewControllerClass: NSClassFromString(name)];
        }

    };

    [[NSNotificationCenter defaultCenter] addObserverForName: TFNavigationNotification
                                                      object: nil
                                                       queue: nil
                                                  usingBlock: block];
    //
    //    [[NSNotificationCenter defaultCenter] addObserverForName: TFToolbarProjectsNotification
    //                                                      object: nil
    //                                                       queue: nil
    //                                                  usingBlock: ^(NSNotification *notification) {
    //
    //                                                      NSLog(@"notification.userInfo = %@", notification.userInfo);
    //                                                      [_model.projectLibrary save];
    //
    //                                                      [self goToViewControllerClass: [ProjectsController class]];
    //                                                  }];

}


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
        toolbarController = (ToolbarController *) controller;

    }
}

@end