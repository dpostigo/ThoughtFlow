//
// Created by Dani Postigo on 6/16/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"

@class TFNode;
@class TFNodeView;

@interface MindmapLinesController : TFViewController

//@property(nonatomic, strong) NSArray *nodes;

//@property(nonatomic, strong) NSArray *nodeViews;
@property(nonatomic, strong) TFNode *rootNode;
@property(nonatomic, strong) CALayer *mainLayer;
@property(nonatomic, strong) CALayer *updateLayer;
@property(nonatomic, strong) CALayer *tempLayer;
@property(nonatomic, strong) UIColor *lineColor;
- (void) targetNode: (TFNode *) targetNode;
- (void) updateTargetNode: (TFNode *) targetNode withNodeView: (TFNodeView *) nodeView;
- (void) endTargetNode;
- (void) updateTempLineFromPoint: (CGPoint) a toPoint: (CGPoint) b;
@end