//
// Created by Dani Postigo on 5/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFDrawerController.h"
#import "TFDrawerPresenter.h"

@implementation TFDrawerController

@synthesize presenter;

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [self.view.superview addGestureRecognizer: recognizer];
}

- (void) viewWillDisappear: (BOOL) animated {
    [super viewWillDisappear: animated];
    [recognizer.view removeGestureRecognizer: recognizer];
}


- (void) handleTap: (UITapGestureRecognizer *) recognizer {
    [self closeDrawer: nil];
}


- (IBAction) closeDrawer: (id) sender {
    

    if (self.presenter) {
        [self.presenter dismissDrawerController: self];

    } else if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];

    } else if (self.parentViewController) {
        if ([self.parentViewController conformsToProtocol: @protocol(TFDrawerPresenter)]) {
            id <TFDrawerPresenter> aPresenter = (id <TFDrawerPresenter>) self.parentViewController;
            [aPresenter dismissDrawerController: self];
        } else {
            NSLog(@"Does not conform.");
        }

    } else if (self.navigationController) {

        NSLog(@"self.navigationController = %@", self.navigationController);
        [self.navigationController popViewControllerAnimated: YES];
    }

}

@end