//
// Created by Dani Postigo on 5/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "PasswordController.h"
#import "DPTableView.h"

@implementation PasswordController

- (void) prepareDatasource {
    //    [super prepareDatasource];

    [table.rows addObject: @{DPTableViewTextLabelName : @"Email address", DPTableViewTextLabelName : [UIImage imageNamed: @"email-icon"]}];
}

@end