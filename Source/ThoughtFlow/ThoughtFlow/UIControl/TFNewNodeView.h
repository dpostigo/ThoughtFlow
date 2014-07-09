//
// Created by Dani Postigo on 7/1/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFNode;


extern CGFloat const TFNewNodeViewWidth;
extern CGFloat const TFNewNodeViewHeight;

@interface TFNewNodeView : UIView

@property(nonatomic, strong) TFNode *node;
- (instancetype) initWithNode: (TFNode *) node;

@end