//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"
#import "TFNodeViewDelegate.h"

@class TFNodeView;

@interface MindmapController : TFViewController <TFNodeViewDelegate> {

    IBOutlet TFNodeView *firstNodeView;

    UILongPressGestureRecognizer *pressGesture;

    UIView *creationNode;

    TFNodeView *currentNodeView;

    UIView *lineView;

    NSMutableArray *nodeViews;
}


@property(nonatomic, strong) UIView *creationNode;
@property(nonatomic, strong) UILongPressGestureRecognizer *pressGesture;
@property(nonatomic, strong) NSMutableArray *nodeViews;
@end