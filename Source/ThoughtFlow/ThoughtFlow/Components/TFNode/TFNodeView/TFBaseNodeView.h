//
// Created by Dani Postigo on 7/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, TFNodeViewState) {
    TFNodeViewStateNone,
    TFNodeViewStateNormal,
    TFNodeViewStateCreate,
    TFNodeViewStateDelete,
    TFNodeViewStateRelated,
};


extern CGFloat const TFNodeViewWidth;
extern CGFloat const TFNodeViewHeight;

@class TFNode;
@protocol TFBaseNodeViewDelegate;

@interface TFBaseNodeView : UIView {

}

@property(nonatomic) BOOL selected;
@property(nonatomic) TFNodeViewState nodeState;
@property(nonatomic, strong) TFNode *node;
@property(nonatomic, assign) TFBaseNodeView *parentView;
@property(nonatomic, assign) id <TFBaseNodeViewDelegate> delegate;

- (instancetype) initWithNode: (TFNode *) node;
+ (UIView *) greenGhostView;
- (void) setNodeState: (TFNodeViewState) nodeState animated: (BOOL) flag;
- (void) _notifyDidChangeSelection;
- (void) _notifyDidDoubleTap;
- (void) _notifyDidChangeState;
- (void) _notifyDidTriggerDeletion;
- (void) _notifyDidTriggerRelated;
@end