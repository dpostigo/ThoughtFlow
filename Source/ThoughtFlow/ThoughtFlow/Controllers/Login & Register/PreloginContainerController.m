//
// Created by Dani Postigo on 5/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPAnimators/NavigationFadeAnimator.h>
#import "PreloginContainerController.h"
#import "Model.h"

@implementation PreloginContainerController

@synthesize animator;

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    //    _model.loggedIn = YES;

}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
    [super prepareForSegue: segue sender: sender];

    if ([segue.identifier isEqualToString: @"EmbedSegue"]) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        UINavigationController *controller = segue.destinationViewController;
        controller.delegate = self.animator;

    }
}


- (NavigationFadeAnimator *) animator {
    if (animator == nil) {
        animator = [NavigationFadeAnimator new];
    }
    return animator;
}


@end