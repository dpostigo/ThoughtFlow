//
// Created by Dani Postigo on 7/1/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNewDrawerController.h"

@implementation TFNewDrawerController

@synthesize drawerDelegate;

- (IBAction) closeDrawer: (id) sender {
    [self _notifyDrawerControllerShouldDismiss];
}

- (void) _notifyDrawerControllerShouldDismiss {
    if (drawerDelegate && [drawerDelegate respondsToSelector: @selector(drawerControllerShouldDismiss:)]) {
        [drawerDelegate drawerControllerShouldDismiss: self];
    }
}
@end