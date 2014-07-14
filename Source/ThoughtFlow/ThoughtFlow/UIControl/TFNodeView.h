//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFBaseNodeView.h"


@class TFNodeStateView;
@class TFNode;
@protocol TFBaseNodeViewDelegate;


typedef enum {
    TFSwipeDirectionNone = 0,
    TFSwipeDirectionVertical = 1,
    TFSwipeDirectionHorizontal = 2
} TFSwipeDirection;


@interface TFNodeView : TFBaseNodeView <UIGestureRecognizerDelegate> {

    UIButton *viewNormal;
    UIButton *greenButton;
    UIButton *redButton;


    BOOL isPanning;
    BOOL enabled;
    BOOL optimized;
    BOOL nodeUpdateDisabled;


    BOOL isSnappingDown;
    UIButton *relatedButton;
    CGPoint startingPoint;
}

@property(nonatomic, strong) UIButton *viewNormal;
@property(nonatomic, strong) NSString *text;
@property(nonatomic) TFNodeViewState nodeState;
@property(nonatomic) BOOL enabled;
@property(nonatomic) BOOL optimized;
@property(nonatomic) BOOL nodeUpdateDisabled;
@property(nonatomic) TFSwipeDirection swipeDirection;
@property(nonatomic, strong) UIView *containerView;

+ (UIView *) greenGhostView;

@end