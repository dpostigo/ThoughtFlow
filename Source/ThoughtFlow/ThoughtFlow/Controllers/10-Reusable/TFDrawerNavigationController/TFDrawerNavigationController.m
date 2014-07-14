//
// Created by Dani Postigo on 7/11/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFDrawerNavigationController.h"
#import "TFTableViewController.h"
#import "TFCustomBarButtonItem.h"


@implementation TFDrawerNavigationController

- (id) initWithRootViewController: (UIViewController *) rootViewController {
    self = [super initWithRootViewController: rootViewController];
    if (self) {

        if (rootViewController.navigationItem.leftBarButtonItem == nil) {
            rootViewController.navigationItem.leftBarButtonItem = [[TFCustomBarButtonItem alloc] initWithTitle: @"SETTINGS" image: nil];
        }

        if (rootViewController.navigationItem.rightBarButtonItem == nil) {
            TFCustomBarButtonItem *rightItem = [[TFCustomBarButtonItem alloc] initWithTitle: @"CLOSE" image: [UIImage imageNamed: @"icon-chevron-left"]];
            rootViewController.navigationItem.rightBarButtonItem = rightItem;
        }

        self.navigationBar.barStyle = UIBarStyleBlackTranslucent;

    }

    return self;
}


@end