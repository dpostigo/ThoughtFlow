//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"
#import "TLFreeformModalProtocol.h"
#import "TFDrawerController.h"

@class TFCustomTextField;

@interface TFAccountDrawerController : TFDrawerController <TLFreeformModalProtocol> {

    IBOutlet TFCustomTextField *usernameField;
    IBOutlet TFCustomTextField *emailField;

    IBOutlet TFCustomTextField *passwordField;

}
@end