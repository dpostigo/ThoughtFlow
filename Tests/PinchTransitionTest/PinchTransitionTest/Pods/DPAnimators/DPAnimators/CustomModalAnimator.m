//
// Created by Dani Postigo on 5/7/14.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "CustomModalAnimator.h"

CGFloat const TestAnimatorDefaultWidth = 300;
CGFloat const TestAnimatorDefaultHeight = 300;

@implementation CustomModalAnimator

@synthesize modalPresentationSize;

- (NSTimeInterval) transitionDuration: (id <UIViewControllerContextTransitioning>) transitionContext {
    return 0.4;
}

- (void) animateTransition: (id <UIViewControllerContextTransitioning>) transitionContext {
    if (self.isPresenting) [self positionForContext: transitionContext];
    [self animateForContext: transitionContext];
}


- (void) animateForContext: (id <UIViewControllerContextTransitioning>) transitionContext {
    NSTimeInterval duration = [self transitionDuration: transitionContext];
    UIViewController *destinationController = self.isPresenting ? [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey] : [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UIView *sourceView = self.isPresenting ? [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey].view : [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey].view;
    UIView *controllerView = destinationController.view;
    UIView *containerView = transitionContext.containerView;

    void (^animations)() = nil;

    if (self.isPresenting) {

        controllerView.alpha = 0;
        [containerView addSubview: controllerView];
        animations = ^{
            controllerView.alpha = 1;
            sourceView.alpha = 0;
        };

    } else {

        controllerView.alpha = 1;
        [containerView addSubview: sourceView];
        [containerView addSubview: controllerView];
        animations = ^{
            controllerView.alpha = 0;
            sourceView.alpha = 1.0;
        };
    }

    [UIView animateWithDuration: duration
            delay: 0.0
            options: UIViewAnimationOptionCurveEaseOut
            animations: animations
            completion: ^(BOOL finished) {
                [transitionContext completeTransition: YES];
            }];

}




- (void) animatePresentForContext: (id <UIViewControllerContextTransitioning>) transitionContext {
    NSTimeInterval duration = [self transitionDuration: transitionContext];
    UIView *containerView = transitionContext.containerView;
    UIViewController *destinationController = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    UIView *controllerView = destinationController.view;


    void (^animations)() = nil;

    switch (destinationController.modalTransitionStyle) {
        case UIModalTransitionStyleCoverVertical : {

        }
            break;

        case UIModalTransitionStyleCrossDissolve : {
            controllerView.alpha = 0;
            [containerView addSubview: controllerView];
            animations = ^{
                controllerView.alpha = 1;
            };
        }
            break;

        default :
            break;

    }

    [UIView animateWithDuration: duration
            delay: 1.0
            options: UIViewAnimationOptionCurveEaseOut
            animations: animations
            completion: ^(BOOL finished) {
                [transitionContext completeTransition: YES];
            }];
}


- (void) animateDismissForContext: (id <UIViewControllerContextTransitioning>) transitionContext {

}


#pragma mark Position

- (void) positionForContext: (id <UIViewControllerContextTransitioning>) transitionContext {
    CGFloat x, y, width, height;
    CGRect sourceFrame = [self getSourceFrame: [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey]];

    width = modalPresentationSize.width == 0 ? TestAnimatorDefaultWidth : modalPresentationSize.width;
    height = modalPresentationSize.height == 0 ? TestAnimatorDefaultHeight : modalPresentationSize.height;
    x = (sourceFrame.size.width - width) / 2;
    y = (sourceFrame.size.height - height) / 2;

    UIView *controllerView = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey].view;
    controllerView.width = self.isLandscape ? height : width;
    controllerView.height = self.isLandscape ? width : height;
    controllerView.left = self.isLandscape ? y : x;
    controllerView.top = self.isLandscape ? x : y;

}

- (void) testOther {

    //    void (^animations)() = nil;
    //    switch (destinationController.modalTransitionStyle) {
    //        case UIModalTransitionStyleCoverVertical : {
    //
    //        }
    //            break;
    //
    //        case UIModalTransitionStyleCrossDissolve : {
    //            //            ret = @"UIModalTransitionStyleCrossDissolve";
    //            controllerView.alpha = 0;
    //
    //            animations = ^{
    //                controllerView.alpha = 1;
    //            };
    //        }
    //
    //            break;
    //
    //        case UIModalTransitionStyleFlipHorizontal : {
    //
    //        }
    //            break;
    //
    //        case UIModalTransitionStylePartialCurl : {
    //
    //        }
    //            break;
    //    }
    //
    //    [UIView animateWithDuration: transitionDuration
    //                          delay: 1.0
    //                        options: UIViewAnimationOptionCurveEaseOut
    //                     animations: animations
    //                     completion: ^(BOOL finished) {
    //                         [transitionContext completeTransition: YES];
    //                     }];

}
#pragma mark Utils


- (CGRect) getSourceFrame: (UIViewController *) sourceViewController {
    CGRect ret = sourceViewController.view.frame;
    if (self.isLandscape && ret.size.width < ret.size.height) {
        ret.size = CGSizeMake(ret.size.height, ret.size.width);
    }
    return ret;
}

- (BOOL) isLandscape {
    return UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
}

#pragma mark UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController: (UIViewController *) presented presentingController: (UIViewController *) presenting sourceController: (UIViewController *) source {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.isPresenting = YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController: (UIViewController *) dismissed {
    self.isPresenting = NO;
    return self;
}


@end