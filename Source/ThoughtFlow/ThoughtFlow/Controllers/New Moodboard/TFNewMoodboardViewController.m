//
// Created by Dani Postigo on 7/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import "TFNewMoodboardViewController.h"
#import "Project.h"
#import "TFTranslucentView.h"
#import "TFEmptyViewController.h"
#import "TFContentView.h"
#import "TFContentViewNavigationController.h"
#import "UIViewController+DPKit.h"
#import "TFTranslucentViewController.h"
#import "TFMoodboardGridViewController.h"
#import "UIView+DPKit.h"


@implementation TFNewMoodboardViewController

- (instancetype) initWithProject: (Project *) project {
    self = [super init];
    if (self) {
        _project = project;
        self.view = [[TFTranslucentView alloc] init];
        [self _setup];
    }

    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (void) loadView {
    [super loadView];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    [UIView animateWithDuration: 1.0 animations: ^{
        _bg.alpha = 1;
        _contentView.alpha = 1;
    }];
}


- (void) _setup {

    _bg = [[TFTranslucentView alloc] initWithFrame: self.view.bounds];
    _bg.alpha = 0;
    [self embedFullscreenView: self.bg];

    //    TFTranslucentViewController *bgController = [[TFTranslucentViewController alloc] init];
    //    bgController.view.hidden = NO;
    //    [self embedFullscreenController: bgController];

    _emptyController = [[TFEmptyViewController alloc] initWithTitle: @"You don't have any pins in your moodboard."];
    //    _emptyController.view.hidden = NO;
    [self embedFullscreenController: _emptyController];

    _contentView = [[TFContentView alloc] initWithFrame: self.view.bounds];
    _contentView.alpha = 0;
    [self embedFullscreenView: _contentView];

    TFMoodboardGridViewController *controller = [[TFMoodboardGridViewController alloc] initWithProject: _project];
    _contentNavigationController = [[TFContentViewNavigationController alloc] initWithRootViewController: controller];
    _contentNavigationController.navigationBarHidden = YES;
    _contentNavigationController.contentView = _contentView;
    UIView *navigationView = _contentNavigationController.view;
    [_contentView addSubview: navigationView];
    [_contentView embedController: _contentNavigationController];

    [self.view setNeedsUpdateConstraints];
}

@end