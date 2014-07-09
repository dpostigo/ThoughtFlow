//
// Created by Dani Postigo on 5/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFSettingsDrawerController.h"


@implementation TFSettingsDrawerController



#pragma mark IBActions

- (IBAction) closeDrawer: (id) sender {
    [self _notifyDrawerControllerShouldDismiss];
    //    [self.presentingViewController dismissViewControllerAnimated: YES completion: ^() {
    //        [[NSNotificationCenter defaultCenter] postNotificationName: TFToolbarSettingsDrawerClosed object: nil];
    //    }];
}


@end