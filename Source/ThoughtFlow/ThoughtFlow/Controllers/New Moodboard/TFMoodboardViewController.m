//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFMoodboardViewController.h"
#import "Project.h"
#import "TFMoodboardGridViewController.h"


@implementation TFMoodboardViewController

- (instancetype) initWithProject: (Project *) project {
    TFMoodboardGridViewController *controller = [[TFMoodboardGridViewController alloc] initWithProject: project];
    self = [super initWithRootViewController: controller];
    if (self) {
        _project = project;
        self.navigationBarHidden = YES;
    }

    return self;
}


@end