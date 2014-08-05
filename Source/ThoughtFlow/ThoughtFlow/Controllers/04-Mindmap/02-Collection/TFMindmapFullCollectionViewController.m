//
// Created by Dani Postigo on 7/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "TFMindmapFullCollectionViewController.h"
#import "TFPhoto.h"
#import "TFMindmapLayout.h"
#import "TFNewMindmapLayout.h"
#import "TFNewTransitionLayout.h"


@interface TFMindmapFullCollectionViewController ()

@property(nonatomic) BOOL usesCustomTransitionLayout;
@property(nonatomic) BOOL hasActiveInteraction;
@property(nonatomic) CGPoint initialPinchPoint;
@property(nonatomic) CGFloat initialPinchDistance;
@property(nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property(nonatomic, strong) UICollectionViewTransitionLayout *transitionLayout;
@property(nonatomic, strong) TFNewTransitionLayout *customTransitionLayout;
@property(nonatomic, strong) TFNewMindmapLayout *tempLayout;
@end

@implementation TFMindmapFullCollectionViewController

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

    //    _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget: self action: @selector(handleTransitionPinch:)];
    _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget: self action: @selector(handleManualPinch:)];
    [self.view addGestureRecognizer: _pinchGesture];
    //    _pinchGesture.enabled = NO;
}


#pragma mark - Interactive Transition

- (void) startInteractiveTransition {

    self.collectionView.userInteractionEnabled = NO;
    UICollectionViewLayout *currentLayout = self.collectionView.collectionViewLayout;

    DDLogWarn(@"SET TEMP LAYOUT.");

    self.isPinching = YES;

    _tempLayout = [[TFNewMindmapLayout alloc] init];
    _tempLayout.numberOfRows = 3;
    _tempLayout.itemSize = self.view.bounds.size;
    self.collectionView.collectionViewLayout = _tempLayout;
    //    [self.collectionView.collectionViewLayout invalidateLayout];

    CGFloat itemHeight = self.view.height / 3;
    TFNewMindmapLayout *layout = [[TFNewMindmapLayout alloc] init];
    layout.numberOfRows = 3;
    layout.itemSize = CGSizeMake(itemHeight, itemHeight);


    DDLogWarn(@"START TRANSITION.");
    self.transitionLayout = [self.collectionView startInteractiveTransitionToCollectionViewLayout: layout
            completion: ^(BOOL completed, BOOL finish) {

                [self transitionDidComplete: finish currentLayout: currentLayout];

            }];
}


- (void) transitionDidComplete: (BOOL) didFinish currentLayout: (UICollectionViewLayout *) currentLayout {
    self.customTransitionLayout = nil;
    self.hasActiveInteraction = NO;
    if (didFinish) {

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

    self.isPinching = NO;
}

- (void) updateWithProgress: (CGFloat) progress {

    _transitionLayout.transitionProgress = progress;


    //    [self.customTransitionLayout invalidateLayout];
    //    if ((progress != self.customTransitionLayout.transitionProgress)) {
    //        //        [self.customTransitionLayout setOffset: offset];
    //        [self.customTransitionLayout setTransitionProgress: progress];
    //        [self.customTransitionLayout invalidateLayout];
    //        //        [self.context updateInteractiveTransition: progress];
    //    }
    //    //    if (self.context != nil &&  // we must have a valid context for updates
    //    //            ((progress != self.customTransitionLayout.transitionProgress) ||
    //    //                    !UIOffsetEqualToOffset(offset, self.customTransitionLayout.offset))) {
    //    //        [self.customTransitionLayout setOffset: offset];
    //    //        [self.customTransitionLayout setTransitionProgress: progress];
    //    //        [self.customTransitionLayout invalidateLayout];
    //    //        [self.context updateInteractiveTransition: progress];
    //    //    }
}


- (void) endInteractionWithSuccess: (BOOL) success {
    if ((_transitionLayout.transitionProgress > 0.5) && success) {
        [self.collectionView finishInteractiveTransition];
    }
    else {
        [self.collectionView cancelInteractiveTransition];
    }

    self.collectionView.userInteractionEnabled = YES;
}


- (void) handleManualPinch: (UIPinchGestureRecognizer *) recognizer {

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        DDLogVerbose(@"Begin pinch.");
        _tempLayout = [[TFNewMindmapLayout alloc] init];
        _tempLayout.numberOfRows = 3;
        _tempLayout.itemSize = self.view.bounds.size;
        _tempLayout.updatesContentOffset = YES;
        self.collectionView.collectionViewLayout = _tempLayout;
        [self.collectionView.collectionViewLayout invalidateLayout];

        self.isPinching = YES;

    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (!_tempLayout) return;

        CGFloat scale = 1 - recognizer.scale;

        CGFloat minHeight = self.view.height / 3;
        CGFloat maxHeight = self.view.height;
        CGFloat heightRange = maxHeight - minHeight;

        CGFloat currentHeight = maxHeight - (heightRange * scale);
        currentHeight = fmaxf(currentHeight, minHeight);
        currentHeight = fminf(currentHeight, maxHeight);

        CGFloat minWidth = minHeight;
        CGFloat maxWidth = self.view.width;
        CGFloat widthRange = maxWidth - minWidth;

        CGFloat currentWidth = maxWidth - (widthRange * scale);
        currentWidth = fmaxf(currentWidth, minWidth);
        currentWidth = fminf(currentWidth, maxWidth);

        _tempLayout.itemSize = CGSizeMake(currentWidth, currentHeight);
        [_tempLayout invalidateLayout];

    } else if (recognizer.state == UIGestureRecognizerStateEnded ||
            recognizer.state == UIGestureRecognizerStateCancelled) {

        CGFloat scale = recognizer.scale;

        TFNewMindmapLayout *finalLayout = [[TFNewMindmapLayout alloc] init];
        finalLayout.numberOfRows = 3;
        finalLayout.updatesContentOffset = YES;
        //        finalLayout.updatesTargetedOffset = YES;

        if (scale < 0.5) {
            CGFloat finalHeight = self.view.height / 3;
            finalLayout.itemSize = CGSizeMake(finalHeight, finalHeight);
        } else {
            finalLayout.itemSize = self.view.bounds.size;
        }

        __weak __typeof (self) weakSelf = self;
        [self.collectionView setCollectionViewLayout: finalLayout animated: YES completion: ^(BOOL finished) {

            __strong __typeof (self) strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.isPinching = NO;
                [strongSelf.navigationController popViewControllerAnimated: NO];
            }
        }];

    }

}

- (void) handleTransitionPinch: (UIPinchGestureRecognizer *) recognizer {

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
                //                NSLog(@"recognizer.velocity = %f", recognizer.velocity);

                CGFloat distanceDelta = distance - self.initialPinchDistance;
                //                if (self.navigationOperation == UINavigationControllerOperationPop) {
                distanceDelta = -distanceDelta;
                //                distanceDelta *= recognizer.velocity;
                //                }
                CGFloat dimension = sqrt(self.collectionView.bounds.size.width * self.collectionView.bounds.size.width + self.collectionView.bounds.size.height * self.collectionView.bounds.size.height);
                CGFloat progress = MAX(MIN((distanceDelta / dimension), 1.0), 0.0);

                //                progress *= recognizer.velocity;
                //                NSLog(@"progress = %f", progress);

                CGFloat scale = 1 - recognizer.scale;


                //                [self updateWithProgress: progress];
                [self updateWithProgress: scale];

            }
        }
    }

}


#pragma mark - Transition Layout


#pragma mark - Overrides:UICollectionView
//
//
//- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath: (NSIndexPath *) indexPath {
//
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    UICollectionViewCell *ret;
//
//    if ([_cachedCells count] > indexPath.item) {
//        ret = [_cachedCells objectAtIndex: indexPath.item];
//    } else {
//        ret = [super collectionView: collectionView cellForItemAtIndexPath: indexPath];
//        [_cachedCells addObject: ret];
//    }
//
//    if (_isPinching) {
//
//        [ret setNeedsDisplay];
//    }
//
//    NSLog(@"indexPath = %@", indexPath);
//
//    return ret;
//}


- (void) collectionView: (UICollectionView *) collectionView didSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    if (_isPinching) {
        return;
    }

    //    [super collectionView: collectionView didSelectItemAtIndexPath: indexPath];
    //    self.collectionView.collectionViewLayout = [self fullscreenLayout];

}

- (UICollectionViewTransitionLayout *) collectionView: (UICollectionView *) collectionView transitionLayoutForOldLayout: (UICollectionViewLayout *) fromLayout newLayout: (UICollectionViewLayout *) toLayout {
    //    if (_usesCustomTransitionLayout) {
    //    TFNewTransitionLayout *ret = [[TFNewTransitionLayout alloc] initWithCurrentLayout: fromLayout nextLayout: toLayout];
    //    return ret;
    //    }

    UICollectionViewTransitionLayout *ret = [[UICollectionViewTransitionLayout alloc] initWithCurrentLayout: fromLayout nextLayout: toLayout];
    return ret;

}



#pragma mark - UIScrollView

- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView {

    if (self.isPinching) return;
    if (self.hasActiveInteraction) return;

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