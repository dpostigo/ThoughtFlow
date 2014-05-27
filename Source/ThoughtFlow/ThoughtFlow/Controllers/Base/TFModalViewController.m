//
// Created by Dani Postigo on 5/5/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFModalViewController.h"

@implementation TFModalViewController


#pragma mark Dismiss

@synthesize dismisses;
@synthesize dismissRecognizer;

- (void) viewDidLoad {
    [super viewDidLoad];

}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    dismissRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTapBehind:)];
    dismissRecognizer.numberOfTapsRequired = 1;
    dismissRecognizer.cancelsTouchesInView = NO;
    [self.view.window addGestureRecognizer: self.dismissRecognizer];
}


- (void) viewWillDisappear: (BOOL) animated {
    [super viewWillDisappear: animated];

    NSArray *recognizers = self.view.window.gestureRecognizers;
    if ([recognizers containsObject: self.dismissRecognizer]) {
        [self.view.window removeGestureRecognizer: self.dismissRecognizer];
    }
}


- (void) handleTapBehind: (UITapGestureRecognizer *) sender {

    [self userTapBehind: sender];

}


- (void) userTapBehind: (UITapGestureRecognizer *) sender {

    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView: nil];
        if (![self.view pointInside: [self.view convertPoint: location fromView: self.view.window]
                withEvent: nil]) {
            if (dismisses) {
                [self modalWillDismiss];
                [self.view.window removeGestureRecognizer: sender];
                [self dismiss];

            } else {
                [self didTapBehind];
            }

        }
    }
}

- (void) modalWillDismiss {
    NSLog(@"%s", __PRETTY_FUNCTION__);

}

- (void) dismiss {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.presentingViewController dismissViewControllerAnimated: YES
            completion: nil];
}

- (void) didTapBehind {

}



#pragma mark Getters

- (UITapGestureRecognizer *) dismissRecognizer {
    if (dismissRecognizer == nil) {
        dismissRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTapBehind:)];
        dismissRecognizer.numberOfTapsRequired = 1;
        dismissRecognizer.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
    }
    return dismissRecognizer;
}

@end