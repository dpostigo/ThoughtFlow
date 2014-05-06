//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFNodeStateView;
@protocol TFNodeViewDelegate;
@class TFNode;


extern CGFloat const TFNodeViewWidth;
extern CGFloat const TFNodeViewHeight;

typedef enum {
    TFNodeViewStateNone = 0,
    TFNodeViewStateNormal = 1,
    TFNodeViewStateCreate = 2,
    TFNodeViewStateDelete = 3,
    TFNodeViewStateRelated = 4
} TFNodeViewState;

@interface TFNodeView : UIView <UIGestureRecognizerDelegate> {

    TFNode *node;
    TFNodeViewState nodeState;

    UIView *debugView;
    TFNodeStateView *normalView;
    TFNodeStateView *greenView;
    UIButton *greenButton;
    UIButton *redButton;


    UIView *containerView;
    UILabel *textLabel;

    IBOutlet __unsafe_unretained id <TFNodeViewDelegate> delegate;

    id nodeNotification;
    BOOL isPanning;
    BOOL enabled;
    BOOL selected;
    BOOL isPanningUp;
    UIButton *relatedButton;
    BOOL isSnappingDown;
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
+ (UIView *) greenGhostView;
- (void) setNodeState: (TFNodeViewState) nodeState1 animated: (BOOL) flag;
- (NSString *) nodeStateAsString;
- (NSString *) stringForNodeState: (TFNodeViewState) state;
@end