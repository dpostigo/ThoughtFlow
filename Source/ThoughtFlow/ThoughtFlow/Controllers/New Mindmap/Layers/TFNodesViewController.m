//
// Created by Dani Postigo on 6/16/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-UIView/UIView+DPConstraints.h>
#import <BlocksKit/UIGestureRecognizer+BlocksKit.h>
#import "TFNodesViewController.h"
#import "TFNode.h"
#import "UIView+DPKit.h"
#import "TFNewNodeView.h"
#import "DPPassThroughView.h"


@interface TFNodesViewController ()

@property(nonatomic) BOOL isPinched;
@property(nonatomic, strong) UIView *creationNodeView;
@property(nonatomic, strong) Class nodeClass;
@end

@implementation TFNodesViewController {
    TFNodeViewState _lastNodeState;
    TFBaseNodeView *currentNodeView;
}

CGFloat Distance(CGPoint point1, CGPoint point2) {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return (CGFloat) sqrt(dx * dx + dy * dy);
}

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        _nodeClass = [TFNewNodeView class];
        _nodeViews = [[NSMutableArray alloc] init];
    }

    return self;
}


#pragma mark - View lifecycle

- (void) loadView {
    self.view = [[DPPassThroughView alloc] init];
}

- (void) viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] bk_initWithHandler: ^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        NSLog(@"location = %@", NSStringFromCGPoint(location));

    }];
    tap.numberOfTouchesRequired = 1;
    //    tap.delegate = self;
    [self.view addGestureRecognizer: tap];

}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

}



#pragma mark - Public

- (void) removeNodeView: (TFBaseNodeView *) nodeView {
    NSMutableArray *nodeViews = [_nodeViews mutableCopy];
    [nodeViews removeObject: nodeView];
    _nodeViews = nodeViews;
}

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

    if (self.view.superview) {
        UIView *superview = self.view.superview;


        TFBaseNodeView *nodeView = [_nodeViews objectAtIndex: 0];
        NSArray *constraints = [self.view constraintsAffectingItem: nodeView];
        [self.view removeConstraints: constraints];

        nodeView.centerX = (superview.width - nodeView.width) / 2;
        nodeView.centerY = (superview.height - nodeView.height) / 2;

        [self.view addConstraints: @[
                [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNodeViewWidth],
                [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNodeViewHeight],
                [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.topLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: nodeView.left],
                [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: nodeView.top]
        ]];
    } else {

        NSLog(@"No superview.");

    }


    //    [self.view addConstraints: @[
    //            [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNodeViewWidth],
    //            [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNodeViewHeight],
    //            [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeCenterX multiplier: 1.0 constant: 0.0],
    //            [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeCenterY multiplier: 1.0 constant: 0.0]
    //    ]];
}


#pragma mark - TFNodeView setup

- (NSArray *) nodeViewsForNodes: (NSArray *) nodes parent: (TFBaseNodeView *) parentView {
    NSMutableArray *ret = [[NSMutableArray alloc] init];

    for (int j = 0; j < [nodes count]; j++) {
        TFNode *node = nodes[j];
        TFBaseNodeView *nodeView = [[_nodeClass alloc] initWithNode: node];
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
        TFBaseNodeView *nodeView = [self instantiateNodeViewForNode: node];

        [ret addObject: nodeView];

    }];
    return ret;

}


- (TFBaseNodeView *) instantiateNodeViewForNode: (TFNode *) node {
    TFBaseNodeView *nodeView = [[_nodeClass alloc] initWithNode: node];
    [self addNodeView: nodeView forNode: node];
    return nodeView;
}

- (void) addNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node {
    [self.view addSubview: nodeView];
    nodeView.delegate = self;
    nodeView.left = node.position.x;
    nodeView.top = node.position.y;
    nodeView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addConstraints: @[
            [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNodeViewWidth],
            [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNodeViewHeight],
            [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.topLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: node.position.y],
            [NSLayoutConstraint constraintWithItem: nodeView attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: node.position.x]
    ]];

    [self _setupGesturesForNodeView: nodeView];

}


- (void) _setupGesturesForNodeView: (TFNewNodeView *) view {

    UILongPressGestureRecognizer *createRecognizer = [[UILongPressGestureRecognizer alloc] bk_initWithHandler: ^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [self createNodeViewWithLongPress: (UILongPressGestureRecognizer *) sender];
    }];
    createRecognizer.delegate = self;
    createRecognizer.minimumPressDuration = 0.2;
    [view addGestureRecognizer: createRecognizer];

    UILongPressGestureRecognizer *moveRecognizer = [[UILongPressGestureRecognizer alloc] bk_initWithHandler: ^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        TFBaseNodeView *node = (TFBaseNodeView *) sender.view;
        [self moveNodeViewWithGesture: (UILongPressGestureRecognizer *) sender];
    }];
    moveRecognizer.delegate = self;
    moveRecognizer.minimumPressDuration = 0.1;
    //    [moveRecognizer requireGestureRecognizerToFail: view.horizontalPan];
    [view addGestureRecognizer: moveRecognizer];

}


- (BOOL) gestureRecognizerShouldBegin: (UIGestureRecognizer *) gestureRecognizer {
    if ([gestureRecognizer isKindOfClass: [UILongPressGestureRecognizer class]]) {
        UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *) gestureRecognizer;

        TFBaseNodeView *nodeView = (TFBaseNodeView *) gestureRecognizer.view;

        NSLog(@"nodeView.nodeState = %d", nodeView.nodeState);
        if (longPress.minimumPressDuration == 0.1) {
            return nodeView.nodeState == TFNodeViewStateNormal;
        }
        if (longPress.minimumPressDuration == 0.2) {
            return nodeView.nodeState == TFNodeViewStateCreate;
        }
    }

    return YES;
}

#pragma mark - TFNodeViewDelegate


- (void) nodeViewDidDoubleTap: (TFBaseNodeView *) nodeView {
    [self _notifyControllerDidDoubleTapNode: nodeView.node];

}


- (void) nodeViewDidTriggerRelated: (TFBaseNodeView *) node {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidTapRelated:forNode:)]) {
        [_delegate nodesControllerDidTapRelated: node forNode: node.node];
    }
}


- (void) nodeViewDidChangeSelection: (TFBaseNodeView *) node {
    [self deselectOtherNodes: node];
    [self _notifyControllerDidSelectNode: node.node];
}


- (void) nodeViewDidTriggerDeletion: (TFBaseNodeView *) nodeView {
    [self _notifyControllerDidDeleteNode: nodeView.node withNodeView: nodeView];
}


- (void) selectFirstNodeView {
    if ([_nodeViews count] > 0) {
        TFBaseNodeView *firstNodeView = _nodeViews[0];
        [self selectNodeView: firstNodeView];
    }
}

- (void) selectNodeView: (TFBaseNodeView *) nodeView {
    nodeView.selected = YES;
    [self deselectOtherNodes: nodeView];
}

- (void) deselectOtherNodes: (TFBaseNodeView *) nodeView {
    for (TFBaseNodeView *node in _nodeViews) {
        if (node != nodeView) {
            node.selected = NO;
        }
    }
    _selectedNodeView = nodeView;
}

#pragma mark Node Interaction

- (void) nodeViewDidLongPress: (UILongPressGestureRecognizer *) gesture {

    TFBaseNodeView *node = (TFBaseNodeView *) gesture.view;

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
    TFBaseNodeView *node = (TFBaseNodeView *) gesture.view;
    CGPoint location = [gesture locationInView: node.superview];

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan :
            [self startNodeMove: node location: location];
            break;

        case UIGestureRecognizerStateChanged : {
            [self updateNodeMove: node location: location velocity: 0];
        }

            break;

        case UIGestureRecognizerStateEnded :
            [self endNodeMove: node location: location];
            break;

        default :
            break;
    }
}

#pragma mark - Move

- (void) startNodeMove: (TFBaseNodeView *) node location: (CGPoint) location {

    //    node.selected = YES;
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

- (void) updateNodeMove: (TFBaseNodeView *) node location: (CGPoint) location velocity: (CGFloat) velocity {
    node.center = [self constrainNodeCenter: node forLocation: location];
    //    [self updateLineMove: node location: node.center animated: NO];

    [self _notifyControllerDidUpdateMovingNodeView: node];
}

- (void) endNodeMove: (TFBaseNodeView *) node location: (CGPoint) location {
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


- (CGPoint) constrainNodeCenter: (TFBaseNodeView *) node forLocation: (CGPoint) location {

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
    TFBaseNodeView *node = (TFBaseNodeView *) gesture.view;
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

- (void) startCreateNodeFromNode: (TFBaseNodeView *) node location: (CGPoint) location {

    _creationNodeView = [TFBaseNodeView greenGhostView];
    _creationNodeView.center = location;
    _creationNodeView.alpha = 0;
    _creationNodeView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    _creationNodeView.userInteractionEnabled = NO;
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

    TFBaseNodeView *newNodeView = [self instantiateNodeViewForNode: node];
    //    newNodeView.selected = YES;
    //    newNodeView.transform = CGAffineTransformMakeScale(0.9, 0.9);


    [self.view exchangeSubviewAtIndex: [self.view.subviews indexOfObject: newNodeView]
            withSubviewAtIndex: [self.view.subviews indexOfObject: _creationNodeView]];

    //    _creationNodeView.translatesAutoresizingMaskIntoConstraints = NO;
    //    [_creationNodeView updateSuperLeadingConstraint: _creationNodeView.left];
    //    [_creationNodeView updateSuperTopConstraint: _creationNodeView.top];

    [UIView animateWithDuration: 0.4
            animations: ^{
                _creationNodeView.alpha = 0;

            }
            completion: ^(BOOL finished) {
                if (_creationNodeView.superview) {
                    [_creationNodeView removeFromSuperview];
                }

                [newNodeView removeFromSuperview];

                NSLog(@"_creationNodeView = %@", _creationNodeView);

                [self _notifyControllerDidEndCreateNodeView: newNodeView forNode: node];
                [self _notifyControllerDidCreateNode: node withRoot: currentNodeView.node];

            }];

}






#pragma mark - Pinch


- (void) startPinchWithScale: (CGFloat) scale {

    NSLayoutConstraint *widthConstraint = self.view.staticWidthConstraint;
    [self _notifyDidBeginPinchingNodeView: _selectedNodeView];

}

- (void) updatePinchWithScale: (CGFloat) scale {
    for (TFBaseNodeView *node in self.nodeViews) {
        CGPoint originalPoint = node.node.position;

        CGPoint endPoint = _pinchEndPoint;
        if (CGPointEqualToPoint(endPoint, CGPointZero)) {
            //            endPoint = CGPointMake(10, self.view.height - TFNodeViewHeight - 10);
        }

        //        if (!node.selected) {
        //            NSUInteger index = [nodeContainerView.subviews indexOfObject: node];
        //            endPoint.x += (index * 2);
        //            endPoint.y -= (index * 2);
        //        }

        CGFloat distanceX = originalPoint.x - endPoint.x;
        CGFloat distanceY = fabsf(endPoint.y - originalPoint.y);
        distanceY = originalPoint.y - endPoint.y;
        CGPoint newPoint = CGPointMake(originalPoint.x - (distanceX * scale), originalPoint.y - (distanceY * scale));


        NSLayoutConstraint *topConstraint = [node superTopConstraint];

        if (topConstraint) {
            topConstraint.constant = newPoint.y;

        } else {
            NSLog(@"node.node.title = %@", node.node.title);
        }

        NSLayoutConstraint *leadingConstraint = [node superLeadingConstraint];
        if (leadingConstraint) {
            [node updateSuperLeadingConstraint: newPoint.x];
        } else {
            NSLog(@"node.node.title = %@", node.node.title);
        }

        //        NSLog(@"newPoint = %@", NSStringFromCGPoint(newPoint));
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
    for (TFBaseNodeView *nodeView in self.nodeViews) {
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

- (void) _notifyControllerDidDeleteNode: (TFNode *) node withNodeView: (TFBaseNodeView *) nodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidDeleteNode:withNodeView:)]) {
        [_delegate nodesControllerDidDeleteNode: node withNodeView: nodeView];
    }
}

#pragma mark - Notify Moving

- (void) _notifyControllerDidBeginMovingNodeView: (TFBaseNodeView *) nodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidBeginMovingNodeView:forNode:)]) {
        [_delegate nodesControllerDidBeginMovingNodeView: nodeView forNode: nodeView.node];
    }
}

- (void) _notifyControllerDidUpdateMovingNodeView: (TFBaseNodeView *) nodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidUpdateMovingNodeView:forNode:)]) {
        [_delegate nodesControllerDidUpdateMovingNodeView: nodeView forNode: nodeView.node];
    }
}

- (void) _notifyControllerDidEndMovingNodeView: (TFBaseNodeView *) nodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidEndMovingNodeView:forNode:)]) {
        [_delegate nodesControllerDidEndMovingNodeView: nodeView forNode: nodeView.node];
    }
}


#pragma mark - Notify Creation

- (void) _notifyControllerDidBeginCreatingNodeView: (TFBaseNodeView *) nodeView withParent: (TFBaseNodeView *) parentNodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidBeginCreatingNodeView:withParent:)]) {
        [_delegate nodesControllerDidBeginCreatingNodeView: nodeView withParent: parentNodeView];
    }
}

- (void) _notifyControllerDidUpdateCreatingNodeView: (TFBaseNodeView *) nodeView withParent: (TFBaseNodeView *) parentNodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidUpdateCreatingNodeView:withParent:)]) {
        [_delegate nodesControllerDidUpdateCreatingNodeView: nodeView withParent: parentNodeView];
    }
}

- (void) _notifyControllerDidEndCreateNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node {
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

- (void) _notifyDidBeginPinchingNodeView: (TFBaseNodeView *) nodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidBeginPinchingNodeView:forNode:)]) {
        [_delegate nodesControllerDidBeginPinchingNodeView: nodeView forNode: nodeView.node];
    }
}

- (void) _notifyDidUpdatePinchingNodeView: (TFBaseNodeView *) nodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidUpdatePinchWithNodeView:forNode:)]) {
        [_delegate nodesControllerDidUpdatePinchWithNodeView: nodeView forNode: nodeView.node];
    }
}

- (void) _notifyDidEndPinchingNodeView: (TFBaseNodeView *) nodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidEndPinchingNodeView:forNode:)]) {
        [_delegate nodesControllerDidEndPinchingNodeView: nodeView forNode: nodeView.node];
    }
}


- (void) _notifyDidCompletePinchWithNodeView: (TFBaseNodeView *) nodeView {
    if (_delegate && [_delegate respondsToSelector: @selector(nodesControllerDidCompletePinchWithNodeView:forNode:)]) {
        [_delegate nodesControllerDidCompletePinchWithNodeView: nodeView forNode: nodeView.node];
    }
}

@end