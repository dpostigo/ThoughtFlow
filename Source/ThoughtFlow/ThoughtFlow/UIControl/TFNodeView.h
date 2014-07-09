//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFNodeStateView;
@class TFNode;
@protocol TFNodeViewDelegate;

extern CGFloat const TFNodeViewWidth;
extern CGFloat const TFNodeViewHeight;

typedef enum {
    TFNodeViewStateNone = 0,
    TFNodeViewStateNormal = 1,
    TFNodeViewStateCreate = 2,
    TFNodeViewStateDelete = 3,
    TFNodeViewStateRelated = 4
} TFNodeViewState;


typedef enum {
    TFSwipeDirectionNone = 0,
    TFSwipeDirectionVertical = 1,
    TFSwipeDirectionHorizontal = 2
} TFSwipeDirection;


@interface TFNodeView : UIView <UIGestureRecognizerDelegate> {

    TFNodeViewState nodeState;
    TFSwipeDirection swipeDirection;

    UIButton *viewNormal;
    UIButton *greenButton;
    UIButton *redButton;
    UIView *debugView;

    IBOutlet __unsafe_unretained id <TFNodeViewDelegate> delegate;

    BOOL isPanning;
    BOOL enabled;
    BOOL selected;
    BOOL optimized;
    BOOL nodeUpdateDisabled;


    BOOL isSnappingDown;
    UIButton *relatedButton;
    CGPoint startingPoint;
}

@property(nonatomic, strong) TFNode *node;
@property(nonatomic, assign) TFNodeView *parentView;
@property(nonatomic, strong) UIButton *viewNormal;
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) UIView *debugView;
@property(nonatomic, assign) id <TFNodeViewDelegate> delegate;
@property(nonatomic) TFNodeViewState nodeState;
@property(nonatomic) BOOL enabled;
@property(nonatomic) BOOL selected;
@property(nonatomic) BOOL optimized;
@property(nonatomic) BOOL nodeUpdateDisabled;
@property(nonatomic) TFSwipeDirection swipeDirection;
@property(nonatomic, strong) UIView *containerView;
- (instancetype) initWithNode: (TFNode *) aNode;

+ (UIView *) greenGhostView;
- (void) setNodeState: (TFNodeViewState) nodeState1 animated: (BOOL) flag;

@end