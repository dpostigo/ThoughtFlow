//
// Created by Dani Postigo on 7/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFNode;


@interface TFLiveUpdateLayer : CALayer

//@property(nonatomic, strong) NSArray *points;
@property(nonatomic, strong) NSArray *nodeViews;
@property(nonatomic, strong) UIColor *lineColor;

- (NSArray *) pointsForRootNode: (TFNode *) parentNode;
@end