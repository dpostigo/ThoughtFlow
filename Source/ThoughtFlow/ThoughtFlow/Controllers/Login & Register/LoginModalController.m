//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "LoginModalController.h"
#import "DPTableView.h"
#import "UIView+DPKit.h"
#import "UITableView+DPTableView.h"
#import "UIView+DPConstraints.h"
#import "FieldTableViewCell.h"
#import "UIView+DPKitKeyboard.h"
#import "TFLoginOperation.h"
#import "DPTableView+DataUtils.h"
#import "TFCustomTextField.h"
#import "UIView+TFFonts.h"
#import "AFOAuth2Client.h"
#import "Model.h"
#import "UIAlertView+Blocks.h"
#import "APIModel.h"
#import "APIUser.h"
#import "UIViewController+TFControllers.h"

@implementation LoginModalController

@synthesize table;

- (void) viewDidLoad {
    [super viewDidLoad];
    dismisses = NO;

    [self.view convertFonts];
    table.delegate = self;
    table.dataSource = self;
    table.populateTextLabels = YES;

    [self prepareDatasource];

    __weak LoginModalController *weakSelf = self;
    table.onReload = ^(DPTableView *theTable) {
        __strong LoginModalController *strongSelf = weakSelf;
        if (strongSelf) {
            CGFloat newheight = theTable.calculatedTableHeight;
            theTable.height = newheight;
            [theTable updateHeightConstraint: newheight];
            [strongSelf.view setNeedsUpdateConstraints];

            NSLog(@"strongSelf.model.apiModel.loggedIn = %d", strongSelf.model.apiModel.loggedIn);

            if (strongSelf.model.apiModel.loggedIn) {
                strongSelf.usernameField.text = strongSelf.model.apiModel.currentUser.username;
                strongSelf.passwordField.text = strongSelf.model.apiModel.currentUser.password;
            }
        }

    };

    [table reloadData];
    table.layer.cornerRadius = 3;
}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    if (_model.apiModel.loggedIn) {
        [self handleLogin: nil];
    }
}

- (void) prepareDatasource {
    [table.rows addObject: @{DPTableViewTextLabelName : @"Username or email", DPTableViewImageName : [UIImage imageNamed: @"user-icon"]}];
    [table.rows addObject: @{DPTableViewTextLabelName : @"Password", DPTableViewImageName : [UIImage imageNamed: @"password-icon"]}];
}


#pragma mark IBActions

- (IBAction) signInInstead: (id) sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction) handleLogin: (id) sender {

    NSString *errorTitle = nil;
    NSString *errorMessage = nil;
    NSLog(@"self.usernameField = %@", self.usernameField);
    if ([self.usernameField.text length] == 0 || [self.usernameField.text isEqualToString: @""]) {
        [UIAlertView showWithTitle: @"No username"
                message: @"Please fill out a username."
                cancelButtonTitle: @"OK"
                otherButtonTitles: @[]
                tapBlock: nil];
    } else if ([self.passwordField.text length] == 0 || [self.passwordField.text isEqualToString: @""]) {
        [UIAlertView showWithTitle: @"No password"
                message: @"Please fill out a password."
                cancelButtonTitle: @"OK"
                otherButtonTitles: @[]
                tapBlock: nil];
    } else {

        [_model.apiModel userExists: self.usernameField.text completion: ^(BOOL exists) {
            if (exists) {
                [_model.apiModel login: self.usernameField.text
                        password: self.passwordField.text
                        completion: ^{
                            UINavigationController *navigationController = self.parentViewController.navigationController;
                            [navigationController setViewControllers: @[self.mainController] animated: YES];
                        }
                        failure: ^{
                            [UIAlertView showWithTitle: @"Login Error"
                                    message: @"There was an error."
                                    cancelButtonTitle: @"OK"
                                    otherButtonTitles: @[]
                                    tapBlock: ^(UIAlertView *alertView, NSInteger buttonIndex) {
                                        //                            if (buttonIndex == [alertView cancelButtonIndex]) {
                                        //                                NSLog(@"Cancelled");
                                        //                            } else if ([[alertView buttonTitleAtIndex: buttonIndex] isEqualToString: @"Beer"]) {
                                        //                                NSLog(@"Have a cold beer");
                                        //                            } else if ([[alertView buttonTitleAtIndex: buttonIndex] isEqualToString: @"Wine"]) {
                                        //                                NSLog(@"Have a glass of chardonnay");
                                        //                            }
                                    }];
                        }];
            } else {
                [UIAlertView showWithTitle: @"User doesn't exist"
                        message: @"No user exists with this username."
                        cancelButtonTitle: @"OK"
                        otherButtonTitles: @[]
                        tapBlock: nil];

            }
        }];


        //
        //        [_model.authClient authenticateUsingOAuthWithURLString: @"http://188.226.201.79/api/oauth/token"
        //                username: self.usernameField.text
        //                password: self.passwordField.text
        //                scope: @"email"
        //                success: ^(AFOAuthCredential *credential) {
        //                    NSLog(@"I have a token! %@", credential.accessToken);
        //                    [AFOAuthCredential storeCredential: credential withIdentifier: _model.authClient.serviceProviderIdentifier];
        //                    [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
        //                }
        //                failure: ^(NSError *error) {
        //                    NSLog(@"Error: %@", error);
        //
        //                    [UIAlertView showWithTitle: @"Login Error"
        //                            message: @"There was an error."
        //                            cancelButtonTitle: @"OK"
        //                            otherButtonTitles: @[]
        //                            tapBlock: ^(UIAlertView *alertView, NSInteger buttonIndex) {
        //                                //                            if (buttonIndex == [alertView cancelButtonIndex]) {
        //                                //                                NSLog(@"Cancelled");
        //                                //                            } else if ([[alertView buttonTitleAtIndex: buttonIndex] isEqualToString: @"Beer"]) {
        //                                //                                NSLog(@"Have a cold beer");
        //                                //                            } else if ([[alertView buttonTitleAtIndex: buttonIndex] isEqualToString: @"Wine"]) {
        //                                //                                NSLog(@"Have a glass of chardonnay");
        //                                //                            }
        //                            }];
        //
        //                    //
        //                    //                [UIActionSheet showInView: self.view
        //                    //                        withTitle: @"Are you sure you want to delete all the things?"
        //                    //                        cancelButtonTitle: @"Cancel"
        //                    //                        destructiveButtonTitle: @"Delete all the things"
        //                    //                        otherButtonTitles: @[@"Just some of the things", @"Most of the things"]
        //                    //                        tapBlock: ^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        //                    //                            NSLog(@"Chose %@", [actionSheet buttonTitleAtIndex: buttonIndex]);
        //                    //                        }];
        //                }];

    }

    TFLoginOperation *operation = [[TFLoginOperation alloc] initWithSuccess: ^{

        //        __block UIViewController *controller = self.presentingViewController;
        //        __block UINavigationController *navController = (UINavigationController *) ([controller isKindOfClass: [UINavigationController class]] ? controller : nil);
        //
        //        [controller
        //                dismissViewControllerAnimated: YES
        //                                   completion: ^{
        //                                       [self performSegueWithIdentifier: @"MenuSegue2"
        //                                                                 sender: nil];
        //                                       //
        //                                       //                                       if (navController) {
        //                                       //                                           [navController pushViewController: [self.storyboard instantiateViewControllerWithIdentifier: @"MainController"]
        //                                       //                                                                    animated: YES];
        //                                       //                                       }
        //                                   }];

    }];

    operation.failure = ^{

    };

    [_queue addOperation: operation];

}

#pragma mark TLFreeformModalProtocol
- (CGSize) freeformSizeForViewController {
    return CGSizeMake(300, 380);
}


#pragma mark UITableViewDelegate


#pragma mark UITableViewDatasource

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return [table numberOfRowsInSection: section];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    UITableViewCell *ret = [tableView dequeueReusableCellWithIdentifier: @"TableCell"];


    NSDictionary *dictionary = [table dataForIndexPath: indexPath];
    if ([ret isKindOfClass: [FieldTableViewCell class]]) {
        FieldTableViewCell *cell = (FieldTableViewCell *) ret;
        cell.textField.delegate = self;
        cell.textField.placeholder = [table textLabelForIndexPath: indexPath];
        cell.imageView.image = [table imageForIndexPath: indexPath];
        cell.textField.rightView = nil;

        if ([[table textLabelForIndexPath: indexPath] isEqualToString: @"Password"]) {
            cell.textField.secureTextEntry = YES;
        }

    }

    return ret;
}




#pragma mark UITextFieldDelegate



- (BOOL) textFieldShouldBeginEditing: (UITextField *) textField {
    TFCustomTextField *customTextField = (TFCustomTextField *) textField;
    return customTextField.rightView == nil ? YES : customTextField.rightAccessoryButton.selected;
}

- (void) textFieldDidBeginEditing: (UITextField *) textField {

    //    [self.view adjustViewForKeyboard: 20];

}

- (BOOL) textFieldShouldReturn: (UITextField *) textField {

    UITextField *nextTextField = [table nextTableTextField: textField];
    [textField resignFirstResponder];
    if (nextTextField) {
        [nextTextField becomeFirstResponder];
    } else {
        //        [self.view unadjustViewForKeyboard: 20];
    }

    return YES;
}



#pragma mark TextFields

- (UITextField *) usernameField {
    FieldTableViewCell *cell = (FieldTableViewCell *) [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 0]];
    return cell.textField;
}

- (UITextField *) passwordField {
    FieldTableViewCell *cell = (FieldTableViewCell *) [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForRow: 1 inSection: 0]];
    return cell.textField;
}

@end