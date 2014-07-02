//
// Created by Dani Postigo on 5/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"
#import "TFModalViewController.h"

@class TFEditNodeController;

@protocol TFEditNodeControllerDelegate <NSObject>

- (void) editNodeController: (TFEditNodeController *) controller dismissedWithName: (NSString *) name;

@end


@interface TFEditNodeController : TFModalViewController <UITextViewDelegate, UITextFieldDelegate> {
    __unsafe_unretained id <TFEditNodeControllerDelegate> delegate;
    //    IBOutlet UITextField *textField;
}

@property(weak) IBOutlet UIButton *doneButton;
@property(weak) IBOutlet UITextView *textView;
@property(weak) IBOutlet UILabel *charactersLabel;
@property(nonatomic, assign) id <TFEditNodeControllerDelegate> delegate;
@end