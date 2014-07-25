//
// Created by Dani Postigo on 5/25/14.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import <DPKit-Utils/UIView+DPKitDebug.h>
#import "NavigationModalAnimator.h"

@implementation NavigationModalAnimator

@synthesize presentationEdge;
@synthesize modalPresentationSize;

- (void) presentWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super presentWithContext: context];

    UIView *containerView = context.containerView;
    UIView *sourceView = [self fromViewController: context].view;
    UIView *destinationView = [self toViewController: context].view;

    containerView.backgroundColor = [UIColor clearColor];

    destinationView.alpha = 0;
    destinationView.size = [self modalSizeForContext: context];
    //    [containerView addSubview: sourceView];
    [containerView addSubview: destinationView];

    //    [containerView addDebugBorder: [UIColor redColor]];

    [UIView animateWithDuration: [self transitionDuration: context] animations: ^{
        destinationView.alpha = 1;

    } completion: ^(BOOL finished) {
        [context completeTransition: YES];
    }];

    //
    //
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
    //    UIView *containerView = context.containerView;
    //    UIView *sourceView = [self fromViewController: context].view;
    //    UIView *destinationView = [self toViewController: context].view;
    //
    //    sourceView.alpha = 0;
    //    containerView.backgroundColor = [UIColor clearColor];
    //    containerView.opaque = NO;
    //    [containerView addSubview: sourceView];
    //    [containerView addSubview: destinationView];
    //
    //    destinationView.backgroundColor = [UIColor blueColor];
    //
    //    destinationView.size = [self correctedModalSizeForContext: context];
    //
    //    [UIView animateWithDuration: [self transitionDuration: context]
    //            animations: ^{
    //
    //            }
    //            completion: ^(BOOL finished) {
    //
    //                [context completeTransition: YES];
    //            }];

}

- (void) dismissWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super dismissWithContext: context];

    NSLog(@"%s", __PRETTY_FUNCTION__);

}


- (CGPoint) endingPointForContext: (id <UIViewControllerContextTransitioning>) context {

    CGPoint ret = CGPointZero;
    UIView *containerView = context.containerView;
    UIView *destinationView = [self toViewController: context].view;

    switch (presentationEdge) {
        case UIRectEdgeLeft :
            ret.x = 0;
            ret.y = 0;

            break;

        case UIRectEdgeRight :
            destinationView.right = containerView.width;
            break;

        case UIRectEdgeTop :

            break;

        case UIRectEdgeBottom :
            break;

        case UIRectEdgeNone  :
        default :
            break;
    }
    return ret;
}

- (CGSize) modalSizeForContext: (id <UIViewControllerContextTransitioning>) context {

    CGSize ret = modalPresentationSize;
    UIView *containerView = context.containerView;
    if (ret.width == 0) {
        ret.width = containerView.width;
    }

    if (ret.height == 0) {
        ret.height = containerView.height;
    }
    return ret;
}


@end