//
// Created by Dani Postigo on 5/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFDrawerController.h"
#import "TFDrawerPresenter.h"

@implementation TFDrawerController

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [self.view.superview addGestureRecognizer: recognizer];
}

- (void) handleTap: (UITapGestureRecognizer *) recognizer {
    [self closeDrawer: nil];
}


- (IBAction) closeDrawer: (id) sender {
    NSLog(@"self.navigationController = %@", self.navigationController);
    NSLog(@"self.parentViewController = %@", self.parentViewController);
    NSLog(@"self.presentingViewController = %@", self.presentingViewController);
    NSLog(@"%s", __PRETTY_FUNCTION__);

    if (self.presentingViewController) {
        NSLog(@"self.presentingViewController = %@", self.presentingViewController);
        [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
    }

    else if (self.parentViewController) {
        if ([self.parentViewController conformsToProtocol: @protocol(TFDrawerPresenter)]) {
            id <TFDrawerPresenter> presenter = (id <TFDrawerPresenter>) self.parentViewController;
            [presenter dismissDrawerController: self];
        } else {
            NSLog(@"Does not conform.");

        }
    } else if (self.navigationController) {

        NSLog(@"self.navigationController = %@", self.navigationController);
        [self.navigationController popViewControllerAnimated: YES];
    }

}

@end