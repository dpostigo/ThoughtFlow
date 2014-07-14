//
// Created by Dani Postigo on 5/1/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFBaseNodeView;

@protocol TFBaseNodeViewDelegate <NSObject>

@optional

- (void) nodeViewDidDoubleTap: (TFBaseNodeView *) node;
- (void) nodeViewDidChangeState: (TFBaseNodeView *) node;
- (void) nodeViewDidChangeSelection: (TFBaseNodeView *) node;
- (void) nodeViewDidTriggerDeletion: (TFBaseNodeView *) node;
- (void) nodeViewDidTriggerRelated: (TFBaseNodeView *) node;


@end