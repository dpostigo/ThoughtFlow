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
@class MindmapBackgroundController;
@class TFNodesViewController;
@class MindmapLinesController;
@class TFNewMindmapBackgroundViewController;
@class TFContentView;
@class TFNodeScrollView;


typedef NS_ENUM(NSInteger, TFMindmapControllerType) {
    TFMindmapControllerTypeExpanded,
    TFMindmapControllerTypeMinimized
};

@interface TFMindmapController : TFViewController <TFNodesViewControllerDelegate,
        TFMindmapGridViewControllerDelegate,
        TFNewEditNodeControllerDelegate> {
    TFNodeScrollView *_scrollView;
    TFNodesViewController *_scalingNodesController;
}

@property(nonatomic) TFMindmapControllerType mindmapType;
@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) TFNode *selectedNode;

@property(nonatomic, strong) TFContentView *contentView;
@property(nonatomic, strong) TFNodesViewController *scalingNodesController;
- (instancetype) initWithProject: (Project *) project;

@end