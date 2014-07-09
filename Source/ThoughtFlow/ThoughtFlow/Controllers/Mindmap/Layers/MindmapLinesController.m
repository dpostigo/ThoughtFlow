//
// Created by Dani Postigo on 6/16/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <NSObject+AutoDescription/NSObject+AutoDescription.h>
#import "MindmapLinesController.h"
#import "TFLayer.h"
#import "CALayer+SublayerUtils.h"
#import "TFNode.h"
#import "TFNodeView.h"
#import "DPPassThroughView.h"
#import "TFLiveUpdateLayer.h"


@interface MindmapLinesController ()

@property(nonatomic, strong) CALayer *updateLayer;
@property(nonatomic, strong) CALayer *mainLayer;
@property(nonatomic, strong) CALayer *tempLayer;
@end

@implementation MindmapLinesController {
    NSArray *_affectedNodes;
}

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {

        self.view = [[DPPassThroughView alloc] init];

        _lineColor = [UIColor colorWithWhite: 0.5 alpha: 1.0];

        _mainLayer = [CALayer layer];
        _mainLayer.frame = self.view.bounds;
        [self.view.layer addSublayer: _mainLayer];

        _updateLayer = [CALayer layer];
        _updateLayer.frame = self.view.bounds;
        [self.view.layer addSublayer: _updateLayer];

        _tempLayer = [TFLayer layer];
        _tempLayer.frame = self.view.bounds;
        _tempLayer.backgroundColor = _lineColor.CGColor;
        _tempLayer.hidden = YES;
        [self.view.layer addSublayer: _tempLayer];

        _liveLayer = [TFLiveUpdateLayer layer];
        _liveLayer.frame = self.view.bounds;
        _liveLayer.lineColor = [UIColor redColor];
        //        _liveLayer.hidden = YES;
        _liveLayer.delegate = self;
        [self.view.layer addSublayer: _liveLayer];
    }

    return self;
}

#pragma mark - View lifecycle


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    [_mainLayer setNeedsDisplay];
}

- (void) viewWillDisappear: (BOOL) animated {
    [super viewWillDisappear: animated];

    _liveLayer.nodeViews = nil;
    _liveLayer.delegate = nil;
}


- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setupView];

    _mainLayer.frame = self.view.bounds;

}


- (void) setRootNode: (TFNode *) rootNode {
    if (_rootNode) [_mainLayer removeAllSublayers];
    _rootNode = rootNode;

    [self enumerateParentNode: _rootNode];

    _tempLayer.hidden = YES;

}


- (void) enumerateParentNode: (TFNode *) parentNode {

    [parentNode.children enumerateObjectsUsingBlock: ^(TFNode *child, NSUInteger index, BOOL *stop) {
        TFLayer *sublayer = [TFLayer layer];
        sublayer.backgroundColor = _lineColor.CGColor;
        sublayer.frame = self.view.bounds;
        [_mainLayer addSublayer: sublayer];
        [self setLayerLine: sublayer fromPoint: child.center toPoint: parentNode.center];

        //        NSLog(@"Drew  %@ to %@", NSStringFromCGPoint(child.center), NSStringFromCGPoint(parentNode.center));

        if ([child.children count] > 0) {
            [self enumerateParentNode: child];
        }
    }];
}




#pragma mark - Pinch

- (void) startPinchWithNodeViews: (NSArray *) nodeViews {
    _mainLayer.hidden = YES;
    _liveLayer.nodeViews = nodeViews;
    _liveLayer.hidden = NO;
}


- (void) updatePinchWithNodeViews: (NSArray *) nodeViews {
    _liveLayer.nodeViews = nodeViews;

}

- (void) endPinchWithNodeViews: (NSArray *) nodeViews {
    _mainLayer.hidden = NO;
    _liveLayer.hidden = YES;
    _liveLayer.nodeViews = nil;
}

#pragma mark - Move targeted node

- (void) startTargetNode: (TFNode *) targetNode {

    _affectedNodes = [self affectedNodesForNode: targetNode];

    [_updateLayer removeAllSublayers];
    [_mainLayer removeAllSublayers];
    [self enumerateLayers: _rootNode excludingNodes: _affectedNodes];

    [_updateLayer setSublayerDelegate: self];

    NSLog(@"_affectedNodes = %@", _affectedNodes);

}

- (void) updateTargetNode: (TFNode *) targetNode withNodeView: (TFNodeView *) nodeView {

    //    if (targetNode.parentNode == nil ) {
    //        return;
    //    }

    for (int j = 0; j < [_affectedNodes count]; j++) {

        TFNode *child = _affectedNodes[j];
        TFLayer *sublayer = [_updateLayer.sublayers objectAtIndex: j];
        //        NSLog(@"sublayer = %@", sublayer);
        //        NSLog(@"child = %@", child);
        //        NSLog(@"targetNode = %@", targetNode);
        //        NSLog(@"targetNode.parentNode = %@", targetNode.parentNode);

        if (child == targetNode) {
            if (targetNode.parentNode != nil) {
                [self setLayerLine: sublayer fromPoint: nodeView.center toPoint: targetNode.parentNode.center];
            }
        }

        else if ([targetNode.children containsObject: child]) {
            [self setLayerLine: sublayer fromPoint: child.center toPoint: nodeView.center];

        }
    }

    //
    //    [_affectedNodes enumerateObjectsUsingBlock: ^(TFNode *child, NSUInteger index, BOOL *stop) {
    //
    //        TFLayer *sublayer = [_updateLayer.sublayers objectAtIndex: index];
    //        NSLog(@"sublayer = %@", sublayer);
    //
    //        if (child == targetNode && targetNode.parentNode) {
    //            [self setLayerLine: sublayer fromPoint: nodeView.center toPoint: targetNode.parentNode.center];
    //        }
    //
    //        else if ([targetNode.children containsObject: child]) {
    //            [self setLayerLine: sublayer fromPoint: child.center toPoint: nodeView.center];
    //
    //        }
    //    }];

}


- (void) endTargetNode {

    [_updateLayer removeAllSublayers];

}

- (void) enumerateLayers: (TFNode *) parentNode excludingNodes: (NSArray *) exclude {

    [parentNode.children enumerateObjectsUsingBlock: ^(TFNode *child, NSUInteger index, BOOL *stop) {

        TFLayer *sublayer = [TFLayer layer];
        sublayer.frame = self.view.bounds;

        if ([exclude containsObject: child]) {
            [_updateLayer addSublayer: sublayer];
            sublayer.backgroundColor = [UIColor yellowColor].CGColor;
            [self setLayerLine: sublayer fromPoint: child.center toPoint: parentNode.center];

        } else {
            [_mainLayer addSublayer: sublayer];
            sublayer.backgroundColor = _lineColor.CGColor;
            [self setLayerLine: sublayer fromPoint: child.center toPoint: parentNode.center];
        }

        if ([child.children count] > 0) {
            [self enumerateLayers: child excludingNodes: exclude];
        }
    }];
}


- (NSArray *) affectedNodesForNode: (TFNode *) node {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    if (node.parentNode) {
        [ret addObject: node];
    } else {
        NSLog(@"No parent node.");

    }
    [ret addObjectsFromArray: node.children];
    return ret;
}

- (NSArray *) affectedLayersForTargetedNode: (TFNode *) targetNode inNode: (TFNode *) parentNode {

    __block TFNode *targetedNode = targetNode;
    [parentNode.children enumerateObjectsUsingBlock: ^(TFNode *child, NSUInteger index, BOOL *stop) {
        TFLayer *sublayer = [_mainLayer.sublayers objectAtIndex: index];

        if (child == targetedNode) {

            NSLog(@"child.title = %@", child.title);
            NSLog(@"targetedNode.title = %@", targetedNode.title);
            sublayer.backgroundColor = [UIColor yellowColor].CGColor;
        }

        if ([child.children count] > 0) {
            [self affectedLayersForTargetedNode: targetedNode inNode: child];
        }
    }];

    //
    //    NSMutableArray *ret = [[NSMutableArray alloc] init];
    //
    //    [parentNode.children enumerateObjectsUsingBlock: ^(TFNode *child, NSUInteger index, BOOL *stop) {
    //        TFLayer *sublayer = [_mainLayer.sublayers objectAtIndex: index];
    //
    //        if ([targetNode.children count] == 0) {
    //
    //            BOOL shouldAdd = NO;
    //            if (child == targetNode) {
    //                sublayer.backgroundColor = [UIColor yellowColor].CGColor;
    //            } else if (child == targetNode.parent) {
    //
    //                //                TFNode *parentNode = child.parent;
    //
    //                //                shouldAdd = YES;
    //            }
    //
    //            if (shouldAdd) {
    //                [ret addObject: sublayer];
    //            }
    //        } else {
    //
    //            if (child == targetNode || child == targetNode.parent || child.parent == targetNode) {
    //                //                [ret addObject: sublayer];
    //            } else {
    //
    //                if ([child.parent isKindOfClass: [TFNode class]]) {
    //                    TFNode *parentNode = child.parent;
    //
    //                }
    //
    //            }
    //
    //        }
    //
    //        [ret addObjectsFromArray: [self affectedLayersForTargetedNode: targetNode inNode: child]];
    //
    //    }];

    return nil;
}


- (void) drawLineForIndex: (int) j {
    //    if (j < [self.nodeViews count]) {
    //        TFNodeView *nodeView = [self.nodeViews objectAtIndex: j];
    //        TFNodeView *previousView = [self.nodeViews objectAtIndex: j - 1];
    //
    //        CALayer *layer = [lineView.layer.sublayers objectAtIndex: j];
    //        [self setLayerLine: layer fromPoint: nodeView.center toPoint: previousView.center];
    //    }
}



#pragma mark - Move node

- (void) startMoveWithNodeView: (TFNodeView *) nodeView withParent: (TFNodeView *) parentNodeView {
    [self updateTempLineFromPoint: nodeView.center toPoint: parentNodeView.center];
    _tempLayer.hidden = NO;
}

- (void) updateTempLineFromPoint: (CGPoint) a toPoint: (CGPoint) b {
    [self setLayerLine: _tempLayer fromPoint: a toPoint: b];
}

- (void) endMoveWithNodeView: (TFNodeView *) nodeView withParent: (TFNodeView *) parentNodeView {
    //    [self updateTempLineFromPoint: nodeView.center toPoint: parentNodeView.center];
    _tempLayer.hidden = YES;
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


#pragma mark - Private

- (void) _setupView {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
}

#pragma mark - CALayer delegate


- (id <CAAction>) actionForLayer: (CALayer *) layer forKey: (NSString *) event {
    return (id) [NSNull null]; // disable all implicit animations
}
@end