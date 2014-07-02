//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFMainContentViewNavigationController.h"


@implementation TFMainContentViewNavigationController

- (void) setViewControllers: (NSArray *) viewControllers animated: (BOOL) animated {
    if ([viewControllers count] == 1 && [self.viewControllers count] == 1) {
        UIViewController *controller = viewControllers[0];
        if ([controller isKindOfClass: [self.visibleViewController class]]) {
            return;
        }
    }

    [super setViewControllers: viewControllers animated: animated];
}


@end