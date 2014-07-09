//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import <DPKit-Utils/UIView+DPKitDebug.h>
#import "TFMoodboardViewController.h"
#import "Project.h"
#import "TFContentViewNavigationController.h"
#import "TFMoodboardGridViewController.h"
#import "TFTranslucentView.h"
#import "TFEmptyViewController.h"
#import "UIView+DPKit.h"


@interface TFMoodboardViewController ()

@property(nonatomic, strong) TFEmptyViewController *emptyController;
@end

@implementation TFMoodboardViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        self.view = [[TFTranslucentView alloc] initWithFrame: self.view.bounds];
        [self _setup];
    }

    return self;
}


- (instancetype) initWithProject: (Project *) project {
    self = [super init];
    if (self) {
        _project = project;

    }

    return self;
}




#pragma mark - View lifecycle

- (void) loadView {
    [super loadView];

}

- (void) viewDidLoad {
    [super viewDidLoad];
    //    self.view.alpha = 0;

}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    [self _setupProject];
}




#pragma mark - Setup

- (void) _setup {

    [self _setupView];
    [self _setupControllers];

}


- (void) _setupProject {
    if ([_project.pinnedImages count] == 0) {
        _contentView.hidden = YES;
    } else {
        [_emptyController.view removeFromSuperview];
        TFMoodboardGridViewController *controller = [[TFMoodboardGridViewController alloc] initWithProject: _project];
        [_contentNavigationController setViewControllers: @[controller]];
    }

}

- (void) _setupView {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
}

- (void) _setupControllers {

    _emptyController = [[TFEmptyViewController alloc] initWithTitle: @"You don't have any pins in your moodboard."];
    _emptyController.view.hidden = YES;
    [self embedFullscreenController: _emptyController];

    _contentView = [[TFContentView alloc] initWithFrame: self.view.bounds];
    [self.view addSubview: _contentView];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints: @[
            [NSLayoutConstraint constraintWithItem: _contentView attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _contentView attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _contentView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.topLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _contentView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self.bottomLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0]
    ]];

    TFMoodboardGridViewController *controller = [[TFMoodboardGridViewController alloc] initWithProject: _project];
    _contentNavigationController = [[TFContentViewNavigationController alloc] initWithRootViewController: controller];
    _contentNavigationController.navigationBarHidden = YES;
    _contentNavigationController.contentView = _contentView;
    UIView *navigationView = _contentNavigationController.view;
    [_contentView addSubview: navigationView];
    [self.view addConstraints: @[
            [NSLayoutConstraint constraintWithItem: navigationView attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: _contentView attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: navigationView attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: _contentView attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: navigationView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: _contentView attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: navigationView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: _contentView attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0]
    ]];

}


- (TFMoodboardGridViewController *) gridController {
    return (TFMoodboardGridViewController *) ([_contentNavigationController.visibleViewController isKindOfClass: [TFMoodboardGridViewController class]] ? _contentNavigationController.visibleViewController : nil);
}

@end