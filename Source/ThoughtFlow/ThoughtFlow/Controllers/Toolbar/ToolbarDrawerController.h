//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"
#import "TLFreeformModalProtocol.h"
#import "TFModalViewController.h"

@interface ToolbarDrawerController : TFModalViewController <TLFreeformModalProtocol> {

    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *emailField;


    IBOutlet UITextField *passwordField;

}
@end