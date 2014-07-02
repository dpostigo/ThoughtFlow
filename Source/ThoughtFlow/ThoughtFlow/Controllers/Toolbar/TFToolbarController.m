//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPAnimators/UIViewController+BasicModalAnimator.h>
#import "TFToolbarController.h"
#import "UIView+DPConstraints.h"
#import "UIView+DPKit.h"
#import "UIView+TFFonts.h"
#import "UIView+DPKitChildren.h"
#import "TFDrawerModalAnimator.h"
#import "NotesDrawerController.h"
#import "UIColor+TFApp.h"
#import "TFToolbarController+Utils.h"
#import "TFRightDrawerAnimator.h"
#import "TFToolbarDelegate.h"
#import "UIViewController+TFControllers.h"

@implementation TFToolbarController

@synthesize toolbarMode;
@synthesize delegate;

- (void) loadView {
    [super loadView];
    [self _setupCosmetic];
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

- (void) _setupCosmetic {
    self.view.backgroundColor = [UIColor clearColor];
//    self.view.layer.borderWidth = 0.5;
//    self.view.layer.borderColor = [UIColor tfToolbarBorderColor].CGColor;
}

- (void) setupButtons {
    for (UIButton *button in self.buttons) {
        //        NSArray *actions = [button actionsForTarget: self forControlEvent: UIControlEventTouchUpInside];
        //        if ([actions count] == 0) {
        //            [button addTarget: self action: @selector(handleButton:)
        //                    forControlEvents: UIControlEventTouchUpInside];
        //        }
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
    [self postNavigationNotificationForType: TFControllerProjects];
}


- (IBAction) handleMoodboardButton: (UIButton *) button {
    [self toggleButton: button];
    [self toolbarDidChangeSelection: button.selected forButtonType: TFToolbarButtonMoodboard];
    //    [self postNavigationNotificationForType: button.selected ? TFControllerMoodboard : TFControllerMindmap];
    //    [self postNavigationNotificationForController: button.selected ? @"MoodboardController" : @"MindmapController"];

}


- (IBAction) handleInfoButton: (UIButton *) button {
    [self toggleButton: button];
    [self toolbarDidChangeSelection: button.selected forButtonType: TFToolbarButtonInfo];
    //    [self postNavigationNotificationForType: button.selected ? TFControllerMoodboard : TFControllerMindmap];

}


- (IBAction) handleAccountButton: (UIButton *) button {
    [self toggleButton: button];
    [self toolbarDidChangeSelection: button.selected forButtonType: TFToolbarButtonAccount];
}


- (IBAction) handleSettingsButton: (UIButton *) button {
    [self toggleButton: button];
    [self toolbarDidChangeSelection: button.selected forButtonType: TFToolbarButtonSettings];

}

- (IBAction) handleNotesButton: (UIButton *) button {
    [self toggleButton: button];
    [self toolbarDidChangeSelection: button.selected forButtonType: TFToolbarButtonNotes];
}

#pragma mark Drawer


- (IBAction) toggleDrawer: (id) sender {
    UIButton *button = sender;
    if (button.selected) {
        [self openDrawer: self.accountViewController];

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

        [self presentViewController: toolbarDrawer animated: YES  completion: nil];
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


#pragma mark Delegate


- (void) toolbarDidChangeSelection: (BOOL) selected forButtonType: (TFToolbarButtonType) type {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSNumber *numberType = [NSNumber numberWithInteger: type];

    if (delegate && [delegate respondsToSelector: @selector(toolbarChangeSelection:forType:)]) {
        [delegate toolbarChangeSelection: selected forType: type];
    }
    if (selected) {
        [self toolbarDidSelectButtonWithType: numberType];

    } else {
        [self toolbarDidDeselectButtonWithType: numberType];
    }
}

- (void) toolbarDidSelectButtonWithType: (NSNumber *) type {
    if (delegate && [delegate respondsToSelector: @selector(toolbarDidSelectButtonWithType:)]) {
        [delegate performSelector: @selector(toolbarDidSelectButtonWithType:) withObject: [NSNumber numberWithInteger: type]];
    }
}

- (void) toolbarDidDeselectButtonWithType: (NSNumber *) type {
    if (delegate && [delegate respondsToSelector: @selector(toolbarDidDeselectButtonWithType:)]) {
        [delegate performSelector: @selector(toolbarDidDeselectButtonWithType:) withObject: [NSNumber numberWithInteger: type]];
    }
}


#pragma mark UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController: (UIViewController *) presented presentingController: (UIViewController *) presenting sourceController: (UIViewController *) source {
    TFDrawerModalAnimator *animator = [self animatorForPresentedController: presented];
    animator.isPresenting = YES;
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
    if ([presented isKindOfClass: [NotesDrawerController class]]) {
        return rightDrawerAnimator;

    } else {
    }
    return animator;
}


@end