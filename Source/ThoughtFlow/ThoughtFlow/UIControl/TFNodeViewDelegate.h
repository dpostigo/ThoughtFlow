//
// Created by Dani Postigo on 5/1/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFNodeView;

@protocol TFNodeViewDelegate <NSObject>

@optional


- (void) nodeViewDidDoubleTap: (TFNodeView *) node;
- (void) nodeViewDidChangeState: (TFNodeView *) node;
@end