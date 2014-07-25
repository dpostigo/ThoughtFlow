//
// Created by Dani Postigo on 7/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <BlocksKit/UIGestureRecognizer+BlocksKit.h>
#import "TFMindmapFullCollectionViewController.h"
#import "TFMindmapGridLayout.h"


@interface TFMindmapFullCollectionViewController ()

@property(nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property(nonatomic, strong) UICollectionViewTransitionLayout *transitionLayout;
@end

@implementation TFMindmapFullCollectionViewController

//- (id) init {
//    TFMindmapGridLayout *dynamicLayout = [[TFMindmapGridLayout alloc] init];
//
//    return [self initWithCollectionViewLayout: dynamicLayout];
//}


- (id) initWithCollectionViewLayout: (UICollectionViewLayout *) layout {
    TFMindmapGridLayout *dynamicLayout = [[TFMindmapGridLayout alloc] init];
    dynamicLayout.numberOfRows = 1;
    self = [super initWithCollectionViewLayout: dynamicLayout];
    if (self) {

        [self _setupRecognizer];
        [dynamicLayout setIsFullscreen: YES withCollectionView: self.collectionView];

    }

    return self;
}


- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self.collectionView.collectionViewLayout invalidateLayout];
}




#pragma mark - Setup

- (void) _setupRecognizer {
    _pinchGesture = [[UIPinchGestureRecognizer alloc] bk_initWithHandler: ^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        UIPinchGestureRecognizer *recognizer = (UIPinchGestureRecognizer *) sender;
        switch (sender.state) {

            case UIGestureRecognizerStateBegan: {
                TFMindmapGridLayout *layout = [[TFMindmapGridLayout alloc] init];

                _transitionLayout = [self.collectionView startInteractiveTransitionToCollectionViewLayout: layout
                        completion: ^(BOOL completed, BOOL finish) {

                        }];

                break;
            }
            case UIGestureRecognizerStateChanged : {
                CGFloat scale = recognizer.scale;
                _transitionLayout.transitionProgress = scale;

                break;
            }
            case UIGestureRecognizerStateEnded :
            case UIGestureRecognizerStateCancelled : {
                [self.collectionView finishInteractiveTransition];
                break;
            }

            case UIGestureRecognizerStateFailed :
                break;
            case UIGestureRecognizerStatePossible :
                break;
        }
    }];
}

#pragma mark - Overrides


- (void) collectionView: (UICollectionView *) collectionView didSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    //    [super collectionView: collectionView didSelectItemAtIndexPath: indexPath];
}


@end