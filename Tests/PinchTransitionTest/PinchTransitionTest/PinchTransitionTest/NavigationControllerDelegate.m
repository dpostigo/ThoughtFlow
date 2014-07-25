//
// Created by Dani Postigo on 7/22/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "NavigationControllerDelegate.h"
#import "AnimationController.h"
#import "InteractionController.h"


@interface NavigationControllerDelegate ()

@property(nonatomic, strong) AnimationController *animationController;
@property(nonatomic, strong) InteractionController *interactionController;
@end

@implementation NavigationControllerDelegate

- (id) init {
    self = [super init];
    if (self) {

        _animationController = [AnimationController new];
        _interactionController = [InteractionController new];

    }

    return self;
}






#pragma mark - UINavigationControllerDelegate

- (void) navigationController: (UINavigationController *) navigationController didShowViewController: (UIViewController *) viewController animated: (BOOL) animated {

    NSLog(@"%s", __PRETTY_FUNCTION__);
    [viewController.view addGestureRecognizer: _interactionController.pinchRecognizer];

}


- (id <UIViewControllerAnimatedTransitioning>) navigationController: (UINavigationController *) navigationController animationControllerForOperation: (UINavigationControllerOperation) operation fromViewController: (UIViewController *) fromVC toViewController: (UIViewController *) toVC {
    _animationController.isPresenting = operation == UINavigationControllerOperationPush;

    return _animationController;
}

- (id <UIViewControllerInteractiveTransitioning>) navigationController: (UINavigationController *) navigationController interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>) animationController {
    return _interactionController.interactionInProgress ? _interactionController : nil;
}

@end