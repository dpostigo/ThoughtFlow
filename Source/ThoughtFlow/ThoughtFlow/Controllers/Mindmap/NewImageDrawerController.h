//
// Created by Dani Postigo on 6/16/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFDrawerController.h"

@class DPTableView;

@interface NewImageDrawerController : TFDrawerController <UITableViewDelegate, UITableViewDataSource> {


}

@property(weak) IBOutlet DPTableView *table;
@property(weak) IBOutlet UILabel *titleLabel;
@end