//
// Created by Dani Postigo on 5/25/14.
//

#import <DPKit-UIView/UIView+DPConstraints.h>
#import "ModalDrawerAnimator.h"
#import "NSObject+InterfaceUtils.h"
#import "UIApplication+DPKit.h"
#import "BasicAnimator+Utils.h"
#import "UIView+DPKitDebug.h"
#import "UIView+DPKit.h"

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@implementation ModalDrawerAnimator

@synthesize presentationEdge;
@synthesize presentationOffset;
@synthesize modalPresentationSize;

- (void) presentWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super presentWithContext: context];

    [self positionWithContext: context];

    UIView *containerView = context.containerView;
    CGPoint finalPoint = [self finalPointForContext: context];
    UIView *destinationView = [self toViewController: context].view;

    [UIView animateWithDuration: [self transitionDuration: context]
            delay: 0
            usingSpringWithDamping: 1.0
            initialSpringVelocity: 5
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
    [super dismissWithContext: context];

    UIView *containerView = context.containerView;
    UIView *sourceView = [self fromViewController: context].view;
    UIView *destinationView = [self toViewController: context].view;

    CGPoint startingPoint = [self startingPointForContext: context];

    UIView *clippingView = [self clippingViewForContext: context];
    [containerView addSubview: clippingView];
    [clippingView addSubview: destinationView];

    [UIView animateWithDuration: [self transitionDuration: context]
            delay: 0
            usingSpringWithDamping: 1.0
            initialSpringVelocity: 5
            options: UIViewAnimationOptionTransitionNone
            animations: ^{

                destinationView.left = startingPoint.x;
                destinationView.top = startingPoint.y;

            }
            completion: ^(BOOL finished) {
                [destinationView removeFromSuperview];
                [context completeTransition: YES];
            }];

}


- (CGRect) finalFrameForContext: (id <UIViewControllerContextTransitioning>) context {
    CGRect ret = CGRectZero;
    CGSize correctSize = [self correctedModalSizeForContext: context];
    ret.size = correctSize;
    ret.origin = [self startingPointForContext: context];
    return ret;
}

- (UIView *) clippingViewForContext: (id <UIViewControllerContextTransitioning>) context {

    UIView *containerView = context.containerView;
    UIView *destinationView = [self toViewController: context].view;


    CGPoint padding = CGPointMake(10, 10);

    CGPoint finalPoint = [self finalPointForContext: context];
    CGPoint offset = [self calculatedFinalOffset: padding];


    CGRect maskFrame = CGRectMake(finalPoint.x, finalPoint.y, destinationView.width, destinationView.height);


    CGFloat paddingValue = 100;

    UIDeviceOrientation orientation = self.deviceOrientation;

    if (orientation == UIDeviceOrientationLandscapeLeft ||
            orientation == UIDeviceOrientationPortraitUpsideDown) {
        maskFrame.size.height += paddingValue;
    } else {
        maskFrame.size.height += paddingValue;
        maskFrame.origin.y -= paddingValue;
    }

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.fillColor = [UIColor blueColor].CGColor;
    CGPathRef path = CGPathCreateWithRect(maskFrame, NULL);
    maskLayer.path = path;
    CGPathRelease(path);

    UIView *clippingView = [[UIView alloc] initWithFrame: containerView.frame];
    clippingView.userInteractionEnabled = NO;
    clippingView.layer.mask = maskLayer;

    return clippingView;
}

- (void) positionWithContext: (id <UIViewControllerContextTransitioning>) context {

    UIViewController *fromController = [self fromViewController: context];
    UIViewController *toController = [self toViewController: context];


    UIView *containerView = context.containerView;
    UIView *sourceView = [self fromViewController: context].view;
    UIView *destinationView = [self toViewController: context].view;

    [containerView addSubview: sourceView];
    [containerView addSubview: destinationView];

    CGSize rawSize = [self rawModalSizeForContext: context];
    CGSize correctSize = [self correctedModalSizeForContext: context];

    destinationView.size = correctSize;

    CGPoint startingPoint = [self startingPointForContext: context];
    destinationView.left = startingPoint.x;
    destinationView.top = startingPoint.y;

    UIView *clippingView = [self clippingViewForContext: context];
    [containerView addSubview: clippingView];
    [clippingView addSubview: destinationView];

}


- (CGRect) frameForClippingViewWithOffset: (CGPoint) point context: (id <UIViewControllerContextTransitioning>) context {
    CGFloat positionX = 0;
    CGFloat positionY = 0;
    CGFloat width = 0;
    CGFloat height = 0;


    UIView *containerView = context.containerView;
    UIDeviceOrientation deviceOrientation = self.deviceOrientation;

    NSLog(@"containerView.width = %f", containerView.width);
    NSLog(@"containerView.height = %f", containerView.height);

    NSLog(@"self.deviceOrientationAsString = %@", self.deviceOrientationAsString);

    width = containerView.width;
    height = containerView.height - positionY;

    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait :
            positionX = point.y;
            positionY = -point.x;
            break;

        case UIDeviceOrientationPortraitUpsideDown :
            positionX = -point.y;
            positionY = point.x;
            width = containerView.width;
            height = containerView.height - positionY;
            break;

        case UIDeviceOrientationLandscapeLeft :
            positionX = -point.y;
            positionY = point.x;
            width = containerView.width;
            height = containerView.height - positionY;
            break;

        case UIDeviceOrientationLandscapeRight :
            positionX = point.y;
            positionY = -point.x;
            break;

        default :
            break;
    }

    return CGRectMake(positionX, positionY, width, height);
}

- (CGPoint) startingPointForContext: (id <UIViewControllerContextTransitioning>) context {
    CGSize rawModalSize = [self rawModalSizeForContext: context];
    CGSize containerSize = [self deviceContainerSizeForContext: context];

    CGPoint finalPoint = [self finalPointForContext: context];

    //    NSLog(@"%s", __PRETTY_FUNCTION__);
    //    NSLog(@"containerSize.width = %f", containerSize.width);
    //    NSLog(@"containerSize.height = %f", containerSize.height);
    //    NSLog(@"rawModalSize.width = %f", rawModalSize.width);
    //    NSLog(@"rawModalSize.height = %f", rawModalSize.height);

    CGFloat positionX = finalPoint.x;
    CGFloat positionY = finalPoint.y;


    UIDeviceOrientation deviceOrientation = self.deviceOrientation;
    UIInterfaceOrientation interfaceOrientation = self.statusOrientation;

    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait : {
            switch (presentationEdge) {
                case UIRectEdgeLeft :
                    positionY += rawModalSize.width;
                    break;

                case UIRectEdgeRight :
                    positionY -= rawModalSize.width;
                    break;

                case UIRectEdgeTop :
                    positionX -= rawModalSize.height;
                    break;

                case UIRectEdgeBottom :
                    positionX += rawModalSize.height;
                    break;

                case UIRectEdgeNone  :
                default :
                    break;
            }
        }
            break;

        case UIInterfaceOrientationPortraitUpsideDown : {
            switch (presentationEdge) {
                case UIRectEdgeLeft :
                    positionY = -rawModalSize.width;
                    break;

                case UIRectEdgeRight :
                    positionY += rawModalSize.width;
                    break;

                case UIRectEdgeTop :
                    positionX += rawModalSize.height;
                    break;

                case UIRectEdgeBottom :
                    positionX -= rawModalSize.height;
                    break;

                case UIRectEdgeNone  :
                default :
                    break;
            }
        }
            break;

        case UIInterfaceOrientationLandscapeLeft : {
            switch (presentationEdge) {
                case UIRectEdgeLeft :
                    positionY = -rawModalSize.width;
                    break;

                case UIRectEdgeRight :
                    positionY += rawModalSize.width;
                    break;

                case UIRectEdgeTop :
                    positionX += rawModalSize.height;
                    break;

                case UIRectEdgeBottom :
                    positionX -= rawModalSize.height;
                    break;

                case UIRectEdgeNone  :
                default :
                    break;
            }
        }
            break;

        case UIInterfaceOrientationLandscapeRight : {
            switch (presentationEdge) {
                case UIRectEdgeLeft :
                    positionY += rawModalSize.width;
                    break;

                case UIRectEdgeRight :
                    positionY -= rawModalSize.width;

                    break;

                case UIRectEdgeTop :
                    positionX += rawModalSize.height;
                    //                    positionX = 0;
                    //                    positionY = 0;
                    break;

                case UIRectEdgeBottom :
                    positionX += rawModalSize.height;
                    break;

                case UIRectEdgeNone  :
                default :
                    break;
            }
        }
            break;

        default :
            break;
    }
    return CGPointMake(positionX, positionY);
}

- (CGPoint) finalPointForContext: (id <UIViewControllerContextTransitioning>) context {
    CGFloat offsetX = presentationOffset.x;
    CGFloat offsetY = presentationOffset.y;

    CGSize rawModalSize = [self rawModalSizeForContext: context];
    CGSize containerSize = [self deviceContainerSizeForContext: context];

    //    NSLog(@"%s", __PRETTY_FUNCTION__);
    //    NSLog(@"containerSize.width = %f", containerSize.width);
    //    NSLog(@"containerSize.height = %f", containerSize.height);
    //    NSLog(@"rawModalSize.width = %f", rawModalSize.width);
    //    NSLog(@"rawModalSize.height = %f", rawModalSize.height);

    CGFloat positionX = 10;
    CGFloat positionY = 200;


    UIDeviceOrientation deviceOrientation = self.deviceOrientation;
    UIInterfaceOrientation interfaceOrientation = self.statusOrientation;

    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait : {
            switch (presentationEdge) {
                case UIRectEdgeLeft :
                    positionX = 0;
                    positionY = containerSize.height - rawModalSize.width;
                    break;

                case UIRectEdgeRight :
                    positionX = 0;
                    positionY = 0;
                    break;

                case UIRectEdgeTop :
                    positionX = 0;
                    positionY = 0;
                    break;

                case UIRectEdgeBottom :
                    positionX = containerSize.width - rawModalSize.height;
                    positionY = 0;
                    break;

                case UIRectEdgeNone  :
                default :
                    break;
            }
        }
            break;

        case UIInterfaceOrientationPortraitUpsideDown : {
            switch (presentationEdge) {
                case UIRectEdgeLeft :
                    positionX = 0;
                    positionY = 0;
                    break;

                case UIRectEdgeRight :
                    positionX = 0;
                    positionY = containerSize.height - rawModalSize.width;
                    break;

                case UIRectEdgeTop :
                    positionX = containerSize.width - rawModalSize.height;
                    positionY = 0;
                    break;

                case UIRectEdgeBottom :
                    positionX = 0;
                    positionY = 0;
                    break;

                case UIRectEdgeNone  :
                default :
                    break;
            }
        }
            break;

        case UIInterfaceOrientationLandscapeLeft : {
            switch (presentationEdge) {
                case UIRectEdgeLeft :
                    positionX = 0;
                    positionY = 0;
                    break;

                case UIRectEdgeRight :
                    positionX = 0;
                    positionY = containerSize.width - rawModalSize.width;
                    break;

                case UIRectEdgeTop :
                    positionX = containerSize.height - rawModalSize.height;
                    positionY = 0;
                    break;

                case UIRectEdgeBottom :
                    positionX = 0;
                    positionY = 0;
                    break;

                case UIRectEdgeNone  :
                default :
                    break;
            }
        }
            break;

        case UIInterfaceOrientationLandscapeRight : {
            switch (presentationEdge) {
                case UIRectEdgeLeft :
                    positionX = 0;
                    positionY = containerSize.width - rawModalSize.width;
                    break;

                case UIRectEdgeRight :
                    positionX = 0;
                    positionY = 0;
                    break;

                case UIRectEdgeTop :
                    positionX = 0;
                    positionY = 0;
                    break;

                case UIRectEdgeBottom :
                    positionX = containerSize.height - rawModalSize.height;
                    positionY = 0;
                    break;

                case UIRectEdgeNone  :
                default :
                    break;
            }
        }
            break;

        default :
            break;
    }

    CGPoint offset = [self calculatedFinalOffset: presentationOffset];
    return CGPointMake(positionX + offset.x, positionY + offset.y);
}

- (CGPoint) calculatedFinalOffset: (CGPoint) offset {
    CGFloat offsetX = offset.x;
    CGFloat offsetY = offset.y;


    CGFloat positionX = 0;
    CGFloat positionY = 0;


    UIDeviceOrientation deviceOrientation = self.deviceOrientation;
    UIInterfaceOrientation interfaceOrientation = self.statusOrientation;

    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait : {
            switch (presentationEdge) {
                case UIRectEdgeLeft :
                    positionX = 0;
                    positionY = -offsetX;
                    break;

                case UIRectEdgeRight :
                    positionX = 0;
                    positionY = -offsetX;
                    break;

                case UIRectEdgeTop :
                    positionX = 0;
                    positionY = 0;
                    break;

                case UIRectEdgeBottom :
                    positionX = 0;
                    positionY = 0;
                    break;

                case UIRectEdgeNone  :
                default :
                    break;
            }
        }
            break;

        case UIInterfaceOrientationPortraitUpsideDown : {
            switch (presentationEdge) {
                case UIRectEdgeLeft :
                    positionX = 0;
                    positionY = 0 + offsetX;
                    break;

                case UIRectEdgeRight :
                    positionX = 0;
                    positionY = offsetX;
                    break;

                case UIRectEdgeTop :
                    positionX = 0;
                    positionY = 0;
                    break;

                case UIRectEdgeBottom :
                    positionX = 0;
                    positionY = 0;
                    break;

                case UIRectEdgeNone  :
                default :
                    break;
            }
        }
            break;

        case UIInterfaceOrientationLandscapeLeft : {
            switch (presentationEdge) {
                case UIRectEdgeLeft :
                    positionX = 0;
                    positionY = 0 + offsetX;
                    break;

                case UIRectEdgeRight :
                    positionX = 0;
                    positionY = offsetX;
                    break;

                case UIRectEdgeTop :
                    positionX = 0;
                    positionY = 0;
                    break;

                case UIRectEdgeBottom :
                    positionX = 0;
                    positionY = 0;
                    break;

                case UIRectEdgeNone  :
                default :
                    break;
            }
        }
            break;

        case UIInterfaceOrientationLandscapeRight : {
            switch (presentationEdge) {
                case UIRectEdgeLeft :
                    positionX = 0;
                    positionY = -offsetX;
                    break;

                case UIRectEdgeRight :
                    positionX = 0;
                    positionY = 0 - offsetX;
                    break;

                case UIRectEdgeTop :
                    positionX = 0;
                    positionY = 0;
                    break;

                case UIRectEdgeBottom :
                    positionX = 0;
                    positionY = 0;
                    break;

                case UIRectEdgeNone  :
                default :
                    break;
            }
        }
            break;

        default :
            break;
    }
    return CGPointMake(positionX, positionY);
}

- (CGPoint) startingPointForContext: (id <UIViewControllerContextTransitioning>) context
                         withOffset:
                                 (CGPoint) offset {
    CGSize rawModalSize = [self rawModalSizeForContext: context];
    CGSize containerSize = [self deviceContainerSizeForContext: context];

    CGPoint startingPoint = [self startingPointForContext: context];


    CGFloat positionX = startingPoint.x;
    CGFloat positionY = startingPoint.y;


    UIDeviceOrientation deviceOrientation = self.deviceOrientation;

    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait : {
            switch (presentationEdge) {
                case UIRectEdgeLeft :
                    positionY -= offset.x;
                    break;

                case UIRectEdgeRight :
                    positionY += offset.x;
                    break;

                case UIRectEdgeTop :
                    positionX += offset.y;
                    break;

                case UIRectEdgeBottom :
                    positionX -= offset.y;
                    break;

                case UIRectEdgeNone  :
                default :
                    break;
            }
        }
            break;

        case UIDeviceOrientationPortraitUpsideDown : {
            switch (presentationEdge) {
                case UIRectEdgeLeft :
                    positionY = -rawModalSize.width;
                    break;

                case UIRectEdgeRight :
                    positionY += rawModalSize.width;
                    break;

                case UIRectEdgeTop :
                    positionX += rawModalSize.height;
                    break;

                case UIRectEdgeBottom :
                    positionX -= rawModalSize.height;
                    break;

                case UIRectEdgeNone  :
                default :
                    break;
            }
        }
            break;

        case UIDeviceOrientationLandscapeLeft : {
            switch (presentationEdge) {
                case UIRectEdgeLeft :
                    positionY = -rawModalSize.width;
                    break;

                case UIRectEdgeRight :
                    positionY += rawModalSize.width;
                    break;

                case UIRectEdgeTop :
                    positionX += rawModalSize.height;
                    break;

                case UIRectEdgeBottom :
                    positionX -= rawModalSize.height;
                    break;

                case UIRectEdgeNone  :
                default :
                    break;
            }
        }
            break;

        case UIDeviceOrientationLandscapeRight : {

            switch (presentationEdge) {
                case UIRectEdgeLeft :
                    positionY += rawModalSize.width;
                    break;

                case UIRectEdgeRight :
                    positionY -= rawModalSize.width;
                    break;

                case UIRectEdgeTop :
                    positionX += rawModalSize.height;
                    //                    positionX = 0;
                    //                    positionY = 0;
                    break;

                case UIRectEdgeBottom :
                    positionX += rawModalSize.height;
                    break;

                case UIRectEdgeNone  :
                default :
                    break;
            }
        }
            break;

        default :
            break;
    }
    return CGPointMake(positionX, positionY);
}

- (CGSize) correctedModalSizeForContext: (id <UIViewControllerContextTransitioning>) context {
    CGSize ret = modalPresentationSize;

    if (ret.width == 0) {
        ret.width = [self containerSizeForContext: context].width;
    }

    if (ret.height == 0) {
        ret.height = [self containerSizeForContext: context].height;
    }

    //    NSLog(@"NSStringFromCGSize(ret) = %@", NSStringFromCGSize(ret));
    if (self.isLandscape) {
        ret = [self flipSize: ret];
        //        NSLog(@"flipped = %@", NSStringFromCGSize(ret));
    }
    return ret;
}

- (CGSize) rawModalSizeForContext: (id <UIViewControllerContextTransitioning>) context {
    CGSize ret = modalPresentationSize;
    if (ret.width == 0) {
        ret.width = [self containerSizeForContext: context].width;
    }

    if (ret.height == 0) {
        ret.height = [self containerSizeForContext: context].height;
    }

    return ret;
}

- (CGSize) flipSize: (CGSize) size {
    return CGSizeMake(size.height, size.width);
}

- (CGSize) containerSizeForContext: (id <UIViewControllerContextTransitioning>) context {
    UIView *containerView = context.containerView;
    CGSize ret = containerView.frame.size;

    if (self.isLandscape) {
        ret.width = fmaxf(containerView.width, containerView.height);
        ret.height = fminf(containerView.width, containerView.height);
    } else {
        ret.width = fminf(containerView.width, containerView.height);
        ret.height = fmaxf(containerView.width, containerView.height);

    }
    return ret;

}

- (CGSize) deviceContainerSizeForContext: (id <UIViewControllerContextTransitioning>) context {
    UIView *containerView = context.containerView;
    CGSize ret = containerView.frame.size;

    //    NSLog(@"containerView.frame = %@", NSStringFromCGRect(containerView.frame));
    //    NSLog(@"containerView.bounds = %@", NSStringFromCGRect(containerView.bounds));

    if (UIDeviceOrientationIsLandscape(self.deviceOrientation)) {
        ret.width = fmaxf(containerView.width, containerView.height);
        ret.height = fminf(containerView.width, containerView.height);
    } else {
        ret.width = fminf(containerView.width, containerView.height);
        ret.height = fmaxf(containerView.width, containerView.height);

    }

    //    NSLog(@"NSStringFromCGSize(ret) = %@", NSStringFromCGSize(ret));
    return ret;

}


@end