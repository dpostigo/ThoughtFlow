//
// Created by Dani Postigo on 7/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFBaseNodeView.h"
#import "TFNode.h"
#import "TFBaseNodeViewDelegate.h"
#import "UIColor+TFApp.h"


CGFloat const TFNodeViewWidth = 80;
CGFloat const TFNodeViewHeight = 80;

@implementation TFBaseNodeView

- (instancetype) initWithNode: (TFNode *) node {
    self = [super init];
    if (self) {
        _node = node;
    }

    return self;
}


#pragma mark - Class methods

+ (UIView *) greenGhostView {
    UIView *ret = [[UIView alloc] initWithFrame: CGRectMake(0, 0, TFNodeViewWidth,
            TFNodeViewHeight)];
    ret.backgroundColor = [UIColor tfGreenColor];

    return ret;
}

#pragma mark - Public

- (void) setNodeState: (TFNodeViewState) nodeState {
    [self setNodeState: nodeState animated: NO];
}

- (void) setNodeState: (TFNodeViewState) nodeState animated: (BOOL) flag {
    _nodeState = nodeState;
    [self _notifyDidChangeState];

}



#pragma mark - Notify

- (void) _notifyDidChangeSelection {
    if (_delegate && [_delegate respondsToSelector: @selector(nodeViewDidChangeSelection:)]) {
        [_delegate nodeViewDidChangeSelection: self];
    }
}


- (void) _notifyDidDoubleTap {
    if (_delegate && [_delegate respondsToSelector: @selector(nodeViewDidDoubleTap:)]) {
        [_delegate nodeViewDidDoubleTap: self];
    }
}

- (void) _notifyDidChangeState {
    if (_delegate && [_delegate respondsToSelector: @selector(nodeViewDidChangeState:)]) {
        [_delegate nodeViewDidChangeState: self];
    }
}


- (void) _notifyDidTriggerDeletion {
    if (_delegate && [_delegate respondsToSelector: @selector(nodeViewDidTriggerDeletion:)]) {
        [_delegate nodeViewDidTriggerDeletion: self];
    }
}


- (void) _notifyDidTriggerRelated {
    if (_delegate && [_delegate respondsToSelector: @selector(nodeViewDidTriggerRelated:)]) {
        [_delegate nodeViewDidTriggerRelated: self];
    }
}
@end