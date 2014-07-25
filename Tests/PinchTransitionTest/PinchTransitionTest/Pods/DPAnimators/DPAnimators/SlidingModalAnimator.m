//
// Created by Dani Postigo on 5/17/14.
//

#import <DPKit-UIView/UIView+DPConstraints.h>
#import <DPKit-Utils/UIView+DPKit.h>
#import "SlidingModalAnimator.h"
#import "UIView+DPKitDebug.h"


@implementation SlidingModalAnimator

@synthesize modalPresentationSize;


//const CGFloat PresentedViewHeightPortrait = 720.0f;
//const CGFloat PresentedViewHeightLandscape = 440.0f;

- (void) animateWithContext: (id <UIViewControllerContextTransitioning>) transitionContext {
    [self determineDefaults];

    if (isPresenting) {
        [self presentWithContext: transitionContext];
    } else {
        [self dismissWithContext: transitionContext];
    }
}

- (void) presentWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super presentWithContext: context];

    UIView *containerView = context.containerView;
    UIViewController *toController = [self toViewController: context];
    UIViewController *fromController = [self fromViewController: context];


    UIView *toView = toController.view;
    UIView *fromView = fromController.view;
    [containerView addSubview: fromView];
    [containerView addSubview: toView];




//    toView.width = viewSize.width;
//    toView.height = viewSize.height;
//    toView.top = containerView.height;
//
////    toView.frame = [self rectForDismissedState: context];
//
//
//    [UIView animateWithDuration: self.transitionDuration
//                          delay: 0.0
//                        options: UIViewAnimationOptionCurveEaseOut
//                     animations: ^{
////                         toView.frame = [self rectForPresentedState: context];
//                         toView.top = containerView.height - toView.height;
//                     }
//                     completion: ^(BOOL finished) {
//                         [context completeTransition: YES];
//                     }];
//

}

- (void) dismissWithContext: (id <UIViewControllerContextTransitioning>) context {
    UIView *containerView = context.containerView;
    UIViewController *fromController = [self fromViewController: context];
    UIViewController *toController = [self toViewController: context];


    UIView *toView = toController.view;
    UIView *fromView = fromController.view;

    [UIView animateWithDuration: self.transitionDuration
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         toView.top = containerView.height;
                     }
                     completion: ^(BOOL finished) {
                         [toView removeFromSuperview];
                         [context completeTransition: YES];
                     }];

}


#pragma mark Defaults

- (void) determineDefaults {

    if (CGSizeEqualToSize(modalPresentationSize, CGSizeZero)) {
        modalPresentationSize = CGSizeMake(320, 300);
    }

}

@end