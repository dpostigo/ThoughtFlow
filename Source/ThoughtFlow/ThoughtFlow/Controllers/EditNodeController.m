//
// Created by Dani Postigo on 5/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "EditNodeController.h"
#import "UIView+TFFonts.h"
#import "Model.h"
#import "TFNode.h"

@implementation EditNodeController

- (void) viewDidLoad {
    [super viewDidLoad];

    dismisses = YES;

    _textView.text = _model.selectedNode.title;
    _textView.delegate = self;

    [self.view convertFonts];
    //
    //    [_model addObserver: self forKeyPath: @"selectedNode"
    //                options: NSKeyValueObservingOptionNew context: NULL];
}

- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    self.view.userInteractionEnabled = NO;
}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    [self performSelector: @selector(activateTextView) withObject: nil afterDelay: 0.1];
}

- (void) activateTextView {

    self.view.userInteractionEnabled = YES;
    [_textView becomeFirstResponder];

}

#pragma mark IBActions

- (IBAction) handleSave: (id) sender {
    _model.selectedNode.title = _textView.text;
    [self.view removeGestureRecognizer: dismissRecognizer];
    [self.presentingViewController dismissViewControllerAnimated: YES  completion: nil];
}


#pragma mark UITextView delegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return NO;
}

- (BOOL) textView: (UITextView *) textView shouldChangeTextInRange: (NSRange) range replacementText: (NSString *) text {
    if ([text isEqualToString: @"\n"]) {
        [self.view endEditing: YES];
        return NO;
    }
    return YES;
}


@end