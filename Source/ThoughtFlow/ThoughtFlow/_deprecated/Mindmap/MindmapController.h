//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"
#import "TFBaseNodeViewDelegate.h"
#import "TFDrawerPresenter.h"

@class TFNodeView;
@class PanningView;
@class MindmapBackgroundController;

@interface MindmapController : TFViewController <TFBaseNodeViewDelegate, TFDrawerPresenter> {
    MindmapBackgroundController *backgroundController;


    TFNodeView *currentNodeView;
    IBOutlet TFNodeView *firstNodeView;
    IBOutlet  UIView *interfaceView;

    UIView *lineView;
    PanningView *nodeContainerView;

    UIView *creationNode;

    NSMutableArray *nodeViews;

    CALayer *tempLine;
    BOOL isPinched;
    BOOL isPresenting;
}

@property(nonatomic, strong) UIView *creationNode;
@property(nonatomic, strong) NSMutableArray *nodeViews;

#pragma mark TFDrawerPresenter
- (void) presentDrawerController: (UIViewController *) controller;

@end