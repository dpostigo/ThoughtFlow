//
// Created by Dani Postigo on 6/29/14.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import <BlocksKit/NSArray+BlocksKit.h>
#import "NavigationSlideAnimator.h"


@implementation NavigationSlideAnimator

- (void) presentWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super presentWithContext: context];


    // the containerView is the superview during the animation process.
    UIView *containerView = context.containerView;
    UIView *sourceView = [self fromViewController: context].view;
    UIView *destinationView = [self toViewController: context].view;

    [self removeSnapshots: containerView];

    UIViewController *sourceController = [self fromViewController: context];
    UIViewController *destinationController = [self toViewController: context];

    CGFloat containerWidth = containerView.frame.size.width;


    CGRect toInitialFrame = [containerView frame];
    CGRect fromDestinationFrame = sourceView.frame;

    if (CGRectEqualToRect(fromDestinationFrame, CGRectZero)) {
        NSLog(@"oops.");
        sourceView.frame = containerView.frame;
        fromDestinationFrame = sourceView.frame;

    }

    toInitialFrame.origin.x = containerWidth;
    destinationView.frame = toInitialFrame;
    fromDestinationFrame.origin.x = -containerWidth;
    [containerView addSubview: destinationView];

    [UIView animateWithDuration: 0.5
            delay: 0
            usingSpringWithDamping: 1.0
            initialSpringVelocity: 1.0
            options: UIViewAnimationOptionTransitionNone
            animations: ^{
                destinationView.frame = containerView.frame;
                sourceView.frame = fromDestinationFrame;

            }
            completion: ^(BOOL finished) {

                destinationView.frame = containerView.frame;
                [sourceView removeFromSuperview];
                //                    [move removeFromSuperview];
                [context completeTransition: YES];
            }];

}

- (void) dismissWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super dismissWithContext: context];

    UIView *containerView = context.containerView;
    UIView *sourceView = [self fromViewController: context].view;
    UIView *destinationView = [self toViewController: context].view;

    containerView.backgroundColor = [UIColor clearColor];
    [containerView addSubview: sourceView];
    [containerView addSubview: destinationView];

    [UIView animateWithDuration: [self transitionDuration: context]
            animations: ^{
                destinationView.alpha = 0;
                destinationView.left = 0;
            }
            completion: ^(BOOL finished) {
                [destinationView removeFromSuperview];
                destinationView.alpha = 1;
                [context completeTransition: YES];

            }];
}


- (void) removeSnapshots: (UIView *) containerView {
    NSArray *subviews = containerView.subviews;
    NSArray *snapshots = [subviews bk_select: ^(id obj) {
        NSString *classString = NSStringFromClass([obj class]);
        return [classString isEqualToString: @"_UIReplicantView"];
    }];

    [snapshots bk_each: ^(id obj) {
        [obj removeFromSuperview];
    }];
}
@end