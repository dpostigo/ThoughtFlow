//
// Created by Dani Postigo on 5/3/14.
//

#import "TFDrawerModalAnimator.h"
#import "UIView+DPKit.h"

@implementation TFDrawerModalAnimator

- (id) init {
    self = [super init];
    if (self) {
        transitionDuration = 0.3;
        modalPresentationSize = CGSizeMake(290, 0);
        presentationEdge = UIRectEdgeLeft;
    }

    return self;
}


- (void) presentWithContext: (id <UIViewControllerContextTransitioning>) context {
    [self positionWithContext: context];

    UIView *containerView = context.containerView;
    UIView *destinationView = [self toViewController: context].view;
    CGPoint finalPoint = [self finalPointForContext: context];

    //    [UIView animateWithDuration: [self transitionDuration]
    //            delay: 0
    //            options: UIViewAnimationOptionCurveEaseOut
    //            animations: ^{
    //                destinationView.left = finalPoint.x;
    //                destinationView.top = finalPoint.y;
    //            }
    //            completion: ^(BOOL completion) {
    //                [containerView addSubview: destinationView];
    //                [context completeTransition: YES];
    //            }];

    [UIView animateWithDuration: [self transitionDuration: context]
            delay: 0
            usingSpringWithDamping: 0.8
            initialSpringVelocity: 3
            options: UIViewAnimationOptionTransitionNone
            animations: ^{
                destinationView.left = finalPoint.x;
                destinationView.top = finalPoint.y;
            }
            completion: ^(BOOL finished) {
                [containerView addSubview: destinationView];
                [context completeTransition: YES];
            }];
}


- (void) dismissWithContext: (id <UIViewControllerContextTransitioning>) context {

    UIView *containerView = context.containerView;
    UIView *sourceView = [self fromViewController: context].view;
    UIView *destinationView = [self toViewController: context].view;

    CGPoint startingPoint = [self startingPointForContext: context];

    UIView *clippingView = [self clippingViewForContext: context];
    [containerView addSubview: clippingView];
    [clippingView addSubview: destinationView];

    [UIView animateWithDuration: [self transitionDuration]
            delay: 0
            options: UIViewAnimationOptionCurveEaseOut
            animations: ^{
                destinationView.left = startingPoint.x;
                destinationView.top = startingPoint.y;
            }
            completion: ^(BOOL completion) {
                [destinationView removeFromSuperview];
                [context completeTransition: YES];
            }];

    //    [UIView animateWithDuration: [self transitionDuration: context] + 0.5
    //            delay: 0
    //            usingSpringWithDamping: 1.0
    //            initialSpringVelocity: 5
    //            options: UIViewAnimationOptionCurveEaseOut
    //            animations: ^{
    //
    //                destinationView.left = startingPoint.x;
    //                destinationView.top = startingPoint.y;
    //
    //            }
    //            completion: ^(BOOL finished) {
    //                [destinationView removeFromSuperview];
    //                [context completeTransition: YES];
    //            }];

}

@end