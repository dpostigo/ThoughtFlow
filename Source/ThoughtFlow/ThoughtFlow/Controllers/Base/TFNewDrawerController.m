//
// Created by Dani Postigo on 7/1/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNewDrawerController.h"


@implementation TFNewDrawerController

- (IBAction) closeDrawer: (id) sender {
    [self _notifyDrawerControllerShouldDismiss];
}

- (void) _notifyDrawerControllerShouldDismiss {
    if (_drawerDelegate && [_drawerDelegate respondsToSelector: @selector(drawerControllerShouldDismiss:)]) {
        [_drawerDelegate drawerControllerShouldDismiss: self];
    }
}
@end