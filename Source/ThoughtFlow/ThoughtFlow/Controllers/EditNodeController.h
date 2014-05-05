//
// Created by Dani Postigo on 5/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"

@interface EditNodeController : TFViewController <UITextViewDelegate, UITextFieldDelegate> {

    //    IBOutlet UITextField *textField;
    UITapGestureRecognizer *dismissRecognizer;
}

@property(weak) IBOutlet UITextView *textView;
@property(weak) IBOutlet UILabel *charactersLabel;
@property(nonatomic, strong) UITapGestureRecognizer *dismissRecognizer;
@end