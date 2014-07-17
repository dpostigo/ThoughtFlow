//
// Created by Dani Postigo on 6/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPTransitions/CustomModalSegue.h>
#import <DPAnimators/NavigationFadeAnimator.h>
#import <DPKit-Utils/UIViewController+DPKit.h>
#import "TFNewAccountViewController.h"
#import "TFMainViewController.h"
#import "NavigationSlideAnimator.h"
#import "Model.h"
#import "TFContentViewNavigationController.h"
#import "TFMindmapGridViewController.h"
#import "ProjectsController.h"
#import "TFNewSettingsDrawerController.h"
#import "CreateProjectController.h"
#import "TFMoodboardViewController.h"
#import "TFNewNotesDrawerController.h"
#import "APIModel.h"
#import "TFNewAboutViewController.h"
#import "UIView+DPKit.h"


@interface TFMainViewController ()

@property(weak) IBOutlet UIView *toolbarContainerView;
@property(nonatomic, strong) TFNewToolbarViewController *toolbarViewController;
@property(nonatomic, strong) NavigationFadeAnimator *fadingNavigationAnimator;
@property(nonatomic, strong) NavigationSlideAnimator *slidingNavigationAnimator;
@end

@implementation TFMainViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    return [self viewControllerFromStoryboard: @"Storyboard"];
}


- (id) init {
    self = [super init];
    if (self) {

        NSLog(@"%s", __PRETTY_FUNCTION__);
    }

    return self;
}


- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
        _fadingNavigationAnimator = [NavigationFadeAnimator new];
        _slidingNavigationAnimator = [NavigationSlideAnimator new];
    }

    return self;
}

#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];

    _contentNavigationController.contentView = _contentView;

    if ([_model.projects count] > 0) {
        ProjectsController *controller = [[ProjectsController alloc] init];
        [_contentNavigationController setViewControllers: @[controller] animated: NO];
    }

    [self _setupNewToolbar];
}


- (void) _setupNewToolbar {
    _toolbarViewController = [[TFNewToolbarViewController alloc] init];
    _toolbarViewController.delegate = self;
    [self embedController: _toolbarViewController inView: _toolbarContainerView];

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
        _contentNavigationController.delegate = self;
    }

}


#pragma mark - TFNewToolbarControllerDelegate

- (void) toolbarControllerClickedButtonWithType: (TFToolbarButtonType) type {

    switch (type) {

        case TFToolbarButtonTypeHome :
            break;

        case TFToolbarButtonTypeProjects : {
            UIViewController *controller = nil;
            if ([_model.projects count] > 0) {
                controller = [[ProjectsController alloc] init];
            } else {
                controller = [[CreateProjectController alloc] init];
            }

            [_contentNavigationController setViewControllers: @[controller] animated: YES];
        }
            break;

        case TFToolbarButtonTypeNotes : {
            TFNewDrawerController *controller = [[TFNewNotesDrawerController alloc] initWithProject: _model.selectedProject];
            _contentNavigationController.rightDrawerController = controller;
            [_contentNavigationController openRightContainer];
            _toolbarViewController.selectedIndex = type;
        }
            break;

        case TFToolbarButtonTypeMoodboard : {
            TFMoodboardViewController *controller = [[TFMoodboardViewController alloc] initWithProject: _model.selectedProject];
            [_contentNavigationController toggleViewController: controller animated: YES];
            break;
        }

        case TFToolbarButtonTypeAccount : {

            TFNewAccountViewController *controller = [[TFNewAccountViewController alloc] init];
            controller.navigationBarHeight = [_toolbarViewController buttonForType: TFToolbarButtonTypeHome].height;
            controller.rowHeight = [_toolbarViewController buttonForType: TFToolbarButtonTypeProjects].height;

            _contentNavigationController.leftDrawerController = controller;
            [_contentNavigationController openLeftContainer];
            _toolbarViewController.selectedIndex = type;
            break;
        }

        case TFToolbarButtonTypeImageSettings : {
            TFNewSettingsDrawerController *controller = [[TFNewSettingsDrawerController alloc] init];
            _contentNavigationController.leftDrawerController = controller;
            [_contentNavigationController openLeftContainer];
            _toolbarViewController.selectedIndex = type;
            break;
        }

        case TFToolbarButtonTypeInfo : {
            TFNewAboutViewController *controller = [[TFNewAboutViewController alloc] init];
            controller.drawerDelegate = self;

            [_contentNavigationController toggleViewController: controller animated: YES];
            break;
        }

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


#pragma mark -

- (void) drawerControllerShouldDismiss: (TFNewDrawerController *) drawerController {

    [self toolbarControllerClickedButtonWithType: TFToolbarButtonTypeInfo];
}


#pragma mark - UINavigationController delegate

- (void) navigationController: (UINavigationController *) navigationController willShowViewController: (UIViewController *) viewController animated: (BOOL) animated {
    BOOL showsProjectButtons = [self showsProjectButtons: viewController];
    [_toolbarViewController buttonForType: TFToolbarButtonTypeMoodboard].hidden = !showsProjectButtons;
    [_toolbarViewController buttonForType: TFToolbarButtonTypeNotes].hidden = !showsProjectButtons;

}

- (void) navigationController: (UINavigationController *) navigationController didShowViewController: (UIViewController *) viewController animated: (BOOL) animated {

    //    Class classReference = [viewController class];
    if ([viewController isKindOfClass: [ProjectsController class]]) {
        _toolbarViewController.selectedIndex = TFToolbarButtonTypeProjects;

    } else if ([viewController isKindOfClass: [TFNewAboutViewController class]]) {
        _toolbarViewController.selectedIndex = TFToolbarButtonTypeInfo;

    } else if ([viewController isKindOfClass: [TFMoodboardViewController class]]) {
        _toolbarViewController.selectedIndex = TFToolbarButtonTypeMoodboard;

    } else {
        _toolbarViewController.selectedIndex = -1;
    }

}

- (id <UIViewControllerAnimatedTransitioning>) navigationController: (UINavigationController *) navigationController animationControllerForOperation: (UINavigationControllerOperation) operation fromViewController: (UIViewController *) sourceController toViewController: (UIViewController *) destinationController {
    BasicAnimator *ret = nil;

    if ([sourceController isKindOfClass: [TFMoodboardViewController class]]
            && [destinationController isKindOfClass: [ProjectsController class]]) {
        _fadingNavigationAnimator.opaque = YES;
        return _fadingNavigationAnimator;

    } else {
        _fadingNavigationAnimator.opaque = NO;
    }

    if (
            [destinationController isKindOfClass: [TFNewAboutViewController class]] ||

                    [destinationController isKindOfClass: [TFMoodboardViewController class]] ||
                    [sourceController isKindOfClass: [TFMoodboardViewController class]] ||

                    [destinationController isKindOfClass: [TFMindmapGridViewController class]]) {
        ret = self.fadingNavigationAnimator;

    } else {
        ret = self.slidingNavigationAnimator;
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



@end