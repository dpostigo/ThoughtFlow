//
// Created by Dani Postigo on 5/5/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFModalViewController.h"

@implementation TFModalViewController


#pragma mark Dismiss

@synthesize dismisses;
@synthesize dismissRecognizer;

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
        if (![self.view pointInside: [self.view convertPoint: location fromView: self.view.window]
                          withEvent: nil]) {
            if (dismisses) {
                [self.view.window removeGestureRecognizer: sender];
                [self.presentingViewController dismissViewControllerAnimated: YES
                                                                  completion: nil];
            } else {
                [self didTapBehind];

            }

        }
    }

}


- (void) didTapBehind {

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