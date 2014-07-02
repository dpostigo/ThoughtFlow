//
// Created by Dani Postigo on 6/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFNodesViewController.h"
#import "TFEditNodeController.h"

@class MindmapBackgroundController;
@class TFNodesViewController;
@class Project;
@class MindmapLinesController;

@interface TFMindmapController : TFViewController <TFNodesViewDelegate, TFEditNodeControllerDelegate> {
}

@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) TFNodesViewController *nodesController;
@property(nonatomic, strong) MindmapLinesController *linesController;
@property(nonatomic, strong) MindmapBackgroundController *backgroundController;
@end