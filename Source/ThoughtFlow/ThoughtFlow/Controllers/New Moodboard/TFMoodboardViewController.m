//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import "TFMoodboardViewController.h"
#import "TFImageGridViewController.h"
#import "Project.h"
#import "TFEmptyViewController.h"



@implementation TFMoodboardViewController

- (instancetype) initWithProject: (Project *) project {
    self = [super init];
    if (self) {
        _project = project;
    }

    return self;
}


- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setupControllers];
    [self _setupProject];

}

#pragma mark - Setup

- (void) _setupControllers {

    _emptyController = [[TFEmptyViewController alloc] initWithTitle: @"You don't have any pins in your moodboard."];
    [self embedFullscreenController: _emptyController];

    _imagesController = [[TFImageGridViewController alloc] init];
    [self embedFullscreenController: _imagesController];
}

- (void) _setupProject {

    if (_project) {
        if ([_project.pinnedImages count] == 0) {
            _imagesController.view.hidden = YES;

        } else {
            _emptyController.view.hidden = YES;

        }
    }

}

@end