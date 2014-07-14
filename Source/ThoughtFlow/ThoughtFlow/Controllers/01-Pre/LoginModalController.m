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
#import "DPTableView+DataUtils.h"
#import "TFTextField.h"
#import "UIView+TFFonts.h"
#import "Model.h"
#import "UIAlertView+Blocks.h"
#import "APIModel.h"
#import "APIUser.h"
#import "UIViewController+TFControllers.h"


@implementation LoginModalController


#pragma mark - View lifecycle

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    if (_model.apiModel.loggedIn) {
        [self submit: nil];
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setup];

}



#pragma mark Actions

- (IBAction) signInInstead: (id) sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction) submit: (UIButton *) button {

    if (self.currentTextField) {
        [self.currentTextField resignFirstResponder];
    }

    if (!USE_API) {
        [self loginDidSucceed];
        return;
    }

    NSString *errorTitle = nil;
    NSString *errorMessage = nil;
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

        button.enabled = NO;

        [_model.apiModel userExists: self.usernameField.text
                completion: ^(BOOL exists) {

                    if (exists) {
                        [_model.apiModel loginUser: self.usernameField.text
                                password: self.passwordField.text
                                completion: ^{
                                    [self loginDidSucceed];
                                }
                                failure: ^{
                                    [UIAlertView showWithTitle: @"Login Error"
                                            message: @"There was an error."
                                            cancelButtonTitle: @"OK"
                                            otherButtonTitles: @[]
                                            tapBlock: nil];

                                    button.enabled = YES;

                                }];
                    } else {
                        [UIAlertView showWithTitle: @"User doesn't exist"
                                message: @"No user exists with this username."
                                cancelButtonTitle: @"OK"
                                otherButtonTitles: @[]
                                tapBlock: nil];

                        button.enabled = YES;

                    }
                }];

    }

}


- (void) loginDidSucceed {
    UINavigationController *navigationController = self.parentViewController.navigationController;
    [navigationController setViewControllers: @[self.mainController] animated: YES];

}


#pragma mark - Setup

- (void) _setup {
    [self _setupView];
    [self _setupTableView];
    [self _setupTapRecognizer];
}

- (void) _setupView {
    [self.view convertFonts];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void) _setupTableView {
    _table.delegate = self;
    _table.dataSource = self;
    _table.populateTextLabels = YES;

    [self prepareDatasource];

    __weak LoginModalController *weakSelf = self;
    _table.onReload = ^(DPTableView *theTable) {
        __strong LoginModalController *strongSelf = weakSelf;
        if (strongSelf) {
            CGFloat newheight = theTable.calculatedTableHeight;
            theTable.height = newheight;
            [theTable updateHeightConstraint: newheight];
            [strongSelf.view setNeedsUpdateConstraints];

            if (strongSelf.model.apiModel.loggedIn) {
                strongSelf.usernameField.text = strongSelf.model.apiModel.currentUser.username;
                strongSelf.passwordField.text = strongSelf.model.apiModel.currentUser.password;
            }
        }

    };

    [_table reloadData];
    _table.layer.cornerRadius = 3;

}

- (void) prepareDatasource {
    [_table.rows addObject: @{DPTableViewTextLabelName : @"Username or email", DPTableViewImageName : [UIImage imageNamed: @"user-icon"]}];
    [_table.rows addObject: @{DPTableViewTextLabelName : @"Password", DPTableViewImageName : [UIImage imageNamed: @"password-icon"]}];
}


#pragma mark - Delegates
#pragma mark - UITableViewDelegate

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return [_table numberOfRowsInSection: section];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    UITableViewCell *ret = [tableView dequeueReusableCellWithIdentifier: @"TableCell"];


    NSDictionary *dictionary = [_table rowDataForIndexPath: indexPath];
    if ([ret isKindOfClass: [FieldTableViewCell class]]) {
        FieldTableViewCell *cell = (FieldTableViewCell *) ret;
        cell.textField.delegate = self;
        cell.textField.placeholder = [_table textLabelForIndexPath: indexPath];
        cell.imageView.image = [_table imageForIndexPath: indexPath];
        cell.textField.rightView = nil;
        cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;

        if ([[_table textLabelForIndexPath: indexPath] isEqualToString: @"Password"]) {
            cell.textField.secureTextEntry = YES;
        }

    }

    return ret;
}




#pragma mark UITextFieldDelegate



- (BOOL) textFieldShouldBeginEditing: (UITextField *) textField {
    TFTextField *customTextField = (TFTextField *) textField;
    return customTextField.rightView == nil ? YES : customTextField.rightAccessoryButton.selected;
}

- (void) textFieldDidBeginEditing: (UITextField *) textField {
    _currentTextField = textField;
    //    [self.view adjustViewForKeyboard: 20];

}

- (BOOL) textFieldShouldReturn: (UITextField *) textField {

    UITextField *nextTextField = [_table nextTableTextField: textField];
    [textField resignFirstResponder];
    if (nextTextField) {
        [nextTextField becomeFirstResponder];
    } else {
        [self submit: nil];
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


- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    [super touchesBegan: touches withEvent: event];
    [self.currentTextField resignFirstResponder];
}



#pragma mark - Private


- (void) _setupTapRecognizer {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTap:)];
    recognizer.numberOfTapsRequired = 1;
    recognizer.cancelsTouchesInView = NO;
    [self.view.window addGestureRecognizer: recognizer];
}


- (void) handleTap: (UITapGestureRecognizer *) sender {

    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView: nil];
        if (![self.view pointInside: [self.view convertPoint: location fromView: self.view.window]
                withEvent: nil]) {
            [self.currentTextField resignFirstResponder];
            //            if (dismisses) {
            //                [self modalWillDismiss];
            //                [self.view.window removeGestureRecognizer: sender];
            //                [self dismiss];
            //
            //            } else {
            ////                [self didTapBehind];
            //            }

        }
    }
}

@end