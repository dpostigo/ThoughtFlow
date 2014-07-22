//
// Created by Dani Postigo on 6/16/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"
#import "TFBaseNodeViewDelegate.h"


@class TFNode;
@class DPPassThroughView;
@class TFBaseNodeView;

@protocol TFNodesViewControllerDelegate <NSObject>

@optional
- (void) nodesControllerDidUpdateViews: (NSArray *) nodeViews;

- (void) nodesControllerDidBeginCreatingNodeView: (TFBaseNodeView *) nodeView withParent: (TFBaseNodeView *) parentNodeView;
- (void) nodesControllerDidUpdateCreatingNodeView: (TFBaseNodeView *) nodeView withParent: (TFBaseNodeView *) parentNodeView;
- (void) nodesControllerDidEndCreatingNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node;

- (void) nodesControllerDidBeginMovingNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node;
- (void) nodesControllerDidUpdateMovingNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node;
- (void) nodesControllerDidEndMovingNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node;

- (void) nodesControllerDidBeginPinchingNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node;
- (void) nodesControllerDidUpdatePinchWithNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node;
- (void) nodesControllerDidEndPinchingNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node;
- (void) nodesControllerDidCompletePinchWithNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node;
- (void) nodesControllerDidUnpinchWithNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node;

- (void) nodesControllerDidCreateNode: (TFNode *) node withRoot: (TFNode *) rootNode;
- (void) nodesControllerDidSelectNode: (TFNode *) node;
- (void) nodesControllerDidDeleteNode: (TFNode *) node withNodeView: (TFBaseNodeView *) nodeView;
- (void) nodesControllerDidDoubleTapNode: (TFNode *) node;
- (void) nodesControllerDidTapRelated: (TFBaseNodeView *) nodeView forNode: (TFNode *) node;


@end

@interface TFNodesViewController : TFViewController <TFBaseNodeViewDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong) TFNode *rootNode;
@property(nonatomic, strong) NSArray *nodes;
@property(nonatomic, strong) NSMutableArray *nodeViews;

@property(nonatomic, strong) TFBaseNodeView *selectedNodeView;
@property(nonatomic, assign) id <TFNodesViewControllerDelegate> delegate;
@property(nonatomic) CGPoint pinchEndPoint;
@property(nonatomic) CGPoint centerPoint;

- (void) removeNodeView: (TFBaseNodeView *) nodeView;
- (void) centerFirstNode;
- (void) selectFirstNodeView;

- (void) selectNodeView: (TFBaseNodeView *) nodeView;
- (void) startPinchWithScale: (CGFloat) scale;
- (void) updatePinchWithScale: (CGFloat) scale;
- (void) endPinchWithScale: (CGFloat) scale;
- (void) unpinch;
@end