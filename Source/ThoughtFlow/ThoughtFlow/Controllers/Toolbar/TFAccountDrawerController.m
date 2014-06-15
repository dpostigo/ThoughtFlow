//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFAccountDrawerController.h"
#import "UIView+TFFonts.h"
#import "TFCustomTextField.h"
#import "TFConstants.h"
#import "Model.h"
#import "APIModel.h"
#import "APIUser.h"

@implementation TFAccountDrawerController

- (void) viewDidLoad {
    [super viewDidLoad];

    usernameField.text = _apiModel.currentUser.username;
    emailField.text = _apiModel.currentUser.email;

    emailField.leftAccessoryImageView.image = [UIImage imageNamed: @"email-icon"];
    usernameField.leftAccessoryImageView.image = [UIImage imageNamed: @"user-icon"];
    passwordField.leftAccessoryImageView.image = [UIImage imageNamed: @"password-icon"];

}

#pragma mark

- (IBAction) closeDrawer: (id) sender {

    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated: YES completion: ^() {
            [[NSNotificationCenter defaultCenter] postNotificationName: TFToolbarAccountDrawerClosed object: nil];
        }];
    } else {
        [self.navigationController popViewControllerAnimated: YES];
    }

    [self.presentingViewController dismissViewControllerAnimated: YES
            completion: nil];

}



#pragma mark Dismiss

- (CGSize) freeformSizeForViewController {
    return CGSizeMake(290, 768);
}

@end