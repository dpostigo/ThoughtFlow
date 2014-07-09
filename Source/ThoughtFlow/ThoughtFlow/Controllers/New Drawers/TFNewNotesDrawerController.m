//
// Created by Dani Postigo on 7/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNewNotesDrawerController.h"
#import "Project.h"


@implementation TFNewNotesDrawerController

- (IBAction) handleButton: (UIButton *) button {

    button.selected = !button.selected;

    if (button.selected) {

        // edit
    } else {
        // save
    }
}
@end