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
    TFNodeViewStateNormal = 0,
    TFNodeViewStateCreate = 1,
    TFNodeViewStateDelete = 2
} TFNodeViewState;

@interface TFNodeView : UIView {

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
}

@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) TFNodeStateView *normalView;
@property(nonatomic, strong) UIView *debugView;
@property(nonatomic, strong) TFNodeStateView *greenView;
@property(nonatomic, assign) id <TFNodeViewDelegate> delegate;
@property(nonatomic) TFNodeViewState nodeState;
@property(nonatomic, strong) TFNode *node;
+ (UIView *) greenNode;
- (void) setNodeState: (TFNodeViewState) nodeState1 animated: (BOOL) flag;
@end