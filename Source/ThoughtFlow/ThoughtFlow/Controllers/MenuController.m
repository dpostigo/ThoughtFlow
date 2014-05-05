//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "MenuController.h"
#import "Model.h"
#import "AddProjectController.h"

@implementation MenuController

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([_model.projects count] == 0) {
        AddProjectController *controller = [self.storyboard instantiateViewControllerWithIdentifier: @"AddProjectController"];
        [self.navigationController pushViewController: controller
                                             animated: YES];

    }
}

@end