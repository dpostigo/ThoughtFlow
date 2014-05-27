//
// Created by Dani Postigo on 5/6/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "MindmapController+NodeUtils.h"
#import "TFNodeView.h"
#import "UIView+DPConstraints.h"
#import "TFNode.h"
#import "UIView+DPKit.h"
#import "UIView+DPKitChildren.h"
#import "Model.h"
#import "Project.h"
#import "PanningView.h"
#import "MindmapController+LineDrawing.h"

CGFloat DistanceBetweenTwoPoints(CGPoint point1, CGPoint point2) {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx * dx + dy * dy);
};

@implementation MindmapController (NodeUtils)

- (void) startNodeMove: (TFNodeView *) node location: (CGPoint) location {

    node.selected = YES;
    CGFloat springVelocity = (-0.1 * 30.0) / (node.frame.origin.x - location.x);

    [UIView animateWithDuration: 1.0 delay: 0.0
            usingSpringWithDamping: 0.9f
            initialSpringVelocity: springVelocity
            options: UIViewAnimationOptionCurveEaseOut
            animations: ^{
                node.center = [self constrainNodeCenter: node forLocation: location];;
                [self updateLineMove: node location: location animated: YES];
            }
            completion: ^(BOOL completion) {

            }];

    [self optimizeNodeViews];

}

- (void) updateNodeMove: (TFNodeView *) node location: (CGPoint) location {
    node.center = [self constrainNodeCenter: node forLocation: location];
    [self updateLineMove: node location: node.center animated: NO];
}

- (void) endNodeMove: (TFNodeView *) node location: (CGPoint) location {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    location = [self constrainNodeCenter: node forLocation: location];
    location = CGPointMake(location.x - (node.width / 2), location.y - (node.height / 2));
    [node updateSuperLeadingConstraint: location.x];
    [node updateSuperTopConstraint: location.y];
    node.node.position = location;

    [self.view setNeedsUpdateConstraints];
    [self updateLineMove: node location: node.center animated: NO];

    [UIView animateWithDuration: 0.4
            animations: ^{
                [self.view layoutIfNeeded];
            }
            completion: ^(BOOL completion) {
                //                [self deselectOtherNodes: node];
            }];

    [self unoptimizeNodeViews];
    //    [self updateLastNode];

}

- (CGPoint) constrainNodeCenter: (TFNodeView *) node forLocation: (CGPoint) location {

    CGPoint ret = node.center;
    //    return location;

    CGRect boundingRect = CGRectMake(self.view.left + 60, self.view.top, self.view.width - 60, self.view.height);
    boundingRect = CGRectInset(boundingRect, 10, 10);

    CGRect nodeFrame = node.frame;
    nodeFrame.origin.x = location.x - (node.width / 2);
    nodeFrame.origin.y = location.y - (node.height / 2);

    CGRect smallerBounds = CGRectInset(boundingRect, 10, 10);
    if (CGRectContainsRect(smallerBounds, nodeFrame)) {
        ret = location;
    } else {
        //    NSLog(@"CGRectGetMinY(nodeFrame) = %f", CGRectGetMinY(nodeFrame));
        //    NSLog(@"CGRectGetMaxY(nodeFrame) = %f", CGRectGetMaxY(nodeFrame));

        //    NSLog(@"CGRectGetMinY(boundingRect) = %f", CGRectGetMinY(boundingRect));
        //    NSLog(@"CGRectGetMaxY(boundingRect) = %f", CGRectGetMaxY(boundingRect));

        //    CGFloat nodeRight = CGRectGetMaxX(nodeFrame);
        //    NSLog(@"nodeRight = %f", nodeRight);

        if (CGRectGetMinY(nodeFrame) > CGRectGetMinY(boundingRect) && CGRectGetMaxY(nodeFrame) < CGRectGetMaxY(
                boundingRect)) {
            ret.y = location.y;
        }

        if (CGRectGetMinX(nodeFrame) > CGRectGetMinX(boundingRect) && CGRectGetMaxX(nodeFrame) < CGRectGetMaxX(
                boundingRect)) {
            ret.x = location.x;
        }

    }

    return ret;

}

#pragma mark Lines

- (void) setLayerLine: (CALayer *) layer fromPoint: (CGPoint) a toPoint: (CGPoint) b {
    [self setLayerLine: layer fromPoint: a toPoint: b animated: NO];
}

- (void) setLayerLine: (CALayer *) layer fromPoint: (CGPoint) a toPoint: (CGPoint) b animated: (BOOL) flag {

    CGFloat lineWidth = 0.5;
    CGPoint center = {0.5 * (a.x + b.x), 0.5 * (a.y + b.y)};
    CGFloat length = (CGFloat) sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));
    CGFloat angle = (CGFloat) atan2(a.y - b.y, a.x - b.x);

    if (flag) {


        //        layer.delegate = nil;
    } else {

    }

    layer.position = center;
    layer.bounds = (CGRect) {{0, 0}, {length + lineWidth, lineWidth}};
    layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1);

}


- (void) updateLineMove: (TFNodeView *) node location: (CGPoint) location animated: (BOOL) flag {
    if ([self.nodeViews count] == 1) return;

    NSUInteger index = [self.nodeViews indexOfObject: node];

    if (index == 0) {
        [self drawLineForIndex: 1];
    } else {
        [self drawLineForIndex: index];
        if (index < [self.nodeViews count]) {
            [self drawLineForIndex: index + 1];
        }
    }

}


- (void) updateLineAtIndex: (NSUInteger) previousIndex location: (CGPoint) location animated: (BOOL) flag {
    TFNodeView *previousNode = [self.nodeViews objectAtIndex: previousIndex];
    CALayer *layer = [lineView.layer.sublayers objectAtIndex: previousIndex];
    [self setLayerLine: layer fromPoint: previousNode.center toPoint: location];

}

- (void) updateLineForNodeView: (TFNodeView *) nodeView location: (CGPoint) location {
    //    NSUInteger index = [self.nodeViews indexOfObject: nodeView];
    //    CALayer *layer = [lineView.layer.sublayers objectAtIndex: index];
    CALayer *layer = [lineView.layer.sublayers lastObject];
    layer.hidden = NO;
    [self setLayerLine: layer fromPoint: nodeView.center toPoint: location];
}


#pragma mark Creation

- (void) startCreateNodeFromNode: (TFNodeView *) node location: (CGPoint) location {

    tempLine = [self createLineSublayer];
    tempLine.hidden = YES;

    self.creationNode.center = location;
    self.creationNode.alpha = 0;
    self.creationNode.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [nodeContainerView addSubview: self.creationNode];
    [node setNodeState: TFNodeViewStateNormal animated: YES];

    [UIView animateWithDuration: 0.4 animations: ^{
        self.creationNode.alpha = 0.8;
        self.creationNode.transform = CGAffineTransformIdentity;
    }];

    [self updateLineForNodeView: currentNodeView location: self.creationNode.center];
}

- (void) updateCreateNodeAtLocation: (CGPoint) location {
    CGFloat distance = DistanceBetweenTwoPoints(self.creationNode.center, currentNodeView.center);
    self.creationNode.alpha = fmaxf(distance / 200, 1);
    self.creationNode.center = location;
    [self updateLineForNodeView: currentNodeView location: self.creationNode.center];

    //        CGFloat distance = DistanceBetweenTwoPoints(self.creationNode.center, currentNodeView.center);
    //        self.creationNode.alpha = fmaxf(distance / 200, 1);
    //        self.creationNode.center = location;
    //        setLayerToLineFromAToB(lineView.layer, self.creationNode.center, currentNodeView.center, 1);

}


- (void) endCreateNode {
    [tempLine removeFromSuperlayer];
    tempLine = nil;

    TFNode *projectNode = [[TFNode alloc] initWithTitle: @""];
    TFNodeView *newNodeView = [self instantiateNodeViewForNode: projectNode];
    newNodeView.selected = YES;

    [self performSegueWithIdentifier: @"EditModalSegue" sender: nil];

    [UIView animateWithDuration: 0.4
            animations: ^{
                self.creationNode.alpha = 0;
            }
            completion: ^(BOOL finished) {
                if (self.creationNode.superview) {
                    [self.creationNode removeFromSuperview];
                }
                [self updateLastNode];
            }];

}

- (TFNodeView *) instantiateNodeViewForNode: (TFNode *) projectNode {
    [_model.selectedProject addNode: projectNode];
    _model.selectedNode = projectNode;

    TFNodeView *ret = [[TFNodeView alloc] init];
    ret.node = projectNode;
    //    ret.center = self.creationNode.center;
    ret.frame = [self frameForNewNode];
    ret.node.position = ret.origin;

    [self setupNodeView: ret];
    [self drawLineForIndex: [self.nodeViews count] - 1];

    return ret;
}

- (CGRect) frameForNewNode {
    CGRect ret = self.creationNode.frame;

    for (TFNodeView *node in self.nodeViews) {
        CGRect nodeFrame = node.frame;
        if (CGRectIntersectsRect(ret, nodeFrame)) {

        }
    }

    return ret;
}


#pragma mark Utils

- (void) updateLastNode {
    //    int count = [self.nodeViews count];
    //    for (int j = 0; j < count; j++) {
    //        TFNodeView *node = [self.nodeViews objectAtIndex: j];
    //        //        node.optimized = j != count - 1;
    //        if (j == count - 1) {
    //            node.optimized = NO;
    //        } else {
    //            node.optimized = YES;
    //        }
    //    }
}

#pragma mark Selection

- (void) deselectOtherNodes: (TFNodeView *) nodeView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    for (TFNodeView *node in self.nodeViews) {
        if (node != nodeView) {
            node.selected = NO;
        }
    }
}

- (TFNodeView *) selectedNode {
    for (TFNodeView *node in self.nodeViews) {
        if (node.selected) {
            return node;
        }
    }
    return nil;
}


#pragma mark Layers

- (void) enableLayerAnimations: (TFNodeView *) nodeView {
    NSUInteger index = [self.nodeViews indexOfObject: nodeView];
    CALayer *layer = [lineView.layer.sublayers objectAtIndex: index];
    layer.delegate = nil;
    //    for (CALayer *layer in lineView.layer.sublayers) {
    //        layer.delegate = nil;
    //    }
}

- (void) disableLayerAnimations {
    for (CALayer *layer in lineView.layer.sublayers) {
        layer.delegate = self;
    }
}

#pragma mark Setup

- (void) setupNodeView: (TFNodeView *) nodeView {

    NSLog(@"%s", __PRETTY_FUNCTION__);
    [nodeContainerView addSubview: nodeView];
    [self.nodeViews addObject: nodeView];
    nodeView.delegate = self;

    // Gestures
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(nodeViewDidLongPress:)];
    gesture.minimumPressDuration = 0.25;
    [nodeView addGestureRecognizer: gesture];

    // Lines
    [self createLineSublayer];
}


- (CALayer *) createLineSublayer {
    CALayer *sublayer = [CALayer new];
    sublayer.backgroundColor = [UIColor colorWithWhite: 0.5 alpha: 1.0].CGColor;
    //    sublayer.delegate = self;
    sublayer.contents = nil;
    //    sublayer.opacity = 0.5;
    sublayer.opaque = YES;
    sublayer.speed = 3.0;
    sublayer.allowsEdgeAntialiasing = YES;
    [lineView.layer addSublayer: sublayer];
    return sublayer;
}

#pragma mark Performance

- (void) optimizeNodeViews {
    for (TFNodeView *node in self.nodeViews) {
        node.optimized = YES;
        [node rasterize];
    }
}

- (void) unoptimizeNodeViews {
    for (TFNodeView *node in self.nodeViews) {
        node.optimized = NO;
        [node rasterize];
    }
}

- (void) enableNodeUpdate {
    for (TFNodeView *node in self.nodeViews) {
        node.nodeUpdateDisabled = NO;
    }
}

- (void) disableNodeUpdate {
    for (TFNodeView *node in self.nodeViews) {
        node.nodeUpdateDisabled = YES;
    }
}

@end