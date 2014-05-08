//
// Created by Dani Postigo on 5/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "ToolbarController+Utils.h"

@implementation ToolbarController (Utils)



- (void) deselectAll: (id) sender {
    for (UIButton *button in self.buttons) {
        if (button != sender) {
            button.selected = NO;
        }
    }
}

@end