//
// Created by Dani Postigo on 7/6/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFTableViewController.h"


@class TFNode;
@class TFTableViewController;


@interface TFMindmapRelatedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, TFTableViewControllerDelegate>

@property(weak) IBOutlet UIView *containerView;
@property(weak) IBOutlet UILabel *textLabel;

@property(nonatomic, strong) UITapGestureRecognizer *recognizer;
@property(nonatomic, strong) TFTableViewController *tableViewController;
@property(nonatomic, strong) TFNode *node;
- (instancetype) initWithNode: (TFNode *) node;

@end