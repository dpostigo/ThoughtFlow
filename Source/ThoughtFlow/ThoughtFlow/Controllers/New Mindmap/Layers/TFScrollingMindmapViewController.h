//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFNodesViewController;
@class TFLinesViewController;


@interface TFScrollingMindmapViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate> {
}

@property(nonatomic, strong) TFLinesViewController *linesController;
@property(nonatomic, strong) TFNodesViewController *nodesController;
@property(nonatomic) CGSize maxContentOffset;
@property(nonatomic) CGPoint maximumPoint;


- (void) updateEdge: (CGPoint) maximumPoint withVelocity: (CGFloat) velocity;
- (void) startPinchWithScale: (CGFloat) scale;
- (void) updatePinchWithScale: (CGFloat) scale;
- (void) endPinchWithScale: (CGFloat) scale;
- (void) startPan: (UIPanGestureRecognizer *) recognizer;
- (void) updatePan: (UIPanGestureRecognizer *) recognizer;
- (void) endPan: (UIPanGestureRecognizer *) recognizer;
- (void) endNodeMove;
@end