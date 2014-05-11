//
// Created by Dani Postigo on 5/11/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "MindmapController+UIPinch.h"
#import "TFNodeView+Utils.h"
#import "TFNode.h"
#import "MindmapController+LineDrawing.h"

@implementation MindmapController (UIPinch)

- (void) updatePinchWithScale: (CGFloat) scale {
    for (TFNodeView *node in self.nodeViews) {
        CGPoint originalPoint = node.node.position;

        CGPoint endPoint = CGPointMake(60 + 10, self.view.height - TFNodeViewHeight - 10);
        //        if (!node.selected) {
        //            NSUInteger index = [nodeContainerView.subviews indexOfObject: node];
        //            endPoint.x += (index * 2);
        //            endPoint.y -= (index * 2);
        //
        //        }

        CGFloat distanceX = originalPoint.x - endPoint.x;
        CGFloat distanceY = fabsf(endPoint.y - originalPoint.y);
        distanceY = originalPoint.y - endPoint.y;
        CGPoint newPoint = CGPointMake(originalPoint.x - (distanceX * scale), originalPoint.y - (distanceY * scale));

        node.left = newPoint.x;
        node.top = newPoint.y;
    }

    [self redrawLines];
}

- (void) mindmapDidCompletePinch {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self performSegueWithIdentifier: @"MinimizedSegue" sender: nil];
}

@end