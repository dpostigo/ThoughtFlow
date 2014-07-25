//
// Created by Dani Postigo on 7/22/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "TFPopTransitionController.h"
#import "UIView+DTFoundation.h"


@implementation TFPopTransitionController

- (id) init {
    self = [super init];
    if (self) {
        _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] init];
        [_pinchGestureRecognizer addTarget: self action: @selector(handlePinchGesture:)];
    }
    return self;
}


- (void) dealloc {
    [_pinchGestureRecognizer removeTarget: self action: @selector(handlePinchGesture:)];
}


- (void) handlePinchGesture: (UIPinchGestureRecognizer *) pinchGestureRecognizer {
    CGFloat scale = pinchGestureRecognizer.scale;
    CGFloat velocity = pinchGestureRecognizer.velocity;

    switch (pinchGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.interactive = YES;
            [self.delegate transitionControllerInteractionDidStart: self];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat percentComplete = 1.0 - scale;
            [self updateInteractiveTransition: percentComplete];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGFloat scaleInOneTenthSecond = scale + 0.1 * velocity;
            if (scaleInOneTenthSecond <= 0.5) {
                [self finishInteractiveTransition];
            }
            else {
                [self cancelInteractiveTransition];
            }
            self.interactive = NO;
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            [self cancelInteractiveTransition];
            self.interactive = NO;
            break;
        }
        default:
            break;
    }
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval) transitionDuration: (id <UIViewControllerContextTransitioning>) transitionContext {
    return 0.5;
}


- (UIImage *) _makeImage: (UIViewController *) viewController {

    UIImage *image = [viewController.view snapshotImage];
    CIContext *context = [CIContext contextWithOptions: nil];

    CIImage *inputImage = [[CIImage alloc] initWithImage: image];

    CIFilter *filter = [CIFilter filterWithName: @"CIGaussianBlur"];

    [filter setValue: inputImage forKey: kCIInputImageKey];

    [filter setValue: [NSNumber numberWithFloat: 2.0f] forKey: @"inputRadius"];

    CIImage *result = [filter valueForKey: kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage: result fromRect: [result extent]];
    return [UIImage imageWithCGImage: cgImage];

}

- (void) animateTransition: (id <UIViewControllerContextTransitioning>) transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    toViewController.view.frame = [transitionContext finalFrameForViewController: toViewController];
    [toViewController.view layoutIfNeeded];

    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview: toViewController.view atIndex: 0];

    UIViewController *fromViewController = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];

    //    toViewController.view.alpha = 0;


    CGAffineTransform transform = CGAffineTransformMakeTranslation(containerView.width, containerView.height);


    NSTimeInterval duration = [self transitionDuration: transitionContext];
    [UIView animateWithDuration: duration delay: 0.0 options: UIViewAnimationOptionCurveLinear animations: ^{

        fromViewController.view.transform = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(0, 0));


        //        fromViewController.view.alpha = 0.0;
        //        toViewController.view.alpha = 1;
        //        fromViewController.view.right = containerView.width;
        //        fromViewController.view.bottom = containerView.height;

    } completion: ^(BOOL finished) {
        BOOL completed = ![transitionContext transitionWasCancelled];
        if (completed) {
            [fromViewController.view removeFromSuperview];
        }
        else {
            [toViewController.view removeFromSuperview];
        }
        [transitionContext completeTransition: completed];
    }];
}
@end