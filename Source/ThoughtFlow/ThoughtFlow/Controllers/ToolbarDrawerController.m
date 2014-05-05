//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "ToolbarDrawerController.h"
#import "UIView+TFFonts.h"

@implementation ToolbarDrawerController

- (void) viewDidLoad {
    [super viewDidLoad];

    //    [self.view convertFonts];
}


#pragma mark Dismiss

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                 action: @selector(handleTapBehind:)];
    recognizer.numberOfTapsRequired = 1;
    recognizer.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
    [self.view.window addGestureRecognizer: recognizer];
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

- (CGSize) freeformSizeForViewController {
    return CGSizeMake(290, 768);
}

@end