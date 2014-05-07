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

CGFloat DistanceBetweenTwoPoints(CGPoint point1, CGPoint point2) {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx * dx + dy * dy);
};

@implementation MindmapController (NodeUtils)

- (void) startNodeMove: (TFNodeView *) node location: (CGPoint) location {
    CGFloat springVelocity = (-0.1 * 30.0) / (node.frame.origin.x - location.x);

    //    layerAnimationEnabled = YES;
    //    [self enableLayerAnimations: node];

    [UIView animateWithDuration: 1.0 delay: 0.0
         usingSpringWithDamping: 0.9f
          initialSpringVelocity: springVelocity
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         node.center = location;
                         [self updateLineMove: node location: location animated: YES];
                     }
                     completion: ^(BOOL completion) {
                         //                         layerAnimationEnabled = NO;
                         //                         [self disableLayerAnimations];

                     }];

}

- (void) updateNodeMove: (TFNodeView *) node location: (CGPoint) location {
    node.center = location;
    [self updateLineMove: node location: location animated: NO];
}


- (void) endNodeMove: (TFNodeView *) node location: (CGPoint) location {
    location = CGPointMake(location.x - (node.width / 2), location.y - (node.height / 2));
    [node updateSuperLeadingConstraint: location.x];
    [node updateSuperTopConstraint: location.y];
    node.node.position = location;
    [self.view setNeedsUpdateConstraints];

    [UIView animateWithDuration: 0.4
                     animations: ^{
                         [self.view layoutIfNeeded];
                         //                             node.transform = CGAffineTransformIdentity;
                     }
                     completion: nil];

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
    [self.view addSubview: self.creationNode];
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
    [self selectNode: newNodeView];


    [self performSegueWithIdentifier: @"EditModalSegue" sender: nil];

    [UIView animateWithDuration: 0.4
                     animations: ^{
                         self.creationNode.alpha = 0;
                     }
                     completion: ^(BOOL finished) {
                         if (self.creationNode.superview) {
                             [self.creationNode removeFromSuperview];
                         }
                     }];

}

- (TFNodeView *) instantiateNodeViewForNode: (TFNode *) projectNode {
    [_model.selectedProject addNode: projectNode];
    _model.selectedNode = projectNode;

    TFNodeView *ret = [[TFNodeView alloc] init];
    ret.node = projectNode;
    ret.center = self.creationNode.center;
    ret.node.position = ret.origin;

    [self setupNodeView: ret];
    [self drawLineForIndex: [self.nodeViews count] - 1];

    return ret;
}

#pragma mark Selection

- (void) selectNode: (TFNodeView *) nodeView {
    NSArray *nodes = [self.view childrenOfClass: [TFNodeView class]];
    for (TFNodeView *node in nodes) {
        if (node != nodeView) {
            node.selected = NO;
        }
    }
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
    [nodeContainerView addSubview: nodeView];
    [self.nodeViews addObject: nodeView];
    nodeView.delegate = self;

    // Gestures
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(nodeViewDidLongPress:)];
    gesture.minimumPressDuration = 0.1;
    [nodeView addGestureRecognizer: gesture];

    // Lines
    [self createLineSublayer];
}


- (CALayer *) createLineSublayer {
    CALayer *sublayer = [CALayer new];
    sublayer.backgroundColor = [UIColor whiteColor].CGColor;
    //    sublayer.delegate = self;
    sublayer.contents = nil;
    sublayer.opacity = 0.5;
    sublayer.speed = 3.0;
    sublayer.allowsEdgeAntialiasing = YES;
    [lineView.layer addSublayer: sublayer];
    return sublayer;
}

@end