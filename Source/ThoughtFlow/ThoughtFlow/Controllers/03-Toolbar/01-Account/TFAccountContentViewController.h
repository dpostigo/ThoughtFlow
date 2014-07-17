//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"
#import "TFNewDrawerController.h"
#import "TFNewTextField.h"


@class TFTextField;
@class TFNewTextField;

@interface TFAccountContentViewController : TFNewDrawerController <UITextFieldDelegate,
        TFNewTextFieldDelegate> {

    IBOutlet TFTextField *usernameFieldOld;
    IBOutlet TFTextField *emailFieldOld;

    IBOutlet TFTextField *passwordFieldOld;

}

@property(weak) IBOutlet TFNewTextField *emailField;
@property(weak) IBOutlet TFNewTextField *passwordField;
@property(weak) IBOutlet TFNewTextField *usernameField;
@property(weak) IBOutlet UIButton *signOutButton;
@property(nonatomic, strong) UITextField *currentTextField;
@end