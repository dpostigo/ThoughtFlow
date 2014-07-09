//
// Created by Dani Postigo on 6/16/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"

@class TFNode;
@class TFNodeView;
@class TFLiveUpdateLayer;

@interface MindmapLinesController : TFViewController

//@property(nonatomic, strong) NSArray *nodes;

//@property(nonatomic, strong) NSArray *nodeViews;
@property(nonatomic, strong) TFNode *rootNode;
@property(nonatomic, strong) TFLiveUpdateLayer *liveLayer;
@property(nonatomic, strong) UIColor *lineColor;
- (void) startPinchWithNodeViews: (NSArray *) nodeViews;
- (void) updatePinchWithNodeViews: (NSArray *) nodeViews;
- (void) endPinchWithNodeViews: (NSArray *) nodeViews;
- (void) startTargetNode: (TFNode *) targetNode;
- (void) updateTargetNode: (TFNode *) targetNode withNodeView: (TFNodeView *) nodeView;
- (void) endTargetNode;
- (void) startMoveWithNodeView: (TFNodeView *) nodeView withParent: (TFNodeView *) parentNodeView;
- (void) updateTempLineFromPoint: (CGPoint) a toPoint: (CGPoint) b;
- (void) endMoveWithNodeView: (TFNodeView *) nodeView withParent: (TFNodeView *) parentNodeView;
@end