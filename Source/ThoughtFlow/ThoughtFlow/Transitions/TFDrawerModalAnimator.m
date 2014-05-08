//
// Created by Dani Postigo on 5/3/14.
//

#import "TFDrawerModalAnimator.h"
#import "UIView+DPKit.h"
#import "UIApplication+DPKit.h"

@implementation TFDrawerModalAnimator {
    UIView *destinationView;
}

@synthesize debug;
@synthesize presenting;

@synthesize modalSize;
@synthesize sourceModalOrigin;
@synthesize destinationModalOrigin;

@synthesize sourceController;

@synthesize duration;

- (id) init {
    self = [super init];
    if (self) {
        duration = 0.5;
    }

    return self;
}

- (NSTimeInterval) transitionDuration: (id <UIViewControllerContextTransitioning>) transitionContext {
    return self.duration;
}

- (void) animateTransition: (id <UIViewControllerContextTransitioning>) transitionContext {

    UIViewController *fromViewController = self.presenting ? [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey] : [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    UIViewController *toViewController = self.presenting ? [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey] : [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];


    UIView *containerView = transitionContext.containerView;

    UIView *clippingView = [[UIView alloc] initWithFrame: containerView.bounds];
    clippingView.height -= 60;
    clippingView.clipsToBounds = YES;

    UIView *sourceView = sourceController.view;
    destinationView = toViewController.view;

    if (debug) {

        //        UIView *fromView = fromViewController.view;
        //
        //        NSLog(@"fromView = %@", fromView);
        //
        //        NSLog(@"sourceView = %@", sourceView);
        //        NSLog(@"sourceView.superview = %@", sourceView.superview);
        //        NSLog(@"sourceView.superview.superview = %@", sourceView.superview.superview);
        //
        //        NSLog(@"containerView = %@", containerView);
        //        NSLog(@"containerView.superview = %@", containerView.superview);

    }
    __block CGFloat sourceX = 0, destinationX = 0;
    __block CGFloat sourceY = 0, destinationY = 0;
    __block CGRect sourceFrame = CGRectZero, destinationFrame = CGRectZero;
    __block CGFloat w, h;

    w = modalSize.width > 0 ? modalSize.width : 400;
    h = modalSize.height > 0 ? modalSize.height : 400;
    w = self.isLandscape ? modalSize.height : modalSize.width;
    h = self.isLandscape ? modalSize.width : modalSize.height;

    sourceX = self.isLandscape ? sourceModalOrigin.y : sourceModalOrigin.x;
    sourceY = self.isLandscape ? sourceModalOrigin.x : sourceModalOrigin.y;

    destinationX = self.isLandscape ? destinationModalOrigin.y : destinationModalOrigin.x;
    destinationY = self.isLandscape ? destinationModalOrigin.x : destinationModalOrigin.y;

    sourceFrame = CGRectMake(sourceX, sourceY, w, h);
    destinationFrame = CGRectMake(destinationX, destinationY, w, h);

    w = 100;
    CGFloat containerViewWidth = self.isLandscape ? containerView.height : containerView.width;
    CGFloat containerViewHeight = self.isLandscape ? containerView.width : containerView.height;

    destinationFrame.origin.x = 0;

    sourceFrame.origin.y = containerViewWidth - w - sourceModalOrigin.x;
    //        sourceFrame.size.width = 290;
    //        sourceFrame.size.height = self.isLandscape ? modalSize.width : modalSize.height;

    w = self.isLandscape ? modalSize.height : modalSize.width;
    h = self.isLandscape ? modalSize.width : modalSize.height;

    destinationFrame.origin.y = containerView.height - modalSize.width - destinationModalOrigin.x;

    if (self.presenting) {

        destinationView.frame = sourceFrame;
        //        destinationView.frame = destinationFrame;

        [containerView addSubview: fromViewController.view];
        [containerView addSubview: clippingView];
        [clippingView addSubview: toViewController.view];
        //        [containerView addSubview: sourceController.view];
        //        [sourceController.view.superview bringSubviewToFront: sourceController.view];

        [UIView animateWithDuration: [self transitionDuration: transitionContext]
                         animations: ^{
                             destinationView.frame = destinationFrame;

                         }
                         completion: ^(BOOL finished) {
                             [transitionContext completeTransition: YES];
                         }];

    } else {

        [transitionContext.containerView addSubview: fromViewController.view];
        [transitionContext.containerView addSubview: clippingView];
        [clippingView addSubview: toViewController.view];

        [UIView animateWithDuration: [self transitionDuration: transitionContext] delay: 0.0f
                            options: UIViewAnimationOptionCurveEaseOut
                         animations: ^{
                             //                             fromViewController.view.alpha = 0;
                             destinationView.alpha = 0;
                             //                             destinationView.top += destinationView.width;
                             destinationView.frame = sourceFrame;

                             //                             destinationView.frame = sourceFrame;


                         }
                         completion: ^(BOOL finished) {
                             [transitionContext completeTransition: YES];
                         }];
    }
}


- (UIInterfaceOrientation) statusOrientation {
    return [[UIApplication sharedApplication] statusBarOrientation];
}

- (BOOL) isLandscape {
    return UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
}


- (void) animationEnded: (BOOL) transitionCompleted {

}


@end