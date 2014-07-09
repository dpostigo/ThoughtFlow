//
// Created by Dani Postigo on 7/6/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFMindmapRelatedViewController.h"
#import "TFNode.h"
#import "TFTranslucentView.h"
#import "UIViewController+DPKit.h"
#import "TFTableViewController.h"
#import "TFTableViewCell.h"


@implementation TFMindmapRelatedViewController

- (instancetype) initWithNode: (TFNode *) node {
    self = [super init];
    if (self) {
        _node = node;
        _suggestions = [NSArray array];
    }

    return self;
}


- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    return [self viewControllerFromStoryboard: @"Mindmap"];

}


#pragma mark - View lifecycle



- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    [self _setupView];
    _recognizer = [self addTapBehindRecognizer: @selector(handleTapBehind:)];
}


- (void) viewWillDisappear: (BOOL) animated {
    [super viewWillDisappear: animated];
    [self.view.window removeGestureRecognizer: _recognizer];
}


- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setupView];
    _containerView.backgroundColor = [UIColor clearColor];

    _tableViewController = [[TFTableViewController alloc] init];
    _tableViewController.tableView.delegate = self;
    _tableViewController.tableView.dataSource = self;
    [self embedController: _tableViewController inView: _containerView];

    if (DEBUG) {
        _suggestions = @[
                @{@"title" : @"Bull-leaping", @"description" : @"Lorem ipsum"}
        ];
    }
}


#pragma mark - Dismiss

- (void) handleTapBehind: (UITapGestureRecognizer *) recognizer {

    BOOL isBehind = [self recognizerDidTapBehind: recognizer];
    if (isBehind) {
        [self dismissController: nil];
    }
}


- (IBAction) dismissController: (id) sender {
    [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return [_suggestions count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

    TFTableViewCell *ret = [tableView dequeueReusableCellWithIdentifier: @"TableCell" forIndexPath: indexPath];
    ret.backgroundColor = [UIColor clearColor];

    return ret;
}



#pragma mark - Setup

- (void) _setupView {

    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
}
@end