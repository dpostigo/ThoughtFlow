//
// Created by Dani Postigo on 5/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "EditNodeController.h"
#import "UIView+TFFonts.h"
#import "Model.h"
#import "TFNode.h"

@implementation EditNodeController {
}

@synthesize dismissRecognizer;

- (void) loadView {
    [super loadView];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) viewDidLoad {
    [super viewDidLoad];

    NSLog(@"_model.selectedNode = %@", _model.selectedNode);

    _textView.text = _model.selectedNode.title;
    _textView.delegate = self;

    [self.view convertFonts];
    //
    //    [_model addObserver: self forKeyPath: @"selectedNode"
    //                options: NSKeyValueObservingOptionNew context: NULL];
}





#pragma mark IBActions

- (IBAction) handleSave: (id) sender {
    _model.selectedNode.title = _textView.text;
    [self.view removeGestureRecognizer: dismissRecognizer];
    [self.presentingViewController dismissViewControllerAnimated: YES  completion: nil];
}

#pragma mark Dismiss

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    [self.view.window addGestureRecognizer: self.dismissRecognizer];
}


- (void) viewWillDisappear: (BOOL) animated {
    [super viewWillDisappear: animated];
    [self.view.window removeGestureRecognizer: self.dismissRecognizer];
}


- (void) handleTapBehind: (UITapGestureRecognizer *) sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView: nil];
        if (![self.view pointInside: [self.view convertPoint: location fromView: self.view.window] withEvent: nil]) {
            [self.view.window removeGestureRecognizer: sender];
            [self.presentingViewController dismissViewControllerAnimated: YES
                                                              completion: nil];
        }
    }
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





#pragma mark Getters

- (UITapGestureRecognizer *) dismissRecognizer {
    if (dismissRecognizer == nil) {
        dismissRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                    action: @selector(handleTapBehind:)];
        dismissRecognizer.numberOfTapsRequired = 1;
        dismissRecognizer.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view

    }
    return dismissRecognizer;
}


@end