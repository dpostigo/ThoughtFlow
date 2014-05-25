//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "ToolbarController.h"
#import "UIView+DPConstraints.h"
#import "UIView+DPKit.h"
#import "UIView+TFFonts.h"
#import "UIView+DPKitChildren.h"
#import "TFDrawerModalAnimator.h"
#import "NotesDrawerController.h"
#import "UIColor+TFApp.h"
#import "ToolbarController+Utils.h"
#import "TFRightDrawerAnimator.h"
#import "UIViewController+BasicAnimator.h"

@implementation ToolbarController

@synthesize toolbarMode;

- (void) loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.layer.borderWidth = 0.5;
    self.view.layer.borderColor = [UIColor tfToolbarBorderColor].CGColor;
}


- (void) viewDidLoad {
    [super viewDidLoad];

    rightDrawerAnimator = [TFRightDrawerAnimator new];

    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view updateWidthConstraint: buttonsView.width];
    [self.view setNeedsUpdateConstraints];

    self.buttons = [buttonsView childrenOfClass: [UIButton class]];
    [self setupButtons];
    [self setupNotifications];

    [self.view convertFonts];

    self.toolbarMode = TFToolbarModeDefault;
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

- (void) setupNotifications {

    [[NSNotificationCenter defaultCenter] addObserverForName: TFNavigationNotification
            object: nil
            queue: nil
            usingBlock: ^(NSNotification *notification) {

                NSNumber *number = [notification.userInfo objectForKey: TFViewControllerTypeKey];
                TFViewControllerType type = (TFViewControllerType) [number intValue];
                [self selectButtonForType: type];

                switch (type) {

                    case TFControllerMindmap :
                        self.toolbarMode = TFToolbarModeMindmap;
                        break;
                }

            }];

    //    [[NSNotificationCenter defaultCenter] addObserverForName: TFToolbarMindmapNotification
    //                                                      object: nil
    //                                                       queue: nil
    //                                                  usingBlock: ^(NSNotification *notification) {
    //                                                      self.toolbarMode = TFToolbarModeMindmap;
    //                                                  }];

    [[NSNotificationCenter defaultCenter] addObserverForName: TFToolbarAccountDrawerClosed
            object: nil
            queue: nil
            usingBlock: ^(NSNotification *notification) {
                _accountButton.selected = NO;
            }];
    [[NSNotificationCenter defaultCenter] addObserverForName: TFToolbarSettingsDrawerClosed
            object: nil
            queue: nil
            usingBlock: ^(NSNotification *notification) {
                _settingsButton.selected = NO;
            }];

}


#pragma mark IBActions


- (IBAction) handleButton: (UIButton *) button {
    [self toggleButton: button];
    [self toggleDrawer: button];

}


- (IBAction) handleProjectsButton: (UIButton *) button {
    //    [self toggleButton: button];
    self.toolbarMode = TFToolbarModeDefault;
    //    [[NSNotificationCenter defaultCenter] postNotificationName: TFToolbarProjectsNotification object: nil];
    //    [[NSNotificationCenter defaultCenter] postNotificationName: TFNavigationNotification
    //                                                        object: nil
    //                                                      userInfo: @{
    //                                                              TFViewControllerTypeName : @"ProjectsController",
    //                                                              TFViewControllerTypeKey : [NSNumber numberWithInteger: TFControllerProjects]
    //                                                      }];

    [self postNavigationNotificationForType: TFControllerProjects];
}


- (IBAction) handleMoodboardButton: (UIButton *) button {
    [self toggleButton: button];
    [self postNavigationNotificationForType: button.selected ? TFControllerMoodboard : TFControllerMindmap];
    //    [self postNavigationNotificationForController: button.selected ? @"MoodboardController" : @"MindmapController"];

}


- (IBAction) handleSettingsButton: (UIButton *) button {
    //    [self deselectAll: button];
    //    button.selected = !button.selected;

    [self toggleButton: button];

    if (button.selected) {
        [self openDrawer: self.settingsDrawerController];

    } else {
        [self closeDrawer];
    }
}


- (IBAction) handleNotesButton: (UIButton *) button {
    [self toggleButton: button];
    if (button.selected) {
        [self openDrawer: self.notesDrawerController];
    } else {
        [self closeDrawer];
    }
}

- (IBAction) handleInfoButton: (UIButton *) button {

}

#pragma mark Drawer


- (IBAction) toggleDrawer: (id) sender {
    UIButton *button = sender;
    if (button.selected) {
        [self openDrawer: self.generalDrawerController];

    } else {
        [self closeDrawer];
    }
}

- (void) openDrawer: (UIViewController *) controller {

    if ([controller isKindOfClass: [NotesDrawerController class]]) {
        [self presentController: controller withAnimator: rightDrawerAnimator];
    }
    void (^completion)() = ^{
        controller.transitioningDelegate = self;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        toolbarDrawer = controller;

        [self presentViewController: toolbarDrawer animated: YES
                completion: nil];
    };

    if (self.presentedViewController) {
        [self dismissViewControllerAnimated: YES completion: completion];
    } else {
        completion();
    }

}

- (void) closeDrawer {
    if (toolbarDrawer && !toolbarDrawer.isBeingDismissed) {
        [self dismissViewControllerAnimated: YES completion: nil];
    }

}





#pragma mark Toolbar mode

- (void) setToolbarMode: (TFToolbarMode) toolbarMode1 {
    toolbarMode = toolbarMode1;

    [UIView animateWithDuration: 0.4 animations: ^{
        if (toolbarMode == TFToolbarModeMindmap) {
            _notesButton.alpha = 1;
            _moodButton.alpha = 1;

        } else {
            _notesButton.alpha = 0;
            _moodButton.alpha = 0;
        }
    }];
}



#pragma mark UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController: (UIViewController *) presented presentingController: (UIViewController *) presenting sourceController: (UIViewController *) source {
    TFDrawerModalAnimator *animator = [self animatorForPresentedController: presented];
    animator.presenting = YES;
    animator.sourceController = source;
    return animator;
}


- (id <UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController: (UIViewController *) dismissed {
    // TODO : Capture the dismissed controller, update button state
    TFDrawerModalAnimator *animator = [self animatorForPresentedController: dismissed];

    NSLog(@"dismissed = %@", dismissed);
    return animator;
}


- (TFDrawerModalAnimator *) animatorForPresentedController: (UIViewController *) presented {

    NSLog(@"%s", __PRETTY_FUNCTION__);
    TFDrawerModalAnimator *animator = [TFDrawerModalAnimator new];
    animator.debug = YES;
    if ([presented isKindOfClass: [NotesDrawerController class]]) {
        return rightDrawerAnimator;
        animator.modalSize = CGSizeMake(450, self.view.height);
        animator.sourceModalOrigin = CGPointMake(self.view.window.height + 450, 0);
        animator.destinationModalOrigin = CGPointMake(1024 - 450, 0);

    } else {
        animator.modalSize = CGSizeMake(290, self.view.height);
        animator.sourceModalOrigin = CGPointMake(-450, 0);
        animator.destinationModalOrigin = CGPointMake(60, 0);
    }
    return animator;
}


#pragma mark View controller instantiation

- (UIViewController *) generalDrawerController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"TFAccountDrawerController"];
}

- (UIViewController *) notesDrawerController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"NotesDrawerController"];
}


- (UIViewController *) settingsDrawerController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"TFSettingsDrawerController"];
}


@end