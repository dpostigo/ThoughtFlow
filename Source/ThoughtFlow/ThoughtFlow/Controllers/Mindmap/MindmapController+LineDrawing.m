//
// Created by Dani Postigo on 5/11/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "MindmapController+LineDrawing.h"
#import "TFNodeView+Utils.h"
#import "MindmapController+NodeUtils.h"

@implementation MindmapController (LineDrawing)

- (void) redrawLines {
    if ([self.nodeViews count] > 1) {
        for (int j = 1; j < [self.nodeViews count]; j++) {
            [self drawLineForIndex: j];
        }
    }
}


- (void) drawLineForIndex: (int) j {
    if (j < [self.nodeViews count]) {
        TFNodeView *nodeView = [self.nodeViews objectAtIndex: j];
        TFNodeView *previousView = [self.nodeViews objectAtIndex: j - 1];

        CALayer *layer = [lineView.layer.sublayers objectAtIndex: j];
        [self setLayerLine: layer fromPoint: nodeView.center toPoint: previousView.center];

        //        TFNodeView *nodeView = [self.nodeViews objectAtIndex: j];
        //        TFNodeView *previousView = [self.nodeViews objectAtIndex: j - 1];
        //        CALayer *layer = [lineView.layer.sublayers objectAtIndex: j];
        //        [self setLayerLine: layer
        //                 fromPoint: CGPointMake(nodeView.node.position.x + TFNodeViewWidth,
        //                         nodeView.node.position.y + TFNodeViewHeight)
        //                   toPoint: CGPointMake(
        //                           previousView.node.position.x + TFNodeViewWidth,
        //                           previousView.node.position.y + TFNodeViewHeight)];

        //        TFNode *node = [[self.nodeViews objectAtIndex: j] node];
        //        TFNode *previousNode = [[self.nodeViews objectAtIndex: j - 1] node];
        //        CALayer *layer = [lineView.layer.sublayers objectAtIndex: j];
        //        [self setLayerLine: layer
        //                 fromPoint: CGPointMake(node.position.x + TFNodeViewWidth,
        //                         node.position.y + TFNodeViewHeight)
        //                   toPoint: CGPointMake(
        //                           previousNode.position.x + TFNodeViewWidth,
        //                           previousNode.position.y + TFNodeViewHeight)];
    }
}


#pragma mark Layer delegate

- (void) assignDelegate: (id) sender {
    [lineView.layer.sublayers enumerateObjectsUsingBlock: ^(CALayer *layer, NSUInteger idx, BOOL *stop) {
        layer.delegate = sender;
    }];
}

@end