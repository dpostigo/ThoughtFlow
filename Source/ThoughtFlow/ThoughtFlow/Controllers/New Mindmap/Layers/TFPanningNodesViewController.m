//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFPanningNodesViewController.h"
#import "TFLinesViewController.h"
#import "TFNodesViewController.h"
#import "UIViewController+DPKit.h"
#import "Project.h"
#import "TFNodeScrollView.h"
#import "UIView+DPKitDebug.h"


@implementation TFPanningNodesViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setup];

}


#pragma mark - Setup

- (instancetype) initWithProject: (Project *) project {
    self = [super init];
    if (self) {
        _project = project;
    }

    return self;
}

- (void) _setup {
    self.view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent: 0.3];
    self.view.opaque = NO;

    _scrollView = [[TFNodeScrollView alloc] initWithFrame: self.view.bounds];
    [self embedFullscreenView: _scrollView];

    [self _setupControllers];
    [self _setupProject];
}


- (void) _setupControllers {
    BOOL useScrollView = YES;
    if (useScrollView) {
        [self embedControllersInScrollView];
    } else {
        [self embedControllers];
    }
}

- (void) _setupProject {
    if (_project) {
        [self _refreshNodes];
        if (_project.modifiedDate == nil) {
            [_nodesController centerFirstNode];
        }
    }

}

- (void) embedControllersInScrollView {
    _linesController = [[TFLinesViewController alloc] init];
    _linesController.view.frame = self.view.bounds;
    [_scrollView addSubview: _linesController.view];

    _nodesController = [[TFNodesViewController alloc] init];
    _nodesController.view.frame = self.view.bounds;
    [_nodesController.view addDebugBorder: [UIColor redColor]];
    [_scrollView addSubview: _nodesController.view];
}


- (void) embedControllers {

    _linesController = [[TFLinesViewController alloc] init];
    [self embedFullscreenController: _linesController];

    _nodesController = [[TFNodesViewController alloc] init];
    [self embedFullscreenController: _nodesController];
}


#pragma mark - Refresh

- (void) _refreshNodes {
    _nodesController.rootNode = _project.firstNode;
}


- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    //    [super touchesBegan: touches withEvent: event];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end