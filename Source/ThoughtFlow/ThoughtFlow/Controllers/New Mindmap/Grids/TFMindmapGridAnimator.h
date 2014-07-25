//
// Created by Dani Postigo on 7/23/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol APLTransitionManagerDelegate <NSObject>

- (void) interactionBeganAtPoint: (CGPoint) p;
@end


@interface TFMindmapGridAnimator : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>

@property(nonatomic, assign) id <APLTransitionManagerDelegate> delegate;
@property(nonatomic) BOOL hasActiveInteraction;
@property(nonatomic) BOOL enabled;
@property(nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property(nonatomic, strong) UICollectionView *collectionView;


@end