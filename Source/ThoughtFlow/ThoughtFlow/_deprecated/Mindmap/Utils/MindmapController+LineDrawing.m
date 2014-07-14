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


- (void) redrawLinesWithConstraints {

    for (TFNodeView *node in self.nodeViews) {

    }
}
- (void) drawLineForIndex: (int) j {
    if (j < [self.nodeViews count]) {
        TFNodeView *nodeView = [self.nodeViews objectAtIndex: j];
        TFNodeView *previousView = [self.nodeViews objectAtIndex: j - 1];

        CALayer *layer = [lineView.layer.sublayers objectAtIndex: j];
        [self setLayerLine: layer fromPoint: nodeView.center toPoint: previousView.center];
    }
}


#pragma mark Layer delegate

- (void) assignDelegate: (id) sender {
    [lineView.layer.sublayers enumerateObjectsUsingBlock: ^(CALayer *layer, NSUInteger idx, BOOL *stop) {
        layer.delegate = sender;
    }];
}

@end