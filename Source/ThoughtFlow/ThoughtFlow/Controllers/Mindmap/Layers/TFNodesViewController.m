//
// Created by Dani Postigo on 6/16/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-UIView/UIView+DPConstraints.h>
#import "TFNodesViewController.h"
#import "TFNode.h"
#import "UIView+DPKit.h"
#import "TFNodeView.h"
#import "TFNewNodeView.h"
#import "DPPassThroughView.h"


@interface TFNodesViewController ()

@property(nonatomic) BOOL isPinched;
@end

@implementation TFNodesViewController {
    TFNodeViewState _lastNodeState;
    TFNodeView *currentNodeView;
}

CGFloat Distance(CGPoint point1, CGPoint point2) {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return (CGFloat) sqrt(dx * dx + dy * dy);
}

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {

        self.view = [[DPPassThroughView alloc] init];
        _nodeViews = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];

}



#pragma mark - Setters

- (void) setRootNode: (TFNode *) rootNode {
    _rootNode = rootNode;
    NSArray *array = [self nodeViewsForNodes: @[_rootNode] parent: nil];


    self.nodeViews = [array mutableCopy];

}

- (void) setNodes: (NSArray *) nodes {
    if (_nodes != nodes) {
        _nodes = nodes;
        self.nodeViews = [[self nodeViewsForNodes: _nodes] mutableCopy];
    }
}


- (void) setNodeViews: (NSMutableArray *) nodeViews {
    if (_nodeViews) {
        [_nodeViews enumerateObjectsUsingBlock: ^(UIView *node, NSUInteger index, BOOL *stop) {
            [node removeFromSuperview];
        }];
        [_nodeViews removeAllObjects];
    }

    _nodeViews = nodeViews;

    [self.view setNeedsUpdateConstraints];
    [self _notifyControllerDidUpdateViews];
}

#pragma mark - Public

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


#pragma mark - TFNodeView setup

- (NSArray *) nodeViewsForNodes: (NSArray *) nodes parent: (TFNodeView *) parentView {
    NSMutableArray *ret = [[NSMutableArray alloc] init];

    for (int j = 0; j < [nodes count]; j++) {
        TFNode *node = nodes[j];
        TFNodeView *nodeView = [[TFNodeView alloc] initWithNode: node];
        nodeView.parentView = parentView;
        [ret addObject: nodeView];
        [self addNodeView: nodeView forNode: node];

        if ([node.children count] > 0) {
            [ret addObjectsFromArray: [self nodeViewsForNodes: node.children parent: nodeView]];
        }
    }

    return ret;

}

- (NSArray *) nodeViewsForNodes: (NSArray *) nodes {

    NSMutableArray *ret = [[NSMutableArray alloc] init];
    [nodes enumerateObjectsUsingBlock: ^(TFNode *node, NSUInteger index, BOOL *stop) {

        TFNodeView *nodeView = [[TFNodeView alloc] initWithNode: node];
        [self addNodeView: nodeView forNode: node];
        [ret addObject: nodeView];

    }];
    return ret;

}


- (void) addNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node {
    [self.view addSubview: nodeView];
    nodeView.delegate = self;
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
}


#pragma mark - TFNodeViewDelegate

- (void) nodeViewDidDoubleTap: (TFNodeView *) nodeView {
    [self _notifyControllerDidDoubleTapNode: nodeView.node];

}


- (void) nodeViewDidTriggerRelated: (TFNodeView *) node {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidTapRelated:forNode:)]) {
        [_delegate nodesControllerDidTapRelated: node forNode: node.node];
    }
}


- (void) nodeViewDidChangeSelection: (TFNodeView *) node {
    [self deselectOtherNodes: node];
    [self _notifyControllerDidSelectNode: node.node];
}


- (void) nodeViewDidTriggerDeletion: (TFNodeView *) node {

    [self _notifyControllerDidDeleteNode: node.node];
}


- (void) selectFirstNodeView {
    if ([_nodeViews count] > 0) {
        TFNodeView *firstNodeView = _nodeViews[0];
        [self selectNodeView: firstNodeView];
    }
}


- (void) selectNodeView: (TFNodeView *) nodeView {
    nodeView.selected = YES;
    [self deselectOtherNodes: nodeView];
}

- (void) deselectOtherNodes: (TFNodeView *) nodeView {
    for (TFNodeView *node in _nodeViews) {
        if (node != nodeView) {
            node.selected = NO;
        }
    }
    _selectedNodeView = nodeView;
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



#pragma mark - Pinch


- (void) startPinchWithScale: (CGFloat) scale {
    [self _notifyDidBeginPinchingNodeView: _selectedNodeView];

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

    [self _notifyDidUpdatePinchingNodeView: _selectedNodeView];

}

- (void) endPinchWithScale: (CGFloat) scale {
    if (scale == 1.0) {
        self.isPinched = YES;
        [self _notifyDidCompletePinchWithNodeView: _selectedNodeView];
        [self _notifyDidEndPinchingNodeView: _selectedNodeView];
    } else {
        [self unpinch];

    }
}


- (void) unpinch {
    //    [self assignDelegate: nil];
    //    [lineView.layer setSublayerSpeed: 0.5];

    [self resetNodeConstraints];
    //    [nodeContainerView setNeedsUpdateConstraints];

    [UIView animateWithDuration: 0.4
            delay: 0.0
            usingSpringWithDamping: 0.6
            initialSpringVelocity: 2.0
            options: UIViewAnimationOptionCurveLinear
            animations: ^{
                [self.view layoutIfNeeded];
                [self _notifyDidUpdatePinchingNodeView: _selectedNodeView];
            }
            completion: ^(BOOL finished) {

                [self _notifyDidEndPinchingNodeView: _selectedNodeView];
            }];

}

- (void) resetNodeConstraints {
    for (TFNodeView *nodeView in self.nodeViews) {
        [nodeView updateSuperTopConstraint: nodeView.node.position.y];
        [nodeView updateSuperLeadingConstraint: nodeView.node.position.x];
    }
}


#pragma mark - Notify - nodes
#pragma mark - Notify

- (void) _notifyControllerDidUpdateViews {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidUpdateViews:)]) {
        [_delegate nodesControllerDidUpdateViews: _nodeViews];
    }
}


- (void) _notifyControllerDidDoubleTapNode: (TFNode *) node {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidDoubleTapNode:)]) {
        [_delegate nodesControllerDidDoubleTapNode: node];
    }
}


- (void) _notifyControllerDidSelectNode: (TFNode *) node {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidSelectNode:)]) {
        [_delegate nodesControllerDidSelectNode: node];
    }
}

- (void) _notifyControllerDidDeleteNode: (TFNode *) node {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidDeleteNode:)]) {
        [_delegate nodesControllerDidDeleteNode: node];
    }
}

#pragma mark - Notify Moving

- (void) _notifyControllerDidBeginMovingNodeView: (TFNodeView *) nodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidBeginMovingNodeView:forNode:)]) {
        [_delegate nodesControllerDidBeginMovingNodeView: nodeView forNode: nodeView.node];
    }
}

- (void) _notifyControllerDidUpdateMovingNodeView: (TFNodeView *) nodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidUpdateMovingNodeView:forNode:)]) {
        [_delegate nodesControllerDidUpdateMovingNodeView: nodeView forNode: nodeView.node];
    }
}

- (void) _notifyControllerDidEndMovingNodeView: (TFNodeView *) nodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidEndMovingNodeView:forNode:)]) {
        [_delegate nodesControllerDidEndMovingNodeView: nodeView forNode: nodeView.node];
    }
}


#pragma mark - Notify Creation

- (void) _notifyControllerDidBeginCreatingNodeView: (TFNodeView *) nodeView withParent: (TFNodeView *) parentNodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidBeginCreatingNodeView:withParent:)]) {
        [_delegate nodesControllerDidBeginCreatingNodeView: nodeView withParent: parentNodeView];
    }
}

- (void) _notifyControllerDidUpdateCreatingNodeView: (TFNodeView *) nodeView withParent: (TFNodeView *) parentNodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidUpdateCreatingNodeView:withParent:)]) {
        [_delegate nodesControllerDidUpdateCreatingNodeView: nodeView withParent: parentNodeView];
    }
}

- (void) _notifyControllerDidEndCreateNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidEndCreatingNodeView:forNode:)]) {
        [_delegate nodesControllerDidEndCreatingNodeView: nodeView forNode: node];
    }
}

- (void) _notifyControllerDidCreateNode: (TFNode *) node withRoot: (TFNode *) rootNode {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidCreateNode:withRoot:)]) {
        [_delegate nodesControllerDidCreateNode: node withRoot: rootNode];
    }
}


#pragma mark - Notify pinch

- (void) _notifyDidBeginPinchingNodeView: (TFNodeView *) nodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidBeginPinchingNodeView:forNode:)]) {
        [_delegate nodesControllerDidBeginPinchingNodeView: nodeView forNode: nodeView.node];
    }
}

- (void) _notifyDidUpdatePinchingNodeView: (TFNodeView *) nodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidUpdatePinchWithNodeView:forNode:)]) {
        [_delegate nodesControllerDidUpdatePinchWithNodeView: nodeView forNode: nodeView.node];
    }
}

- (void) _notifyDidEndPinchingNodeView: (TFNodeView *) nodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidEndPinchingNodeView:forNode:)]) {
        [_delegate nodesControllerDidEndPinchingNodeView: nodeView forNode: nodeView.node];
    }
}


- (void) _notifyDidCompletePinchWithNodeView: (TFNodeView *) nodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidCompletePinchWithNodeView:forNode:)]) {
        [_delegate nodesControllerDidCompletePinchWithNodeView: nodeView forNode: nodeView.node];
    }
}

@end