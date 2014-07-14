//
// Created by Dani Postigo on 6/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFNodesViewController.h"
#import "TFMindmapButtonsViewController.h"
#import "TFMindmapGridViewController.h"
#import "TFNewEditNodeController.h"


@class Project;
@class TFNode;
@class TFNodesViewController;
@class TFLinesViewController;
@class TFNewMindmapBackgroundViewController;
@class TFContentView;
@class TFScrollingMindmapViewController;


typedef NS_ENUM(NSInteger, TFMindmapControllerType) {
    TFMindmapControllerTypeExpanded,
    TFMindmapControllerTypeMinimized
};

@interface TFMindmapViewController : TFViewController <TFNodesViewControllerDelegate,
        TFMindmapGridViewControllerDelegate,
        TFNewEditNodeControllerDelegate>

@property(nonatomic) TFMindmapControllerType mindmapType;
@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) TFNode *selectedNode;

@property(nonatomic, strong) TFContentView *contentView;
@property(nonatomic, strong) UIView *mindmapView;
@property(nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property(nonatomic, strong) NSLayoutConstraint *heightConstraint;
- (instancetype) initWithProject: (Project *) project;

@end