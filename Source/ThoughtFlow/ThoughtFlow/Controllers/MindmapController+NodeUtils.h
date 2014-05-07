//
// Created by Dani Postigo on 5/6/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MindmapController.h"

@class TFNodeView;

@interface MindmapController (NodeUtils)

- (void) startNodeMove: (TFNodeView *) node location: (CGPoint) location;
- (void) updateNodeMove: (TFNodeView *) node location: (CGPoint) location;
- (void) endNodeMove: (TFNodeView *) node location: (CGPoint) location;
- (void) setLayerLine: (CALayer *) layer fromPoint: (CGPoint) a toPoint: (CGPoint) b;
- (void) setLayerLine: (CALayer *) layer fromPoint: (CGPoint) a toPoint: (CGPoint) b animated: (BOOL) flag;
- (void) updateLineForNodeView: (TFNodeView *) nodeView location: (CGPoint) location;
- (void) startCreateNodeFromNode: (TFNodeView *) node location: (CGPoint) location;
- (void) updateCreateNodeAtLocation: (CGPoint) location;
- (void) endCreateNode;
- (void) selectNode: (TFNodeView *) nodeView;
- (void) disableLayerAnimations;
- (void) setupNodeView: (TFNodeView *) nodeView;
- (CALayer *) createLineSublayer;
@end