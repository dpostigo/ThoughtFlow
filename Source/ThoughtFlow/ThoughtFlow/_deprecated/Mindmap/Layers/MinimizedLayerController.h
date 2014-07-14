//
// Created by Dani Postigo on 5/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"

@class TFNodeView;

extern CGFloat const MindmapMinimizedX;
extern CGFloat const MindmapMinimizedOffsetY;

@interface MinimizedLayerController : TFViewController {

    TFNodeView *cornerView;
    UIButton *nodeButton;
}

@property(nonatomic, strong) UIButton *nodeButton;
@end