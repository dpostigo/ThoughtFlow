//
// Created by Dani Postigo on 5/5/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "NotesDrawerController.h"
#import "UIView+TFFonts.h"
#import "UITextView+TFFonts.h"
#import "Model.h"
#import "Project.h"
#import "UIColor+TFApp.h"

#define PLACEHOLDER @"Add some notes to your project..."

@implementation NotesDrawerController

- (void) viewDidLoad {
    [super viewDidLoad];

    [self.view convertFonts];

    _textView.delegate = self;
    [_textView setFonts];

    if (_model.selectedProject.notes == nil) {
        _textView.text = PLACEHOLDER;
        _textView.textColor = [UIColor darkGrayColor];
    } else {
        _textView.text = _model.selectedProject.notes;
        _textView.textColor = [UIColor tfOffWhiteColor];
    }

}


- (IBAction) handleDoneButton: (id) sender {
    _model.selectedProject.notes = _textView.text;

    [self _notifyDrawerControllerShouldDismiss];

}

//- (void) didTapBehind {
//    [self.view endEditing: YES];
//}

//
//#pragma mark UITextViewDelegate
//
//- (BOOL) textView: (UITextView *) textView shouldChangeTextInRange: (NSRange) range replacementText: (NSString *) text {
//    if ([text isEqualToString: @"\n"]) {
//        [self.view endEditing: YES];
//        return NO;
//    }
//    return YES;
//}





//- (BOOL) textViewShouldBeginEditing: (UITextView *) textView {
//    return NO;
//}

//- (BOOL) textViewShouldEndEditing: (UITextView *) textView {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    return NO;
//}

- (void) textViewDidBeginEditing: (UITextView *) textView {
    if ([textView.text isEqualToString: PLACEHOLDER]) {
        textView.text = @"";
        textView.textColor = [UIColor tfOffWhiteColor];
    }

    [textView becomeFirstResponder];

}

- (void) textViewDidEndEditing: (UITextView *) textView {
    if ([textView.text isEqualToString: @""]) {
        textView.text = PLACEHOLDER;
        textView.textColor = [UIColor darkGrayColor]; //optional
    }
    [textView resignFirstResponder];

}

@end