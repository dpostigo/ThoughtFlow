//
// Created by Dani Postigo on 5/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPAnimators/NavigationFadeAnimator.h>
#import "PreloginContainerController.h"


@interface PreloginContainerController ()

@property(nonatomic, strong) NavigationFadeAnimator *animator;
@end

@implementation PreloginContainerController

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    //    _model.loggedIn = YES;

}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
    [super prepareForSegue: segue sender: sender];

    if ([segue.identifier isEqualToString: @"EmbedSegue"]) {
        UINavigationController *controller = segue.destinationViewController;
        controller.delegate = self.animator;
    }
}


- (NavigationFadeAnimator *) animator {
    if (_animator == nil) {
        _animator = [NavigationFadeAnimator new];
        _animator.opaque = YES;
    }
    return _animator;
}


@end