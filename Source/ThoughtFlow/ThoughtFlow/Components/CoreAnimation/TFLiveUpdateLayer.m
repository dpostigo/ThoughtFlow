//
// Created by Dani Postigo on 7/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFLiveUpdateLayer.h"
#import "TFNode.h"
#import "TFLayer.h"
#import "CALayer+SublayerUtils.h"
#import "TFBaseNodeView.h"
#import "CALayer+TFUtils.h"


@implementation TFLiveUpdateLayer

- (void) setNodeViews: (NSArray *) nodeViews {
    _nodeViews = nodeViews;
    [self removeAllSublayers];
    if (_nodeViews && [_nodeViews count] > 0) {
        TFBaseNodeView *nodeView = nodeViews[0];
        for (int j = 1; j < [nodeViews count]; j++) {
            nodeView = nodeViews[j];

            if (nodeView.parentView) {
                TFLayer *sublayer = [TFLayer layer];
                sublayer.backgroundColor = _lineColor.CGColor;
                sublayer.frame = self.bounds;
                sublayer.delegate = self;
                [self addSublayer: sublayer];
                [sublayer setLineFromPoint: nodeView.center toPoint: nodeView.parentView.center];
            }

        }
    }
}


- (NSArray *) pointsForRootNode: (TFNode *) parentNode {
    NSMutableArray *ret = [[NSMutableArray alloc] init];

    NSArray *children = [parentNode children];
    for (int j = 0; j < [children count]; j++) {
        TFNode *child = children[j];
        [ret addObject: @{@"startPoint" : [NSValue valueWithCGPoint: parentNode.center], @"endPoint" : [NSValue valueWithCGPoint: parentNode.center]}];

        if ([child.children count] > 0) {
            [ret addObjectsFromArray: [self pointsForRootNode: child]];
        }
    }

    return ret;

}


#pragma mark - CALayer delegate

- (id <CAAction>) actionForLayer: (CALayer *) layer forKey: (NSString *) event {
    return (id) [NSNull null]; // disable all implicit animations
}
@end