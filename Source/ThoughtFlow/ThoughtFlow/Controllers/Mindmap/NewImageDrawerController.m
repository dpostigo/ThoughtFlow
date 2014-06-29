//
// Created by Dani Postigo on 6/16/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "NewImageDrawerController.h"
#import "DPTableView.h"

@implementation NewImageDrawerController

- (void) viewDidLoad {
    [super viewDidLoad];

    [_table.sectionData addObject: @{DPTableViewTextLabelName : @"IMAGE CREDITS"}];
    [_table.sectionData addObject: @{DPTableViewTextLabelName : @"IMAGE CREDITS"}];
    [_table.sectionData addObject: @{DPTableViewTextLabelName : @"IMAGE CREDITS"}];

    [_table.rowData addObject: @{DPTableViewTextLabelName : @"Etc"}];

    _table.delegate = self;
    _table.dataSource = self;
}


- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return [_table numOfRowsInSection: section];
}

//
//- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView {
//    return _table.section
//}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    return nil;
}


@end