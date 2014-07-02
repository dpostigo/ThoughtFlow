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
#import "TFContentNavigationController.h"
#import "TFContentView.h"
#import "TFInfoViewController.h"
#import "NSArray+DPKit.h"
#import "MoodboardController.h"
#import "TFMoodboardViewController.h"
#import "TFMindmapGridViewController.h"


@implementation NewMainAppController {
}

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
        _contentNavigationController = (TFContentNavigationController *) controller;
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
            [_contentNavigationController setViewControllers: @[self.projectsController] animated: YES];
        }
            break;

        case TFNewToolbarButtonTypeNotes : {
            _contentNavigationController.rightDrawerController = (TFNewDrawerController *) self.notesViewController;
            [_contentNavigationController openRightContainer];
            _toolbarController.selectedIndex = type;
        }
            break;

        case TFNewToolbarButtonTypeMoodboard : {
            [_contentNavigationController toggleViewController: [[TFMoodboardViewController alloc] initWithProject: _model.selectedProject] animated: YES];

        }
            break;

        case TFNewToolbarButtonTypeAccount : {
            _contentNavigationController.leftDrawerController = (TFNewDrawerController *) self.accountViewController;
            [_contentNavigationController openLeftContainer];
            _toolbarController.selectedIndex = type;
        }
            break;

        case TFNewToolbarButtonTypeImageSettings : {
            _contentNavigationController.leftDrawerController = (TFNewDrawerController *) self.imageSettingsController;
            [_contentNavigationController openLeftContainer];
            _toolbarController.selectedIndex = type;
        }
            break;

        case TFNewToolbarButtonTypeInfo : {
            [_contentNavigationController toggleViewController: self.infoViewController animated: YES];

        }
            break;

        default :
            break;
    }

}




#pragma mark - UINavigationController delegate

- (void) navigationController: (UINavigationController *) navigationController willShowViewController: (UIViewController *) viewController animated: (BOOL) animated {

}

- (void) navigationController: (UINavigationController *) navigationController didShowViewController: (UIViewController *) viewController animated: (BOOL) animated {
    NSString *controllerClass = NSStringFromClass([viewController class]);

    if ([controllerClass isEqualToString: @"ProjectsController"]) {
        _toolbarController.selectedIndex = TFNewToolbarButtonTypeProjects;

    } else if ([controllerClass isEqualToString: @"TFInfoViewController"]) {
        _toolbarController.selectedIndex = TFNewToolbarButtonTypeInfo;

    } else if ([controllerClass isEqualToString: @"MoodboardController"]) {
        _toolbarController.selectedIndex = TFNewToolbarButtonTypeMoodboard;

    } else {
        _toolbarController.selectedIndex = -1;
    }

}

- (id <UIViewControllerAnimatedTransitioning>) navigationController: (UINavigationController *) navigationController animationControllerForOperation: (UINavigationControllerOperation) operation fromViewController: (UIViewController *) fromVC toViewController: (UIViewController *) destinationController {
    BasicAnimator *ret = nil;

    if ([destinationController isKindOfClass: [TFInfoViewController class]] ||
            [destinationController isKindOfClass: [TFMoodboardViewController class]] ||
            [destinationController isKindOfClass: [TFMindmapGridViewController class]]) {
        ret = self.fadingNavigationAnimator;
    } else {
        ret = self.slidingNavigationAnimator;
    }
    ret.isPresenting = operation == UINavigationControllerOperationPush ? YES : NO;
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