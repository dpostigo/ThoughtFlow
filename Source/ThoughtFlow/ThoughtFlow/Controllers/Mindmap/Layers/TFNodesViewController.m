//
// Created by Dani Postigo on 6/16/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-UIView/UIView+DPConstraints.h>
#import <NSObject+AutoDescription/NSObject+AutoDescription.h>
#import "TFNodesViewController.h"
#import "TFNode.h"
#import "UIView+DPKit.h"
#import "TFNodeView.h"
#import "TFNewNodeView.h"
#import "Model.h"

@implementation TFNodesViewController {
    TFNodeViewState _lastNodeState;
    TFNodeView *currentNodeView;
}

CGFloat Distance(CGPoint point1, CGPoint point2) {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return (CGFloat) sqrt(dx * dx + dy * dy);
}

@synthesize delegate;

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        _nodeViews = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];

}


- (void) setNodes: (NSArray *) nodes {
    if (_nodes != nodes) {
        if (_nodes) {
            [_nodeViews enumerateObjectsUsingBlock: ^(UIView *node, NSUInteger index, BOOL *stop) {
                [node removeFromSuperview];
            }];
            [_nodeViews removeAllObjects];
        }

        _nodes = nodes;

        [_nodes enumerateObjectsUsingBlock: ^(TFNode *node, NSUInteger index, BOOL *stop) {

            TFNodeView *nodeView = [[TFNodeView alloc] init];
            nodeView.node = node;
            nodeView.delegate = self;
            [self.view addSubview: nodeView];
            nodeView.left = node.position.x;
            nodeView.top = node.position.y;
            nodeView.translatesAutoresizingMaskIntoConstraints = NO;

            [self.view addConstraints: @[
                    [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNewNodeViewWidth],
                    [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNewNodeViewWidth],
                    [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.topLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: node.position.y],
                    [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: node.position.x]
            ]];

            UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(nodeViewDidLongPress:)];
            recognizer.minimumPressDuration = 0.15;
            [nodeView addGestureRecognizer: recognizer];
            [_nodeViews addObject: nodeView];

        }];

        [self.view setNeedsUpdateConstraints];
        [self _notifyControllerDidUpdateViews];

    }
}


- (void) centerFirstNode {
    //    TFNodeView *nodeView = [_nodeViews objectAtIndex: 0];
    //    [self.view removeConstraintsAffectingItem: nodeView];
    //
    //
    //    [self.view addConstraints: @[
    //            [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNewNodeViewWidth],
    //            [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNewNodeViewWidth],
    //            [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.topLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: ((self.view.height - TFNodeViewHeight) / 2)],
    //            [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: ((self.view.width - TFNodeViewWidth) / 2)]
    //    ]];

    TFNodeView *nodeView = [_nodeViews objectAtIndex: 0];
    [self.view removeConstraintsAffectingItem: nodeView];
    nodeView.centerX = self.view.width / 2;
    nodeView.centerY = self.view.height / 2;

    [self.view addConstraints: @[
            [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNewNodeViewWidth],
            [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNewNodeViewWidth],
            [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeCenterX multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeCenterY multiplier: 1.0 constant: 0.0]
    ]];
}


#pragma mark - TFNodeViewDelegate

- (void) nodeViewDidDoubleTap: (TFNodeView *) nodeView {
    [self _notifyControllerDidDoubleTapNode: nodeView.node];

}



#pragma mark Node Interaction

- (void) nodeViewDidLongPress: (UILongPressGestureRecognizer *) gesture {

    TFNodeView *node = (TFNodeView *) gesture.view;

    if (gesture.state == UIGestureRecognizerStateBegan) {
        _lastNodeState = node.nodeState;
    }

    switch (_lastNodeState) {
        case TFNodeViewStateNormal :
            [self moveNodeViewWithGesture: gesture];
            break;

        case TFNodeViewStateCreate :
            [self createNodeViewWithLongPress: gesture];
            break;

        default :
            break;
    }
}

- (void) moveNodeViewWithGesture: (UILongPressGestureRecognizer *) gesture {
    TFNodeView *node = (TFNodeView *) gesture.view;
    CGPoint location = [gesture locationInView: node.superview];

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan :
            [self startNodeMove: node location: location];
            break;

        case UIGestureRecognizerStateChanged :
            [self updateNodeMove: node location: location];
            break;

        case UIGestureRecognizerStateEnded :
            [self endNodeMove: node location: location];
            break;

        default :
            break;
    }
}



#pragma mark - Move

- (void) startNodeMove: (TFNodeView *) node location: (CGPoint) location {

    node.selected = YES;
    CGFloat springVelocity = (-0.1 * 30.0) / (node.frame.origin.x - location.x);

    [UIView animateWithDuration: 1.0 delay: 0.0
            usingSpringWithDamping: 0.9f
            initialSpringVelocity: springVelocity
            options: UIViewAnimationOptionCurveEaseOut
            animations: ^{
                node.center = [self constrainNodeCenter: node forLocation: location];;
                //                [self updateLineMove: node location: location animated: YES];
            }
            completion: ^(BOOL completion) {

            }];

    //    [self optimizeNodeViews];

    [self _notifyControllerDidBeginMovingNodeView: node];

}

- (void) updateNodeMove: (TFNodeView *) node location: (CGPoint) location {
    node.center = [self constrainNodeCenter: node forLocation: location];
    //    [self updateLineMove: node location: node.center animated: NO];

    [self _notifyControllerDidUpdateMovingNodeView: node];
}

- (void) endNodeMove: (TFNodeView *) node location: (CGPoint) location {
    location = [self constrainNodeCenter: node forLocation: location];
    location = CGPointMake(location.x - (node.width / 2), location.y - (node.height / 2));
    [node updateSuperLeadingConstraint: location.x];

    NSLayoutConstraint *topConstraint = [node superTopGuideConstraint];
    if (topConstraint == nil) {

    } else {
        topConstraint.constant = location.y;
    }

    //    [node updateSuperTopConstraint: location.y];


    node.node.position = location;

    [self.view setNeedsUpdateConstraints];
    //    [self updateLineMove: node location: node.center animated: NO];

    [UIView animateWithDuration: 0.4
            animations: ^{
                [self.view layoutIfNeeded];
            }
            completion: ^(BOOL completion) {
            }];

    //    [self unoptimizeNodeViews];
    //    [self updateLastNode];

    [self _notifyControllerDidEndMovingNodeView: node];

}

- (CGPoint) constrainNodeCenter: (TFNodeView *) node forLocation: (CGPoint) location {

    CGPoint ret = node.center;
    //    return location;

    CGRect boundingRect;
    boundingRect = CGRectMake(self.view.left + 60, self.view.top, self.view.width - 60, self.view.height);
    boundingRect = self.view.bounds;
    boundingRect = CGRectInset(boundingRect, 10, 10);

    CGRect nodeFrame = node.frame;
    nodeFrame.origin.x = location.x - (node.width / 2);
    nodeFrame.origin.y = location.y - (node.height / 2);

    CGRect smallerBounds = CGRectInset(boundingRect, 10, 10);
    if (CGRectContainsRect(smallerBounds, nodeFrame)) {
        ret = location;
    } else {

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



#pragma mark - Creation


- (void) createNodeViewWithLongPress: (UILongPressGestureRecognizer *) gesture {
    TFNodeView *node = (TFNodeView *) gesture.view;
    CGPoint location = [gesture locationInView: self.view];
    currentNodeView = node;

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan :
            [self startCreateNodeFromNode: node location: location];
            break;

        case UIGestureRecognizerStateChanged :
            [self updateCreateNodeAtLocation: location];
            break;

        case UIGestureRecognizerStateEnded :
            [self endCreateNode];
            break;

        default :
            break;
    }
}


- (void) startCreateNodeFromNode: (TFNodeView *) node location: (CGPoint) location {

    _creationNodeView = [TFNodeView greenGhostView];
    _creationNodeView.center = location;
    _creationNodeView.alpha = 0;
    _creationNodeView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [self.view addSubview: _creationNodeView];
    [node setNodeState: TFNodeViewStateNormal animated: YES];

    [UIView animateWithDuration: 0.4 animations: ^{
        _creationNodeView.alpha = 0.8;
        _creationNodeView.transform = CGAffineTransformIdentity;
    }];

    // TODO :
    [self _notifyControllerDidBeginCreatingNodeView: _creationNodeView withParent: currentNodeView];
    //    [self updateLineForNodeView: currentNodeView location: self.creationNodeView.center];
}

- (void) updateCreateNodeAtLocation: (CGPoint) location {
    CGFloat distance = Distance(_creationNodeView.center, currentNodeView.center);
    _creationNodeView.alpha = fmaxf(distance / 200, 1);
    _creationNodeView.center = location;

    [self _notifyControllerDidUpdateCreatingNodeView: _creationNodeView withParent: currentNodeView];

    // TODO :
    //    [self updateLineForNodeView: currentNodeView location: self.creationNodeView.center];

    // not todo:
    //        CGFloat distance = DistanceBetweenTwoPoints(self.creationNodeView.center, currentNodeView.center);
    //        self.creationNodeView.alpha = fmaxf(distance / 200, 1);
    //        self.creationNodeView.center = location;
    //        setLayerToLineFromAToB(lineView.layer, self.creationNodeView.center, currentNodeView.center, 1);

}


- (void) endCreateNode {
    // TODO : Implement in LinesLayer
    //    [tempLine removeFromSuperlayer];
    //    tempLine = nil;

    TFNode *node = [[TFNode alloc] initWithTitle: @""];
    node.position = CGPointMake(_creationNodeView.left, _creationNodeView.top);

    TFNodeView *newNodeView = [self instantiateNodeViewForNode: node];
    newNodeView.selected = YES;

    [UIView animateWithDuration: 0.4
            animations: ^{
                _creationNodeView.alpha = 0;
            }
            completion: ^(BOOL finished) {
                if (_creationNodeView.superview) {
                    [_creationNodeView removeFromSuperview];
                }
                // TODO:
                //                [self updateLastNode];

                //                self.nodes = [self.nodes arrayByAddingObject: node];
            }];

    [self _notifyControllerDidEndCreateNodeView: newNodeView forNode: node];
    [self _notifyControllerDidCreateNode: node withRoot: currentNodeView.node];

}

- (TFNodeView *) instantiateNodeViewForNode: (TFNode *) projectNode {
    // TODO: Reimplement
    //    [_model.selectedProject addNode: projectNode];
    //    _model.selectedNode = projectNode;

    TFNodeView *ret = [[TFNodeView alloc] init];
    ret.node = projectNode;
    //    ret.center = self.creationNodeView.center;
    // TODO:
    //    ret.frame = [self frameForNewNode];
    //    ret.node.position = ret.origin;


    // TODO :
    //    [self setupNodeView: ret];
    //    [self drawLineForIndex: [self.nodeViews count] - 1];

    return ret;
}

//- (CGRect) frameForNewNode {
//    CGRect ret = self.creationNodeView.frame;
//
//    for (TFNodeView *node in self.nodeViews) {
//        CGRect nodeFrame = node.frame;
//        if (CGRectIntersectsRect(ret, nodeFrame)) {
//
//        }
//    }
//
//    return ret;
//}



#pragma mark - Notify

- (void) _notifyControllerDidUpdateViews {
    if (delegate && [delegate respondsToSelector: @selector(nodesControllerDidUpdateViews:)]) {
        [delegate nodesControllerDidUpdateViews: _nodeViews];
    }
}


- (void) _notifyControllerDidDoubleTapNode: (TFNode *) node {
    if (delegate && [delegate respondsToSelector: @selector(nodesControllerDidDoubleTapNode:)]) {
        [delegate nodesControllerDidDoubleTapNode: node];
    }
}


#pragma mark - Moving


- (void) _notifyControllerDidBeginMovingNodeView: (TFNodeView *) nodeView {
    if (delegate && [delegate respondsToSelector: @selector(nodesControllerDidBeginMovingNodeView:forNode:)]) {
        [delegate nodesControllerDidBeginMovingNodeView: nodeView forNode: nodeView.node];
    }
}


- (void) _notifyControllerDidUpdateMovingNodeView: (TFNodeView *) nodeView {
    if (delegate && [delegate respondsToSelector: @selector(nodesControllerDidUpdateMovingNodeView:forNode:)]) {
        [delegate nodesControllerDidUpdateMovingNodeView: nodeView forNode: nodeView.node];
    }
}


- (void) _notifyControllerDidEndMovingNodeView: (TFNodeView *) nodeView {
    if (delegate && [delegate respondsToSelector: @selector(nodesControllerDidEndMovingNodeView:forNode:)]) {
        [delegate nodesControllerDidEndMovingNodeView: nodeView forNode: nodeView.node];
    }
}


#pragma mark - Creation

- (void) _notifyControllerDidBeginCreatingNodeView: (TFNodeView *) nodeView withParent: (TFNodeView *) parentNodeView {
    if (delegate && [delegate respondsToSelector: @selector(nodesControllerDidBeginCreatingNodeView:withParent:)]) {
        [delegate nodesControllerDidBeginCreatingNodeView: nodeView withParent: parentNodeView];
    }
}

- (void) _notifyControllerDidUpdateCreatingNodeView: (TFNodeView *) nodeView withParent: (TFNodeView *) parentNodeView {
    if (delegate && [delegate respondsToSelector: @selector(nodesControllerDidUpdateCreatingNodeView:withParent:)]) {
        [delegate nodesControllerDidUpdateCreatingNodeView: nodeView withParent: parentNodeView];
    }
}

- (void) _notifyControllerDidEndCreateNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node {
    if (delegate && [delegate respondsToSelector: @selector(nodesControllerDidEndCreatingNodeView:forNode:)]) {
        [delegate nodesControllerDidEndCreatingNodeView: nodeView forNode: node];
    }
}


- (void) _notifyControllerDidCreateNode: (TFNode *) node withRoot: (TFNode *) rootNode {
    if (delegate && [delegate respondsToSelector: @selector(nodesControllerDidCreateNode:withRoot:)]) {
        [delegate nodesControllerDidCreateNode: node withRoot: rootNode];
    }
}


@end