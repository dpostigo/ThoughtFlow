//
// Created by Dani Postigo on 5/11/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import <CALayer-DPUtils/CALayer+SublayerUtils.h>
#import "MindmapController+UIPinch.h"
#import "TFNodeView+Utils.h"
#import "TFNode.h"
#import "MindmapController+LineDrawing.h"
#import "UIView+DPConstraints.h"
#import "MindmapController+NodeUtils.h"
#import "PanningView.h"
#import "MindmapController+NodePositioning.h"

@implementation MindmapController (UIPinch)

- (void) startPinchWithScale: (CGFloat) scale {
    [self disableNodeUpdate];
}


- (void) updatePinchWithScale: (CGFloat) scale {
    for (TFNodeView *node in self.nodeViews) {
        CGPoint originalPoint = node.node.position;

        CGPoint endPoint = CGPointMake(10, self.view.height - TFNodeViewHeight - 10);
        //        if (!node.selected) {
        //            NSUInteger index = [nodeContainerView.subviews indexOfObject: node];
        //            endPoint.x += (index * 2);
        //            endPoint.y -= (index * 2);
        //        }

        CGFloat distanceX = originalPoint.x - endPoint.x;
        CGFloat distanceY = fabsf(endPoint.y - originalPoint.y);
        distanceY = originalPoint.y - endPoint.y;
        CGPoint newPoint = CGPointMake(originalPoint.x - (distanceX * scale), originalPoint.y - (distanceY * scale));

        [node updateSuperTopConstraint: newPoint.y];
        [node updateSuperLeadingConstraint: newPoint.x];
    }

    [self redrawLines];
}


- (void) endPinchWithScale: (CGFloat) scale {
    NSLog(@"scale = %f", scale);
    if (scale == 1.0) {
        isPinched = YES;
        [self mindmapDidCompletePinch];
    } else {
        [self unpinch];

    }
}

- (void) unpinch {
    [self assignDelegate: nil];
    [lineView.layer setSublayerSpeed: 0.5];

    [self resetNodeConstraints];
    [nodeContainerView setNeedsUpdateConstraints];

    [UIView animateWithDuration: 0.4 animations: ^{
        [nodeContainerView layoutIfNeeded];
        [self redrawLines];
        //            [self resetNodeLocations];

    } completion: ^(BOOL completion) {
        [self enableNodeUpdate];
        [lineView.layer setSublayerSpeed: 3.0];
    }];
}

- (void) mindmapDidCompletePinch {
    [self.navigationController pushViewController: self.minimizedController animated: NO];
}

- (UIViewController *) minimizedController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"MinimizedLayerController"];
}

@end