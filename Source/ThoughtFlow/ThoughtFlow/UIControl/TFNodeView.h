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

    TFNode *node;
    TFNodeViewState nodeState;
    TFSwipeDirection swipeDirection;

    TFNodeStateView *normalView;
    TFNodeStateView *greenView;
    UIButton *greenButton;
    UIButton *redButton;
    UIView *debugView;


    UIView *containerView;
    UILabel *textLabel;

    IBOutlet __unsafe_unretained id <TFNodeViewDelegate> delegate;

    id nodeNotification;
    BOOL isPanning;
    BOOL enabled;
    BOOL selected;
    BOOL optimized;


    BOOL isSnappingDown;
    UIButton *relatedButton;
    CGPoint startingPoint;
}

@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) TFNodeStateView *normalView;
@property(nonatomic, strong) UIView *debugView;
@property(nonatomic, strong) TFNodeStateView *greenView;
@property(nonatomic, assign) id <TFNodeViewDelegate> delegate;
@property(nonatomic) TFNodeViewState nodeState;
@property(nonatomic, strong) TFNode *node;
@property(nonatomic) BOOL enabled;
@property(nonatomic) BOOL selected;
@property(nonatomic) BOOL optimized;
@property(nonatomic) TFSwipeDirection swipeDirection;
+ (UIView *) greenGhostView;
- (void) setNodeState: (TFNodeViewState) nodeState1 animated: (BOOL) flag;

@end