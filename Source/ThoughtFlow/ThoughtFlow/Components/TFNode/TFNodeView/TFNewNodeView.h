//
// Created by Dani Postigo on 7/1/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFBaseNodeView.h"


@class TFNode;
@class TFWhiteTranslucentView;


@interface TFNewNodeView : TFBaseNodeView <UIGestureRecognizerDelegate> {
}

@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) UIView *selectionBg;
@property(nonatomic, strong) UIPanGestureRecognizer *verticalPan;
@property(nonatomic, strong) UIPanGestureRecognizer *horizontalPan;
@end