//
// Created by Dani Postigo on 7/23/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFMindmapGridAnimator.h"
#import "TFTransitionLayout.h"


@interface TFMindmapGridAnimator ()

@property(nonatomic) id <UIViewControllerContextTransitioning> context;

@property(nonatomic) TFTransitionLayout *transitionLayout;
@property(nonatomic) CGFloat initialPinchDistance;
@property(nonatomic) CGPoint initialPinchPoint;
@end

@implementation TFMindmapGridAnimator

- (id) init {
    self = [super init];
    if (self) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget: self action: @selector(handlePinch:)];
        _pinchGesture.enabled = NO;
    }

    return self;
}


- (void) setCollectionView: (UICollectionView *) collectionView {
    NSLog(@"%s, collectionView = %@", __PRETTY_FUNCTION__, collectionView);
    _collectionView = collectionView;
    if (_pinchGesture.view) {
        [_pinchGesture.view removeGestureRecognizer: _pinchGesture];
    }
    [_collectionView addGestureRecognizer: _pinchGesture];
}


- (NSTimeInterval) transitionDuration: (id <UIViewControllerContextTransitioning>) transitionContext {
    return 0.5;
}

- (void) animateTransition: (id <UIViewControllerContextTransitioning>) transitionContext {

}


#pragma mark - Interactive transition

- (void) startInteractiveTransition: (id <UIViewControllerContextTransitioning>) transitionContext {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.context = transitionContext;

    UICollectionViewController *fromCollectionViewController = (UICollectionViewController *) [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UICollectionViewController *toCollectionViewController = (UICollectionViewController *) [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    [containerView addSubview: [toCollectionViewController view]];

    self.transitionLayout = (TFTransitionLayout *) [fromCollectionViewController.collectionView
            startInteractiveTransitionToCollectionViewLayout: toCollectionViewController.collectionViewLayout
            completion: ^(BOOL didFinish, BOOL didComplete) {
                [self.context completeTransition: didComplete];
                self.transitionLayout = nil;
                self.context = nil;
                self.hasActiveInteraction = NO;
            }];
}


- (void) endInteractionWithSuccess: (BOOL) success {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (self.context == nil) {
        self.hasActiveInteraction = NO;
    }
            // allow for the transition to finish when it's progress has started as a threshold of 10%,
            // if you want to require the pinch gesture with a wider threshold, change it it a value closer to 1.0
            //
    else if ((self.transitionLayout.transitionProgress > 0.1) && success) {
        [self.collectionView finishInteractiveTransition];
        [self.context finishInteractiveTransition];
    }
    else {
        [self.collectionView cancelInteractiveTransition];
        [self.context cancelInteractiveTransition];
    }
}


- (void) updateWithProgress: (CGFloat) progress andOffset: (UIOffset) offset {

    //    TODO :
    //
    //    if (self.context != nil &&  // we must have a valid context for updates
    //            ((progress != self.transitionLayout.transitionProgress) ||
    //                    !UIOffsetEqualToOffset(offset, self.transitionLayout.offset))) {
    //        [self.transitionLayout setOffset: offset];
    //        [self.transitionLayout setTransitionProgress: progress];
    //        [self.transitionLayout invalidateLayout];
    //        [self.context updateInteractiveTransition: progress];
    //    }
}


#pragma mark -
- (void) handlePinch: (UIPinchGestureRecognizer *) sender {

    switch (sender.state) {

        case UIGestureRecognizerStateBegan :
        case UIGestureRecognizerStateChanged : {
            // here we expect two finger touch
            CGPoint point;      // the main touch point
            CGPoint point1;     // location of touch #1
            CGPoint point2;     // location of touch #2
            CGFloat distance;   // computed distance between both touches

            // return the locations of each gesture’s touches in the local coordinate system of a given view
            point1 = [sender locationOfTouch: 0 inView: sender.view];
            point2 = [sender locationOfTouch: 1 inView: sender.view];
            distance = sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));

            // get the main touch point
            point = [sender locationInView: sender.view];

            if (sender.state == UIGestureRecognizerStateBegan) {
                // start the pinch in our out
                if (!self.hasActiveInteraction) {
                    self.initialPinchDistance = distance;
                    self.initialPinchPoint = point;
                    self.hasActiveInteraction = YES;    // the transition is in active motion

                    [self.delegate interactionBeganAtPoint: point];
                }
            }

            if (self.hasActiveInteraction) {
                if (sender.state == UIGestureRecognizerStateChanged) {
                    // update the progress of the transtition as the user continues to pinch
                    CGFloat offsetX = point.x - self.initialPinchPoint.x;
                    CGFloat offsetY = point.y - self.initialPinchPoint.y;
                    UIOffset offsetToUse = UIOffsetMake(offsetX, offsetY);

                    CGFloat distanceDelta = distance - self.initialPinchDistance;
                    // TODO :
                    //                if (self.navigationOperation == UINavigationControllerOperationPop) {
                    //                    distanceDelta = -distanceDelta;
                    //                }
                    CGFloat dimension = sqrt(self.collectionView.bounds.size.width * self.collectionView.bounds.size.width + self.collectionView.bounds.size.height * self.collectionView.bounds.size.height);
                    CGFloat progress = MAX(MIN((distanceDelta / dimension), 1.0), 0.0);

                    // tell our UICollectionViewTransitionLayout subclass (transitionLayout)
                    // the progress state of the pinch gesture
                    //


                    [self updateWithProgress: progress andOffset: offsetToUse];
                }
            }

            break;
        }

        case UIGestureRecognizerStateEnded :
        case UIGestureRecognizerStateCancelled : {
            [self endInteractionWithSuccess: YES];
            break;
        }
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }

    return;

    // here we want to end the transition interaction if the
    // user stops or finishes the pinch gesture
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self endInteractionWithSuccess: YES];
    }
    else if (sender.state == UIGestureRecognizerStateCancelled) {
        [self endInteractionWithSuccess: NO];
    }
    else if (sender.numberOfTouches == 2) {
        // here we expect two finger touch
        CGPoint point;      // the main touch point
        CGPoint point1;     // location of touch #1
        CGPoint point2;     // location of touch #2
        CGFloat distance;   // computed distance between both touches

        // return the locations of each gesture’s touches in the local coordinate system of a given view
        point1 = [sender locationOfTouch: 0 inView: sender.view];
        point2 = [sender locationOfTouch: 1 inView: sender.view];
        distance = sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));

        // get the main touch point
        point = [sender locationInView: sender.view];

        if (sender.state == UIGestureRecognizerStateBegan) {
            // start the pinch in our out
            if (!self.hasActiveInteraction) {
                self.initialPinchDistance = distance;
                self.initialPinchPoint = point;
                self.hasActiveInteraction = YES;    // the transition is in active motion

                //                TODO :
                //                [self.delegate interactionBeganAtPoint: point];
            }
        }

        if (self.hasActiveInteraction) {
            if (sender.state == UIGestureRecognizerStateChanged) {
                // update the progress of the transtition as the user continues to pinch
                CGFloat offsetX = point.x - self.initialPinchPoint.x;
                CGFloat offsetY = point.y - self.initialPinchPoint.y;
                UIOffset offsetToUse = UIOffsetMake(offsetX, offsetY);

                CGFloat distanceDelta = distance - self.initialPinchDistance;
                // TODO :
                //                if (self.navigationOperation == UINavigationControllerOperationPop) {
                //                    distanceDelta = -distanceDelta;
                //                }
                CGFloat dimension = sqrt(self.collectionView.bounds.size.width * self.collectionView.bounds.size.width + self.collectionView.bounds.size.height * self.collectionView.bounds.size.height);
                CGFloat progress = MAX(MIN((distanceDelta / dimension), 1.0), 0.0);

                // tell our UICollectionViewTransitionLayout subclass (transitionLayout)
                // the progress state of the pinch gesture
                //


                [self updateWithProgress: progress andOffset: offsetToUse];
            }
        }
    }
}


- (BOOL) enabled {
    return _pinchGesture.enabled;
}

- (void) setEnabled: (BOOL) enabled {
    _pinchGesture.enabled = enabled;
}

@end