//
// Created by Dani Postigo on 6/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPTransitions/CustomModalSegue.h>
#import <DPAnimators/NavigationFadeAnimator.h>
#import "NewMainAppController.h"
#import "UIViewController+TFControllers.h"
#import "NavigationSlideAnimator.h"
#import "Model.h"
#import "TFContentViewNavigationController.h"
#import "TFInfoViewController.h"
#import "TFMindmapGridViewController.h"
#import "TFMoodboardViewController.h"
#import "NotesDrawerController.h"
#import "ProjectsController.h"
#import "TFNewSettingsDrawerController.h"
#import "CreateProjectController.h"
#import "TFNewMoodboardViewController.h"
#import "TFNewNotesDrawerController.h"
#import "APIModel.h"
#import "TFNewAboutViewController.h"


#define NEW_MOODBOARD DEBUG
#define NEW_IMAGE_SETTINGS DEBUG

@implementation NewMainAppController

- (void) viewDidLoad {
    [super viewDidLoad];

    _contentNavigationController.contentView = _contentView;

    if ([_model.projects count] > 0) {
        [_contentNavigationController setViewControllers: @[self.projectsController] animated: NO];
    }
}


#pragma mark - Embed segue

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
        _contentNavigationController = (TFContentViewNavigationController *) controller;
        //        _contentNavigationController.delegate = self.slidingNavigationAnimator;
        _contentNavigationController.delegate = self;

    } else if ([segue.identifier isEqualToString: @"ToolbarEmbedSegue"]) {
        _toolbarController = (TFNewToolbarController *) controller;
        _toolbarController.delegate = self;

    }
}


#pragma mark - TFNewToolbarControllerDelegate

- (void) toolbarControllerClickedButtonWithType: (TFNewToolbarButtonType) type {

    switch (type) {

        case TFNewToolbarButtonTypeHome :
            break;

        case TFNewToolbarButtonTypeProjects : {
            UIViewController *controller = [_model.projects count] > 0 ? self.projectsController : [[CreateProjectController alloc] init];
            [_contentNavigationController setViewControllers: @[controller] animated: YES];
        }
            break;

        case TFNewToolbarButtonTypeNotes : {

            TFNewDrawerController *controller = [[TFNewNotesDrawerController alloc] initWithProject: _model.selectedProject];
            _contentNavigationController.rightDrawerController = controller;
            [_contentNavigationController openRightContainer];
            _toolbarController.selectedIndex = type;
        }
            break;

        case TFNewToolbarButtonTypeMoodboard : {
            TFNewMoodboardViewController *controller = [[TFNewMoodboardViewController alloc] initWithProject: _model.selectedProject];
            [_contentNavigationController toggleViewController: controller animated: YES];
        }
            break;

        case TFNewToolbarButtonTypeAccount : {
            TFNewAccountViewController *controller = [[TFNewAccountViewController alloc] init];;
            controller.delegate = self;

            _contentNavigationController.leftDrawerController = controller;
            [_contentNavigationController openLeftContainer];
            _toolbarController.selectedIndex = type;
        }
            break;

        case TFNewToolbarButtonTypeImageSettings : {
            TFNewSettingsDrawerController *controller = [[TFNewSettingsDrawerController alloc] init];
            _contentNavigationController.leftDrawerController = controller;

            [_contentNavigationController openLeftContainer];
            _toolbarController.selectedIndex = type;
        }
            break;

        case TFNewToolbarButtonTypeInfo : {

            TFNewAboutViewController *controller = [[TFNewAboutViewController alloc] init];
            [_contentNavigationController toggleViewController: controller animated: YES];
            //            [_contentNavigationController toggleViewController: self.infoViewController animated: YES];

        }
            break;

        default :
            break;
    }

}


#pragma mark - TFNewAccountViewControllerDelegate

- (void) accountViewController: (TFNewAccountViewController *) accountViewController clickedSignOutButton: (UIButton *) button {

    [[APIModel sharedModel] signOutWithCompletion: ^{
        UIViewController *controller = [[UIStoryboard storyboardWithName: @"Prestoryboard" bundle: nil] instantiateViewControllerWithIdentifier: @"InitialViewController"];

        UINavigationController *navigationController = (UINavigationController *) self.view.window.rootViewController;
        NSLog(@"self.view.window.rootViewController = %@", self.view.window.rootViewController);

        [navigationController setViewControllers: @[controller] animated: YES];
    }];

}



#pragma mark - UINavigationController delegate

- (void) navigationController: (UINavigationController *) navigationController willShowViewController: (UIViewController *) viewController animated: (BOOL) animated {
    BOOL showsProjectButtons = [self showsProjectButtons: viewController];
    [_toolbarController buttonForType: TFNewToolbarButtonTypeMoodboard].hidden = !showsProjectButtons;
    [_toolbarController buttonForType: TFNewToolbarButtonTypeNotes].hidden = !showsProjectButtons;
}

- (void) navigationController: (UINavigationController *) navigationController didShowViewController: (UIViewController *) viewController animated: (BOOL) animated {
    NSString *controllerClass = NSStringFromClass([viewController class]);

    if ([viewController isKindOfClass: [ProjectsController class]]) {
        _toolbarController.selectedIndex = TFNewToolbarButtonTypeProjects;

    } else if ([viewController isKindOfClass: [TFInfoViewController class]]) {
        _toolbarController.selectedIndex = TFNewToolbarButtonTypeInfo;

    } else if ([viewController isKindOfClass: [TFNewMoodboardViewController class]]) {
        _toolbarController.selectedIndex = TFNewToolbarButtonTypeMoodboard;

    } else {
        _toolbarController.selectedIndex = -1;
    }
}

- (id <UIViewControllerAnimatedTransitioning>) navigationController: (UINavigationController *) navigationController animationControllerForOperation: (UINavigationControllerOperation) operation fromViewController: (UIViewController *) sourceController toViewController: (UIViewController *) destinationController {
    BasicAnimator *ret = nil;

    NSLog(@"sourceController = %@", sourceController);
    NSLog(@"destinationController = %@", destinationController);
    if ([sourceController isKindOfClass: [TFNewMoodboardViewController class]]
            && [destinationController isKindOfClass: [ProjectsController class]]) {
        _fadingNavigationAnimator.opaque = YES;
        return _fadingNavigationAnimator;
    } else {
        _fadingNavigationAnimator.opaque = NO;
    }

    if ([destinationController isKindOfClass: [TFInfoViewController class]] ||
            [destinationController isKindOfClass: [TFNewAboutViewController class]] ||


            [destinationController isKindOfClass: [TFNewMoodboardViewController class]] ||
            [sourceController isKindOfClass: [TFNewMoodboardViewController class]] ||

            [destinationController isKindOfClass: [TFMindmapGridViewController class]]) {
        ret = self.fadingNavigationAnimator;

    } else {
        ret = self.slidingNavigationAnimator;
    }

    switch (operation) {
        case UINavigationControllerOperationNone : {
            NSLog(@"UINavigationControllerOperationNone");
        }
            break;

        case UINavigationControllerOperationPush : {
            NSLog(@"UINavigationControllerOperationPush");
        }
            break;

        case UINavigationControllerOperationPop : {
            NSLog(@"UINavigationControllerOperationPop");
        }
            break;
    }

    NSLog(@"%@: %@ -> %@", ret, sourceController, destinationController);
    ret.isPresenting = operation == UINavigationControllerOperationPush ? YES : NO;
    return ret;
}

- (BOOL) showsProjectButtons: (UIViewController *) viewController {
    BOOL ret = YES;

    if ([viewController isKindOfClass: [ProjectsController class]]
            || [viewController isKindOfClass: [CreateProjectController class]]) {
        ret = NO;
    }
    return ret;
}


#pragma mark - Getters



- (NavigationSlideAnimator *) slidingNavigationAnimator {
    if (_slidingNavigationAnimator == nil) {
        _slidingNavigationAnimator = [NavigationSlideAnimator new];
    }
    return _slidingNavigationAnimator;
}


- (NavigationFadeAnimator *) fadingNavigationAnimator {
    if (_fadingNavigationAnimator == nil) {
        _fadingNavigationAnimator = [NavigationFadeAnimator new];
    }
    return _fadingNavigationAnimator;
}

@end