//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"


@class TFCharacterCountTextField;

@interface CreateProjectController : TFViewController <UITextFieldDelegate, UINavigationControllerDelegate> {

}

@property(weak) IBOutlet TFCharacterCountTextField *textField;
@end