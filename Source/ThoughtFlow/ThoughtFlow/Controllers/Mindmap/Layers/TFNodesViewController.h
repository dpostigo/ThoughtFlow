//
// Created by Dani Postigo on 6/16/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"
#import "TFNodeViewDelegate.h"


@class TFNodeView;
@class TFNode;
@class DPPassThroughView;
@class TFNodeScrollView;

@protocol TFNodesViewControllerDelegate <NSObject>

@optional

- (void) nodesControllerDidUpdateViews: (NSArray *) nodeViews;

- (void) nodesControllerDidBeginCreatingNodeView: (TFNodeView *) nodeView withParent: (TFNodeView *) parentNodeView;
- (void) nodesControllerDidUpdateCreatingNodeView: (TFNodeView *) nodeView withParent: (TFNodeView *) parentNodeView;
- (void) nodesControllerDidEndCreatingNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node;

- (void) nodesControllerDidBeginMovingNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node;
- (void) nodesControllerDidUpdateMovingNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node;
- (void) nodesControllerDidEndMovingNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node;


- (void) nodesControllerDidBeginPinchingNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node;
- (void) nodesControllerDidUpdatePinchWithNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node;
- (void) nodesControllerDidEndPinchingNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node;
- (void) nodesControllerDidCompletePinchWithNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node;
- (void) nodesControllerDidUnpinchWithNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node;


- (void) nodesControllerDidCreateNode: (TFNode *) node withRoot: (TFNode *) rootNode;
- (void) nodesControllerDidSelectNode: (TFNode *) node;
- (void) nodesControllerDidDeleteNode: (TFNode *) node;
- (void) nodesControllerDidDoubleTapNode: (TFNode *) node;
- (void) nodesControllerDidTapRelated: (TFNodeView *) nodeView forNode: (TFNode *) node;


@end

@interface TFNodesViewController : TFViewController <TFNodeViewDelegate> {
    DPPassThroughView *_nodeContainerView;
}

@property(nonatomic, strong) TFNode *rootNode;
@property(nonatomic, strong) NSArray *nodes;
@property(nonatomic, strong) NSMutableArray *nodeViews;

@property(nonatomic, strong) TFNodeView *selectedNodeView;
@property(nonatomic, strong) TFNodeView *creationNodeView;
@property(nonatomic, assign) id <TFNodesViewControllerDelegate> delegate;
- (void) centerFirstNode;
- (void) startPan;
- (void) updatePan: (UIPanGestureRecognizer *) recognizer;
- (void) endPan;
- (void) selectFirstNodeView;
- (void) selectNodeView: (TFNodeView *) nodeView;
- (void) startPinchWithScale: (CGFloat) scale;
- (void) updatePinchWithScale: (CGFloat) scale;
- (void) endPinchWithScale: (CGFloat) scale;
- (void) unpinch;
@end