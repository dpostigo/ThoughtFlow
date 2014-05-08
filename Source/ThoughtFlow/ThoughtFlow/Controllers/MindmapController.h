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

    IBOutlet TFNodeView *firstNodeView;

    UIView *creationNode;

    TFNodeView *currentNodeView;

    UIView *lineView;

    NSMutableArray *nodeViews;

    PanningView *nodeContainerView;
    BOOL layerAnimationEnabled;

    CALayer *tempLine;
}

@property(nonatomic, strong) UIView *creationNode;
@property(nonatomic, strong) NSMutableArray *nodeViews;
- (void) drawLineForIndex: (int) j;
@end