//
// Created by Dani Postigo on 7/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <BlocksKit/UIGestureRecognizer+BlocksKit.h>
#import <DPKit-Utils/UIView+DPKit.h>
#import <TLLayoutTransitioning/UICollectionView+TLTransitioning.h>
#import "TFMindmapFullCollectionViewController.h"
#import "TFPhoto.h"
#import "TFMindmapLayout.h"
#import "UIView+BlocksKit.h"
#import "TFMindmapGridLayout.h"
#import "TFMindmapTransitionLayout.h"
#import "TFMindmapFullscreenLayout.h"


@interface TFMindmapFullCollectionViewController ()

@property(nonatomic) BOOL hasActiveInteraction;
@property(nonatomic) CGPoint initialPinchPoint;
@property(nonatomic) CGFloat initialPinchDistance;
@property(nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property(nonatomic, strong) UICollectionViewTransitionLayout *transitionLayout;
@end

@implementation TFMindmapFullCollectionViewController

//- (id) init {
//    TFMindmapLayout *dynamicLayout = [[TFMindmapLayout alloc] init];
//
//    return [self initWithCollectionViewLayout: dynamicLayout];
//}


- (id) initWithCollectionViewLayout: (UICollectionViewLayout *) layout {
    TFMindmapLayout *newLayout = [[self class] initialLayout];
    self = [super initWithCollectionViewLayout: newLayout];
    if (self) {

        self.clearsSelectionOnViewWillAppear = NO;
        [self _setupRecognizer];
        [newLayout setIsFullscreen: YES withCollectionView: self.collectionView];

    }

    return self;
}


+ (TFMindmapLayout *) initialLayout {
    TFMindmapLayout *newLayout = [[TFMindmapLayout alloc] init];
    newLayout.numberOfRows = 1;
    return newLayout;

}


#pragma mark - View lifecycle


- (void) viewDidLoad {
    [super viewDidLoad];

}

- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    //    NSLog(@"%s, frame = %@", __PRETTY_FUNCTION__, NSStringFromCGRect(self.view.frame));
    [self.collectionView.collectionViewLayout invalidateLayout];
    if (_initialIndexPath) {
        _selectedImage = [self.images objectAtIndex: _initialIndexPath.item];
        [self.collectionView selectItemAtIndexPath: _initialIndexPath animated: NO scrollPosition: UICollectionViewScrollPositionNone];
        [self.collectionView scrollToItemAtIndexPath: _initialIndexPath atScrollPosition: UICollectionViewScrollPositionNone animated: NO];
        _initialIndexPath = nil;
    }

}

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

}


- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}






#pragma mark - Setup

- (void) _setupRecognizer {
    //    _pinchGesture = [[UIPinchGestureRecognizer alloc] bk_initWithHandler: ^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
    //
    //    }];

    _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget: self action: @selector(handlePinch:)];
    [self.view addGestureRecognizer: _pinchGesture];
    //    _pinchGesture.enabled = NO;
}


- (void) startInteractiveTransition {

    UICollectionViewLayout *currentLayout = self.collectionView.collectionViewLayout;

    DDLogWarn(@"SET TEMP LAYOUT.");

    TFMindmapFullscreenLayout *tempLayout = [[TFMindmapFullscreenLayout alloc] init];
    [tempLayout setIsFullscreen: YES  withCollectionView: self.collectionView];
    self.collectionView.collectionViewLayout = tempLayout;

    TFMindmapFullscreenLayout *layout = [[TFMindmapFullscreenLayout alloc] init];
    [layout setIsFullscreen: NO  withCollectionView: self.collectionView];


    DDLogWarn(@"START TRANSITION.");
    _transitionLayout = [self.collectionView startInteractiveTransitionToCollectionViewLayout: layout
            completion: ^(BOOL completed, BOOL finish) {

                self.transitionLayout = nil;
                self.hasActiveInteraction = NO;
                if (finish) {

                    NSUInteger index = [self.navigationController.viewControllers indexOfObject: self];
                    CGPoint contentOffset = self.collectionView.contentOffset;

                    UICollectionViewController *controller = [self.navigationController.viewControllers objectAtIndex: index];
                    controller.collectionView.contentOffset = self.collectionView.contentOffset;

                    NSLog(@"Popping.");

                    [self.navigationController popViewControllerAnimated: NO];
                } else {
                    self.collectionView.collectionViewLayout = currentLayout;
                    [self.collectionView.collectionViewLayout invalidateLayout];
                    self.collectionView.pagingEnabled = YES;
                }

            }];

}

- (void) updateWithProgress: (CGFloat) progress {
    if ((progress != self.transitionLayout.transitionProgress)) {
        //        [self.transitionLayout setOffset: offset];
        [self.transitionLayout setTransitionProgress: progress];
        [self.transitionLayout invalidateLayout];
        //        [self.context updateInteractiveTransition: progress];
    }
    //    if (self.context != nil &&  // we must have a valid context for updates
    //            ((progress != self.transitionLayout.transitionProgress) ||
    //                    !UIOffsetEqualToOffset(offset, self.transitionLayout.offset))) {
    //        [self.transitionLayout setOffset: offset];
    //        [self.transitionLayout setTransitionProgress: progress];
    //        [self.transitionLayout invalidateLayout];
    //        [self.context updateInteractiveTransition: progress];
    //    }
}


- (void) endInteractionWithSuccess: (BOOL) success {
    if ((self.transitionLayout.transitionProgress > 0.5) && success) {
        [self.collectionView finishInteractiveTransition];
    }
    else {
        [self.collectionView cancelInteractiveTransition];
    }

}

- (void) handlePinch: (UIPinchGestureRecognizer *) recognizer {

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self endInteractionWithSuccess: YES];

    } else if (recognizer.state == UIGestureRecognizerStateCancelled) {
        [self endInteractionWithSuccess: NO];

    } else if (recognizer.numberOfTouches == 2) {
        // here we expect two finger touch
        CGPoint point;      // the main touch point
        CGPoint point1;     // location of touch #1
        CGPoint point2;     // location of touch #2
        CGFloat distance;   // computed distance between both touches

        // return the locations of each gesture’s touches in the local coordinate system of a given view
        point1 = [recognizer locationOfTouch: 0 inView: recognizer.view];
        point2 = [recognizer locationOfTouch: 1 inView: recognizer.view];
        distance = sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));

        // get the main touch point
        point = [recognizer locationInView: recognizer.view];

        if (recognizer.state == UIGestureRecognizerStateBegan) {
            // start the pinch in our out
            if (!self.hasActiveInteraction) {
                self.initialPinchDistance = distance;
                self.initialPinchPoint = point;
                self.hasActiveInteraction = YES;    // the transition is in active motion
                //                [self.delegate interactionBeganAtPoint: point];

                [self startInteractiveTransition];

            }
        }

        if (self.hasActiveInteraction) {
            if (recognizer.state == UIGestureRecognizerStateChanged) {
                NSLog(@"recognizer.velocity = %f", recognizer.velocity);

                CGFloat distanceDelta = distance - self.initialPinchDistance;
                //                if (self.navigationOperation == UINavigationControllerOperationPop) {
                distanceDelta = -distanceDelta;
                //                distanceDelta *= recognizer.velocity;
                //                }
                CGFloat dimension = sqrt(self.collectionView.bounds.size.width * self.collectionView.bounds.size.width + self.collectionView.bounds.size.height * self.collectionView.bounds.size.height);
                CGFloat progress = MAX(MIN((distanceDelta / dimension), 1.0), 0.0);

                //                progress *= recognizer.velocity;
                NSLog(@"progress = %f", progress);

                CGFloat scale = 1 - recognizer.scale;

                NSLog(@"distanceDelta = %f", distanceDelta);

                //                [self updateWithProgress: progress];
                [self updateWithProgress: scale];

            }
        }
    }

    //
    //    switch (recognizer.state) {
    //
    //
    //
    //        // here we expect two finger touch
    //        CGPoint point;      // the main touch point
    //        CGPoint point1;     // location of touch #1
    //        CGPoint point2;     // location of touch #2
    //        CGFloat distance;   // computed distance between both touches
    //
    //        case UIGestureRecognizerStateBegan: {
    //
    //            // return the locations of each gesture’s touches in the local coordinate system of a given view
    //            point1 = [recognizer locationOfTouch: 0 inView: recognizer.view];
    //            point2 = [recognizer locationOfTouch: 1 inView: recognizer.view];
    //            distance = sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
    //
    //            // get the main touch point
    //            point = [recognizer locationInView: recognizer.view];
    //
    //            UICollectionViewLayout *currentLayout = self.collectionView.collectionViewLayout;
    //
    //            DDLogWarn(@"SET TEMP LAYOUT.");
    //
    //            TFMindmapFullscreenLayout *tempLayout = [[TFMindmapFullscreenLayout alloc] init];
    //            [tempLayout setIsFullscreen: YES  withCollectionView: self.collectionView];
    //            self.collectionView.collectionViewLayout = tempLayout;
    //
    //            TFMindmapFullscreenLayout *layout = [[TFMindmapFullscreenLayout alloc] init];
    //            [layout setIsFullscreen: NO  withCollectionView: self.collectionView];
    //
    //
    //            DDLogWarn(@"START TRANSITION.");
    //            _transitionLayout = [self.collectionView startInteractiveTransitionToCollectionViewLayout: layout
    //                    completion: ^(BOOL completed, BOOL finish) {
    //                        if (finish) {
    //
    //                            NSUInteger index = [self.navigationController.viewControllers indexOfObject: self];
    //                            CGPoint contentOffset = self.collectionView.contentOffset;
    //
    //                            UICollectionViewController *controller = [self.navigationController.viewControllers objectAtIndex: index];
    //                            controller.collectionView.contentOffset = self.collectionView.contentOffset;
    //
    //                            NSLog(@"Popping.");
    //
    //                            [self.navigationController popViewControllerAnimated: NO];
    //                        } else {
    //                            self.collectionView.collectionViewLayout = currentLayout;
    //                            self.collectionView.pagingEnabled = YES;
    //                        }
    //
    //                        _transitionLayout = nil;
    //                    }];
    //
    //            break;
    //        }
    //        case UIGestureRecognizerStateChanged : {
    //            // update the progress of the transtition as the user continues to pinch
    //            CGFloat offsetX = point.x - self.initialPinchPoint.x;
    //            CGFloat offsetY = point.y - self.initialPinchPoint.y;
    //            UIOffset offsetToUse = UIOffsetMake(offsetX, offsetY);
    //
    //            CGFloat distanceDelta = distance - self.initialPinchDistance;
    //            if (self.navigationOperation == UINavigationControllerOperationPop) {
    //                distanceDelta = -distanceDelta;
    //            }
    //            CGFloat dimension = sqrt(self.collectionView.bounds.size.width * self.collectionView.bounds.size.width + self.collectionView.bounds.size.height * self.collectionView.bounds.size.height);
    //            CGFloat progress = MAX(MIN((distanceDelta / dimension), 1.0), 0.0);
    //
    //            if (_transitionLayout != nil) {
    //                if (![_transitionLayout isKindOfClass: [TFMindmapTransitionLayout class]]) {
    //                    NSLog(@"_transitionLayout = %@", _transitionLayout);
    //                }
    //                CGFloat scale = 1 - recognizer.scale;
    //                _transitionLayout.transitionProgress = scale;
    //            }
    //            break;
    //        }
    //        case UIGestureRecognizerStateEnded : {
    //            CGFloat scale = 1 - recognizer.scale;
    //            if (scale > 0.8) {
    //
    //                [self.collectionView finishInteractiveTransition];
    //            } else {
    //                [self.collectionView cancelInteractiveTransition];
    //            }
    //
    //            break;
    //        }
    //
    //        case UIGestureRecognizerStateCancelled : {
    //            [self.collectionView cancelInteractiveTransition];
    //            break;
    //        }
    //
    //        case UIGestureRecognizerStateFailed :
    //            break;
    //        case UIGestureRecognizerStatePossible :
    //            break;
    //    }
}

#pragma mark - Overrides:UICollectionView



- (void) collectionView: (UICollectionView *) collectionView didSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    //    [super collectionView: collectionView didSelectItemAtIndexPath: indexPath];

    //    TFMindmapLayout *layout = [[TFMindmapLayout alloc] init];
    //    [layout setIsFullscreen: YES withCollectionView: self.collectionView];
    //
    //    self.collectionView.collectionViewLayout = layout;

}

- (UICollectionViewTransitionLayout *) collectionView: (UICollectionView *) collectionView transitionLayoutForOldLayout: (UICollectionViewLayout *) fromLayout newLayout: (UICollectionViewLayout *) toLayout {
    TFMindmapTransitionLayout *ret = [[TFMindmapTransitionLayout alloc] initWithCurrentLayout: fromLayout nextLayout: toLayout];
    return ret;
}



#pragma mark - UIScrollView

- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView {

    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint: self.collectionView.contentOffset];
    [self.collectionView selectItemAtIndexPath: indexPath animated: NO scrollPosition: UICollectionViewScrollPositionNone];

    TFPhoto *image = [self.images objectAtIndex: indexPath.item];
    _selectedImage = image;

    [self _notifySelectedImage: image];

}

- (void) _notifySelectedImage: (TFPhoto *) image {
    if (_delegate && [_delegate respondsToSelector: @selector(mindmapCollectionViewController:selectedImage:)]) {
        [_delegate mindmapCollectionViewController: self selectedImage: image];
    }
}

@end