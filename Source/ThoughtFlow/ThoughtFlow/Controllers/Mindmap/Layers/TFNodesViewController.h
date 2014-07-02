//
// Created by Dani Postigo on 6/16/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"
#import "TFNodeViewDelegate.h"

@class TFNodeView;
@class TFNode;

@protocol TFNodesViewDelegate <NSObject>

@optional

- (void) nodesControllerDidUpdateViews: (NSArray *) nodeViews;

- (void) nodesControllerDidBeginCreatingNodeView: (TFNodeView *) nodeView withParent: (TFNodeView *) parentNodeView;
- (void) nodesControllerDidUpdateCreatingNodeView: (TFNodeView *) nodeView withParent: (TFNodeView *) parentNodeView;
- (void) nodesControllerDidEndCreatingNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node;

- (void) nodesControllerDidCreateNode: (TFNode *) node withRoot: (TFNode *) rootNode;
- (void) nodesControllerDidDoubleTapNode: (TFNode *) node;

- (void) nodesControllerDidBeginMovingNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node;
- (void) nodesControllerDidUpdateMovingNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node;
- (void) nodesControllerDidEndMovingNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node;

@end

@interface TFNodesViewController : TFViewController <TFNodeViewDelegate> {
    __unsafe_unretained id <TFNodesViewDelegate> delegate;
}

@property(nonatomic, strong) NSArray *nodes;
@property(nonatomic, strong) NSMutableArray *nodeViews;
@property(nonatomic, strong) TFNodeView *creationNodeView;
@property(nonatomic, assign) id <TFNodesViewDelegate> delegate;
- (void) centerFirstNode;
@end