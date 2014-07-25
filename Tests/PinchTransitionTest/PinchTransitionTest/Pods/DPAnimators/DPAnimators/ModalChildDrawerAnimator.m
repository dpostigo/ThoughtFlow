//
// Created by Dani Postigo on 5/26/14.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import <DPKit-UIView/UIView+DPConstraints.h>
#import "ModalChildDrawerAnimator.h"
#import "NSObject+InterfaceUtils.h"

@implementation ModalChildDrawerAnimator

@synthesize presentationEdge;
@synthesize presentationOffset;
@synthesize modalPresentationSize;

- (void) presentWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super presentWithContext: context];

    UIView *containerView = context.containerView;
    UIViewController *toController = [self toViewController: context];
    UIViewController *fromController = [self fromViewController: context];
    UIView *toView = toController.view;

    UIViewController *containerController = [[UIViewController alloc] init];

    [containerView addSubview: fromController.view];
    [containerView addSubview: containerController.view];

    toView.left -= toView.width;
    [UIView animateWithDuration: [self transitionDuration: context]
            delay: 0
            usingSpringWithDamping: 0.8
            initialSpringVelocity: 5
            options: kNilOptions
            animations: ^{
                toView.left += toView.width;

            }
            completion: ^(BOOL finished) {
                [context completeTransition: YES];
            }];

}

- (UIViewController *) containerControllerForContext: (id <UIViewControllerContextTransitioning>) context {
    UIViewController *containerController = [[UIViewController alloc] init];
    UIViewController *toController = [self toViewController: context];

    UIView *containerView = containerController.view;
    UIView *toView = toController.view;


    CGSize containerSize = CGSizeZero;
    if (self.isLandscape) {
        containerSize = CGSizeMake(fmaxf(containerView.width, containerView.height), fminf(containerView.width, containerView.height));
    } else {
        containerSize = CGSizeMake(fminf(containerView.width, containerView.height), fmaxf(containerView.width, containerView.height));
    }

    CGFloat width = modalPresentationSize.width == 0 ? containerSize.width : modalPresentationSize.width;
    CGFloat height = modalPresentationSize.height == 0 ? containerSize.height : modalPresentationSize.height;

    toView.left = presentationOffset.y;
    toView.top = presentationOffset.x;
    toView.width = width;
    toView.height = height;

    [containerView addSubview: toView];
    [containerController addChildViewController: toController];
    toView.translatesAutoresizingMaskIntoConstraints = NO;

    [toView updateSuperLeadingConstraint: presentationOffset.y];
    [toView updateSuperTopConstraint: presentationOffset.x];
    [toView updateWidthConstraint: width];
    [toView updateHeightConstraint: height];

    [containerView setNeedsUpdateConstraints];

    NSLog(@"toView.frame = %@", NSStringFromCGRect(toView.frame));

    return containerController;

}


- (void) dismissWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super dismissWithContext: context];
}


@end