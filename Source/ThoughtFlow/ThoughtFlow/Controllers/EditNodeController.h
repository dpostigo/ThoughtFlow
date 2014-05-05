//
// Created by Dani Postigo on 5/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"
#import "TFModalViewController.h"

@interface EditNodeController : TFModalViewController <UITextViewDelegate, UITextFieldDelegate> {

    //    IBOutlet UITextField *textField;
}

@property(weak) IBOutlet UITextView *textView;
@property(weak) IBOutlet UILabel *charactersLabel;
@end