//
// Created by Dani Postigo on 5/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "ToolbarController+Utils.h"
#import "TFConstants.h"

@implementation ToolbarController (Utils)

- (void) selectButtonForType: (TFViewControllerType) type {

    switch (type) {
        case TFControllerNone :
            break;

        case TFControllerProjects :
            [self deselectAll];
            self.projectsButton.selected = YES;
            break;

        case TFControllerMindmap :
            [self deselectAll];
            //            _projectsButton.selected = YES;
            break;

        case TFControllerMoodboard :
            [self deselectAll];
            self.moodButton.selected = YES;
            break;
    }
}

- (void) toggleButton: (UIButton *) button {
    [self deselectAll: button];
    button.selected = !button.selected;
    NSLog(@"button.selected = %d", button.selected);
}

- (void) deselectAll: (id) sender {
    for (UIButton *button in self.buttons) {
        if (button != sender) {
            button.selected = NO;
        }
    }
}


- (void) deselectAll {
    for (UIButton *button in self.buttons) {
        button.selected = NO;
    }
}

@end