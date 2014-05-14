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
    IBOutlet  UIView *interfaceView;

    UIView *lineView;
    PanningView *nodeContainerView;

    UIView *creationNode;

    NSMutableArray *nodeViews;

    CALayer *tempLine;
    BOOL isPinched;
}

@property(nonatomic, strong) UIView *creationNode;
@property(nonatomic, strong) NSMutableArray *nodeViews;
@end