//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "NewToolbarController.h"
#import "UIView+DPConstraints.h"
#import "NSLayoutConstraint+DPUtils.h"
#import "UIView+DPKit.h"
#import "UIView+TFFonts.h"
#import "UIView+DPKitChildren.h"

@implementation NewToolbarController

- (void) loadView {
    [super loadView];

    buttonsView.layer.borderWidth = 1.0;
    buttonsView.layer.borderColor = [UIColor lightGrayColor].CGColor;


}


- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view updateWidthConstraint: buttonsView.width];
    [self.view setNeedsUpdateConstraints];

    self.buttons = [buttonsView childrenOfClass: [UIButton class]];
    [self setupButtons];


    [self.view convertFonts];
}


#pragma mark Setup

- (void) setupButtons {
    for (UIButton *button in self.buttons) {
        [button setAttributedTitle: nil forState: UIControlStateNormal];
        [button setTitleColor: [UIColor darkGrayColor] forState: UIControlStateNormal];
        [button setTitleColor: [UIColor whiteColor] forState: UIControlStateSelected];
    }
}


#pragma mark IBActions


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

- (IBAction) toggleDrawer: (id) sender {
    UIButton *button = sender;
    if (button.selected) {
        [self openDrawer: nil];

    } else {
        [self closeDrawer: nil];
    }
}

- (void) openDrawer: (id) sender {
    CGFloat widthValue = buttonsView.width + drawerView.width;
    NSLayoutConstraint *widthConstraint = [self.view widthConstraint];

    if (widthConstraint.constant != widthValue) {
        widthConstraint.constant = widthValue;
        [self.view setNeedsUpdateConstraints];

        [UIView animateWithDuration: 0.25f
                         animations: ^{
                             [self.view layoutIfNeeded];

                         }
                         completion: ^(BOOL finished) {

                         }];

    }
}


- (void) closeDrawer: (id) sender {
    CGFloat widthValue = buttonsView.width;
    NSLayoutConstraint *widthConstraint = [self.view widthConstraint];

    if (widthConstraint.constant != widthValue) {
        widthConstraint.constant = widthValue;
        [self.view setNeedsUpdateConstraints];

        [UIView animateWithDuration: 0.25f
                         animations: ^{
                             [self.view layoutIfNeeded];

                         }
                         completion: ^(BOOL finished) {

                         }];

    }

}


@end