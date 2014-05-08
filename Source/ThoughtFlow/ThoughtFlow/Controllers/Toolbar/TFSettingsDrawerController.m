//
// Created by Dani Postigo on 5/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFSettingsDrawerController.h"

@implementation TFSettingsDrawerController



#pragma mark IBActions

- (IBAction) handleCloseButton: (UIButton *) button {
    [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
}
@end