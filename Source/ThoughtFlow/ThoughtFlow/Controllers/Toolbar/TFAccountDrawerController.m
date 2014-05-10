//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFAccountDrawerController.h"
#import "UIView+TFFonts.h"
#import "TFCustomTextField.h"
#import "TFConstants.h"

@implementation TFAccountDrawerController

- (void) viewDidLoad {
    [super viewDidLoad];

    emailField.leftAccessoryImageView.image = [UIImage imageNamed: @"email-icon"];
    usernameField.leftAccessoryImageView.image = [UIImage imageNamed: @"user-icon"];
    passwordField.leftAccessoryImageView.image = [UIImage imageNamed: @"password-icon"];

}

#pragma mark

- (IBAction) closeDrawer: (id) sender {
    [self.presentingViewController dismissViewControllerAnimated: YES completion: ^() {
        [[NSNotificationCenter defaultCenter] postNotificationName: TFToolbarAccountDrawerClosed object: nil];
    }];
}



#pragma mark Dismiss

- (CGSize) freeformSizeForViewController {
    return CGSizeMake(290, 768);
}

@end