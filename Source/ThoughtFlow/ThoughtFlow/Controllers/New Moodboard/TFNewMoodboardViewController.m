//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNewMoodboardViewController.h"
#import "Project.h"
#import "TFContentViewNavigationController.h"
#import "TFMoodboardGridViewController.h"


@implementation TFNewMoodboardViewController

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

}


- (void) _setupControllers {

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



@end