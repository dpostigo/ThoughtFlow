//
// Created by Dani Postigo on 6/16/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFLinesViewController.h"
#import "TFLayer.h"
#import "CALayer+SublayerUtils.h"
#import "TFNode.h"
#import "DPPassThroughView.h"
#import "TFLiveUpdateLayer.h"
#import "TFBaseNodeView.h"
#import "CALayer+TFUtils.h"


@interface TFLinesViewController ()

@property(nonatomic) BOOL masksLines;
@property(nonatomic, strong) CALayer *updateLayer;
@property(nonatomic, strong) CALayer *mainLayer;
@property(nonatomic, strong) CALayer *tempLayer;
@property(nonatomic, strong) TFLiveUpdateLayer *liveLayer;
@property(nonatomic, strong) CALayer *testLayer;
@end

@implementation TFLinesViewController {
    NSArray *_affectedNodes;
}

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {

        _masksLines = NO;
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
        _liveLayer.lineColor = _lineColor;
        _liveLayer.delegate = self;
        [self.view.layer addSublayer: _liveLayer];

        if (_masksLines) {
            _testLayer = self.view.layer;
            _testLayer.opaque = NO;
        }
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
    _mainLayer.delegate = nil;
}


- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setupView];

    _mainLayer.frame = self.view.bounds;

}


- (void) updateLayerWithNodeViews: (NSArray *) nodeViews {
    if (_masksLines) {
        // create the mask that will be applied to the layer on top of the yellow background
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.fillRule = kCAFillRuleEvenOdd;
        maskLayer.frame = _testLayer.frame;

        CGMutablePathRef p1 = CGPathCreateMutable();
        CGPathAddPath(p1, nil, CGPathCreateWithRect(maskLayer.bounds, nil));

        for (int j = 0; j < [nodeViews count]; j++) {
            TFBaseNodeView *view = nodeViews[j];
            CGPathAddPath(p1, nil, CGPathCreateWithRect(view.frame, nil));
        }

        maskLayer.path = p1;
        _testLayer.mask = maskLayer;

        CGPathRelease(p1);
    }
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

        //        [sublayer setLineFromPoint: child.center toPoint: parentNode.center];
        [sublayer setLineFromRect: child.rect toRect: parentNode.rect];

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

    _mainLayer.delegate = self;
    _mainLayer.hidden = NO;
    _liveLayer.hidden = YES;
    _liveLayer.nodeViews = nil;
    _mainLayer.delegate = nil;
}

#pragma mark - Move targeted node

- (void) startTargetNode: (TFNode *) targetNode {

    _affectedNodes = [self affectedNodesForNode: targetNode];

    [_updateLayer removeAllSublayers];
    [_mainLayer removeAllSublayers];
    [self enumerateLayers: _rootNode excludingNodes: _affectedNodes];

    [_updateLayer setSublayerDelegate: self];

}

- (void) updateTargetNode: (TFNode *) targetNode withNodeView: (TFBaseNodeView *) nodeView {

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
                [sublayer setLineFromRect: nodeView.frame toRect: targetNode.parentNode.rect];
                //                [sublayer setLineFromPoint: nodeView.center toPoint: targetNode.parentNode.center];
                //                [self setLayerLine: sublayer fromPoint: nodeView.center toPoint: targetNode.parentNode.center];
            }
        }

        else if ([targetNode.children containsObject: child]) {
            [sublayer setLineFromRect: child.rect toRect: nodeView.frame];
            //            [sublayer setLineFromPoint: child.center toPoint: nodeView.center];

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
            sublayer.backgroundColor = [UIColor whiteColor].CGColor;
            //            [sublayer setLineFromPoint: child.center toPoint: parentNode.center];
            [sublayer setLineFromRect: child.rect toRect: parentNode.rect];

        } else {
            [_mainLayer addSublayer: sublayer];
            sublayer.backgroundColor = _lineColor.CGColor;
            //            [sublayer setLineFromPoint: child.center toPoint: parentNode.center];
            [sublayer setLineFromRect: child.rect toRect: parentNode.rect];
            //            [self setLayerLine: sublayer fromPoint: child.center toPoint: parentNode.center];
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
            sublayer.backgroundColor = [UIColor whiteColor].CGColor;
        }

        if ([child.children count] > 0) {
            [self affectedLayersForTargetedNode: targetedNode inNode: child];
        }
    }];

    return nil;
}



#pragma mark - Move node

- (void) startMoveWithNodeView: (TFBaseNodeView *) nodeView withParent: (TFBaseNodeView *) parentNodeView {
    [self updateTempLineFromPoint: nodeView.center toPoint: parentNodeView.center];
    _tempLayer.hidden = NO;
}

- (void) updateTempLineFromPoint: (CGPoint) a toPoint: (CGPoint) b {
    [_tempLayer setLineFromPoint: a toPoint: b];
}

- (void) endMoveWithNodeView: (TFBaseNodeView *) nodeView withParent: (TFBaseNodeView *) parentNodeView {
    //    [self updateTempLineFromPoint: nodeView.center toPoint: parentNodeView.center];
    _tempLayer.hidden = YES;
}


#pragma mark Lines


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