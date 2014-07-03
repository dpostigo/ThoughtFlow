//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFMindmapButtonsViewController.h"


@class Project;
@class TFNode;
@class TFMindmapButtonsViewController;
@class MindmapBackgroundController;
@class TFContentViewNavigationController;
@class TFMindmapGridViewController;
@class TFNewMindmapGridViewController;
@class TFNewMindmapFullscreenViewController;
@class NavigationFadeAnimator;


@interface TFNewMindmapBackgroundViewController : UIViewController <TFMindmapButtonsViewControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) TFNode *node;
@property(nonatomic, strong) NSArray *images;
@property(nonatomic, copy) NSString *imageString;


@property(nonatomic, strong) TFContentViewNavigationController *contentController;
@property(nonatomic, strong) TFMindmapButtonsViewController *buttonsController;
@property(nonatomic, strong) TFNewMindmapGridViewController *gridController;


@property(nonatomic, strong) NavigationFadeAnimator *fadeAnimator;
- (instancetype) initWithProject: (Project *) project node: (TFNode *) node;

@end