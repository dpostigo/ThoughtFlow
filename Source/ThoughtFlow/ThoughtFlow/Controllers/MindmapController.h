//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"
#import "TFNodeViewDelegate.h"

@class TFNodeView;
@class PanningView;

@interface MindmapController : TFViewController <TFNodeViewDelegate> {

    TFNodeView *currentNodeView;
    IBOutlet TFNodeView *firstNodeView;

    UIView *lineView;
    IBOutlet  UIView *interfaceView;
    PanningView *nodeContainerView;

    UIView *creationNode;

    NSMutableArray *nodeViews;
    BOOL layerAnimationEnabled;

    CALayer *tempLine;
}

@property(nonatomic, strong) UIView *creationNode;
@property(nonatomic, strong) NSMutableArray *nodeViews;
- (void) drawLineForIndex: (int) j;
@end