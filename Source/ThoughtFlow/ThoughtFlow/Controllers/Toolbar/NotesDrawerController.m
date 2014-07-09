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

- (instancetype) initWithProject: (Project *) project {
    NotesDrawerController *ret = [[UIStoryboard storyboardWithName: @"Storyboard" bundle: nil] instantiateViewControllerWithIdentifier: @"NotesDrawerController"];
    ret.project = project;
    return ret;
}


- (void) viewDidLoad {
    [super viewDidLoad];

    [self.view convertFonts];

    _textView.delegate = self;
    [_textView setFonts];

    if (_project) {
        if (_project.notes == nil) {
            _textView.text = PLACEHOLDER;
            _textView.textColor = [UIColor darkGrayColor];
        } else {
            _textView.text = _project.notes;
            _textView.textColor = [UIColor tfOffWhiteColor];
        }
    }

}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    _recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTapBehind:)];
    self.recognizer.numberOfTapsRequired = 1;
    self.recognizer.cancelsTouchesInView = NO;
    [self.view.window addGestureRecognizer: self.recognizer];
}


- (void) viewWillDisappear: (BOOL) animated {
    [super viewWillDisappear: animated];
    [self.view.window removeGestureRecognizer: _recognizer];
}


- (IBAction) handleDoneButton: (id) sender {
    _project.notes = _textView.text;
    [self _notifyDrawerControllerShouldDismiss];
}


- (void) handleTapBehind: (UITapGestureRecognizer *) sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView: nil];
        if (![self.view pointInside: [self.view convertPoint: location fromView: self.view.window]
                withEvent: nil]) {

            [_textView resignFirstResponder];

            //            [self _notifyDrawerControllerShouldDismiss];
        }
    }
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