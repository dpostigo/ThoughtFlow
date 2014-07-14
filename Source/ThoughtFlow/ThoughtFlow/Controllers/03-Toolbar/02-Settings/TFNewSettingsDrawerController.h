//
// Created by Dani Postigo on 7/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFNewDrawerController.h"
#import "TFTableViewController.h"


@class TFTableViewController;


@interface TFNewSettingsDrawerController : TFNewDrawerController <UITableViewDelegate, UITableViewDataSource, TFTableViewControllerDelegate>

@property(nonatomic, strong) UINavigationController *viewNavigationController;
@property(nonatomic, strong) TFTableViewController *tableViewController;
@end