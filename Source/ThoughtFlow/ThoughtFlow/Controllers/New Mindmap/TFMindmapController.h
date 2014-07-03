//
// Created by Dani Postigo on 6/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFNodesViewController.h"
#import "TFEditNodeController.h"
#import "TFMindmapButtonsViewController.h"
#import "TFMindmapGridViewController.h"


@class Project;
@class TFNode;
@class MindmapBackgroundController;
@class TFNodesViewController;
@class MindmapLinesController;
@class TFNewMindmapBackgroundViewController;

@interface TFMindmapController : TFViewController <TFNodesViewDelegate,
        TFEditNodeControllerDelegate,
        TFMindmapButtonsViewControllerDelegate,
        TFMindmapGridViewControllerDelegate> {
}

@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) TFNode *selectedNode;
@property(nonatomic, strong) TFNodesViewController *nodesController;
@property(nonatomic, strong) MindmapLinesController *linesController;
@property(nonatomic, strong) MindmapBackgroundController *backgroundController;
@property(nonatomic, strong) TFNewMindmapBackgroundViewController *bgController;
@end