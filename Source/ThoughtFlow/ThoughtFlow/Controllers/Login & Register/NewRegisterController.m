//
// Created by Dani Postigo on 5/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>
#import <AFOAuth2Client/AFOAuth2Client.h>
#import "NewRegisterController.h"
#import "DPTableView.h"
#import "FieldTableViewCell.h"
#import "UIAlertView+Blocks.h"
#import "Model.h"
#import "DPTableView+DataUtils.h"
#import "APIModel.h"

@implementation NewRegisterController

- (void) prepareDatasource {
    //    [super prepareDatasource];
    [self.table.rows addObject: @{DPTableViewTextLabelName : @"Username", DPTableViewImageName : [UIImage imageNamed: @"user-icon"]}];
    [self.table.rows addObject: @{DPTableViewTextLabelName : @"Email", DPTableViewImageName : [UIImage imageNamed: @"email-icon"]}];
    [self.table.rows addObject: @{DPTableViewTextLabelName : @"Password", DPTableViewImageName : [UIImage imageNamed: @"password-icon"]}];

}





#pragma mark IBActions

- (IBAction) handleRegister: (id) sender {
    __block NSDictionary *dictionary = nil;

    if ([self.usernameField.text length] == 0) {
        dictionary = @{
                @"Title" : @"No username",
                @"Message" : @"Please enter a username."
        };
        [self alertErrorWithDictionary: dictionary];
    } else if ([self.emailField.text length] == 0) {
        dictionary = @{
                @"Title" : @"No email address",
                @"Message" : @"Please enter a email address."
        };
        [self alertErrorWithDictionary: dictionary];
    } else if ([self.passwordField.text length] == 0) {
        dictionary = @{
                @"Title" : @"No password",
                @"Message" : @"Please enter a password."
        };
        [self alertErrorWithDictionary: dictionary];
    } else {

        [_model.apiModel userExists: self.usernameField.text completion: ^(BOOL exists) {
            if (exists) {
                [self alertErrorWithDictionary: @{
                        @"Title" : @"User already exists",
                        @"Message" : @"This username is already taken. Please choose another one."
                }];

            } else {
                [_model.apiModel registerUser: self.usernameField.text
                        password: self.passwordField.text
                        email: self.emailField.text
                        success: ^{

                            [_model.apiModel login: self.usernameField.text
                                    password: self.passwordField.text
                                    completion: ^{
                                        [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
                                    }
                                    failure: nil];
                        }
                        failure: nil];

            }
        }];
    }

}


- (void) alertErrorWithDictionary: (NSDictionary *) dictionary {
    [UIAlertView showWithTitle: [dictionary objectForKey: @"Title"]
            message: [dictionary objectForKey: @"Message"]
            cancelButtonTitle: @"OK"
            otherButtonTitles: @[]
            tapBlock: nil];
}


#pragma mark Getters

- (UITextField *) usernameField {
    FieldTableViewCell *cell = (FieldTableViewCell *) [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 0]];
    return cell.textField;
}

- (UITextField *) emailField {
    FieldTableViewCell *cell = (FieldTableViewCell *) [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForRow: 2 inSection: 0]];
    return cell.textField;
}

- (UITextField *) passwordField {
    FieldTableViewCell *cell = (FieldTableViewCell *) [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForRow: 1 inSection: 0]];
    return cell.textField;
}

@end