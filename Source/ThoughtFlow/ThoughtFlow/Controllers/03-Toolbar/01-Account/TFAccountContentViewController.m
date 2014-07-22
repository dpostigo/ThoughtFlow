//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import <UIAlertView+Blocks/UIAlertView+Blocks.h>
#import "TFAccountContentViewController.h"
#import "TFTextField.h"
#import "APIModel.h"
#import "APIUser.h"
#import "TFBarButtonItem.h"
#import "TFNewTextField.h"
#import "UIViewController+DPKit.h"
#import "NSString+CJStringValidator.h"


@interface TFAccountContentViewController ()

@property(nonatomic, strong) UITapGestureRecognizer *recognizer;
@end

@implementation TFAccountContentViewController {
    UITapGestureRecognizer *_recognizer;
}

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    return [self viewControllerFromStoryboard: @"Drawers"];
}


#pragma mark - View lifecycle

- (void) _setupTextField: (TFNewTextField *) textField {
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    textField.imageInsets = UIEdgeInsetsMake(0, 8, 0, 15);
    [textField setTextColor: [UIColor lightGrayColor] forState: UIControlStateNormal];
    [textField setTextColor: [UIColor whiteColor] forState: UIControlStateSelected];

}

- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setupTextField: _usernameField];
    [self _setupTextField: _emailField];
    [self _setupTextField: _passwordField];

    _usernameField.editable = NO;
    _usernameField.image = [UIImage imageNamed: @"user-icon"];
    _usernameField.text = [APIModel sharedModel].currentUser.username;

    _emailField.image = [UIImage imageNamed: @"email-icon"];
    _emailField.text = [APIModel sharedModel].currentUser.email;

    _passwordField.image = [UIImage imageNamed: @"password-icon"];
    _passwordField.text = [APIModel sharedModel].currentUser.password;

    [self _setupOld];

    [self _setupSignOutButton];
}


- (void) _setupSignOutButton {
    CGFloat padding = 10;
    UIImage *image = [_signOutButton imageForState: UIControlStateNormal];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString: @"SIGN OUT" attributes: [TFBarButtonItem defaultAttributes]];


    CGSize size = string.size;

    [_signOutButton setAttributedTitle: string forState: UIControlStateNormal];
    [_signOutButton sizeToFit];
    [_signOutButton setTitleEdgeInsets: UIEdgeInsetsMake(0, -image.size.width, 0, 0)];
    [_signOutButton setImageEdgeInsets: UIEdgeInsetsMake(0, (size.width + padding), 0, 0)];

}


- (void) _setupOld {
    emailFieldOld.text = [APIModel sharedModel].currentUser.email;
    passwordFieldOld.text = [APIModel sharedModel].currentUser.password;
    usernameFieldOld.text = [APIModel sharedModel].currentUser.username;

    emailFieldOld.leftAccessoryImageView.image = [UIImage imageNamed: @"email-icon"];
    usernameFieldOld.leftAccessoryImageView.image = [UIImage imageNamed: @"user-icon"];
    passwordFieldOld.leftAccessoryImageView.image = [UIImage imageNamed: @"password-icon"];

}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    [self _setupRecognizer];
}

#pragma mark - Setup

- (void) _setupRecognizer {

    __weak TFAccountContentViewController *weakSelf = self;
    _recognizer = [self addTapBehindRecognizerWithBlock: ^() {

        __strong TFAccountContentViewController *strongSelf = weakSelf;
        if (strongSelf) {
            if (strongSelf.currentTextField) {
                [strongSelf.currentTextField resignFirstResponder];
            }
        }
    }];
}
#pragma mark - Actions

- (IBAction) handleSignOutButton: (UIButton *) button {

}



#pragma mark - UITextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField {
    _currentTextField = textField;
}




#pragma mark - TFNewTextFieldDelegate

- (void) textFieldDidSave: (TFNewTextField *) textField {

    void (^failureBlock)(NSString *message) = ^(NSString *message) {
        [UIAlertView showWithTitle: @"Oops"
                message: message
                cancelButtonTitle: @"OK"
                otherButtonTitles: nil
                tapBlock: nil];
    };

    if (textField == _emailField) {
        NSString *email = _emailField.text;

        if ([email isEmail]) {
            [[APIModel sharedModel] updateCurrentUserWithEmail: _emailField.text
                    success: nil
                    failure: failureBlock];
        } else {
            [UIAlertView showWithTitle: @"Oops"
                    message: @"Please enter a valid email."
                    cancelButtonTitle: @"OK"
                    otherButtonTitles: nil
                    tapBlock: nil];
        }

    }

    else if (textField == _passwordField) {
        [[APIModel sharedModel] updateCurrentUserWithPassword: _passwordField.text
                success: nil
                failure: failureBlock];
    }

}

@end