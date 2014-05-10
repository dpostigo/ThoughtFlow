//
// Created by Dani Postigo on 5/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "NewRegisterController.h"
#import "DPTableView.h"

@implementation NewRegisterController

- (void) prepareDatasource {
    //    [super prepareDatasource];
    [table.rows addObject: @{DPTableViewTextLabelName : @"Username", DPTableViewImageName : [UIImage imageNamed: @"user-icon"]}];
    [table.rows addObject: @{DPTableViewTextLabelName : @"Email", DPTableViewImageName : [UIImage imageNamed: @"email-icon"]}];
    [table.rows addObject: @{DPTableViewTextLabelName : @"Password", DPTableViewImageName : [UIImage imageNamed: @"password-icon"]}];

}


@end