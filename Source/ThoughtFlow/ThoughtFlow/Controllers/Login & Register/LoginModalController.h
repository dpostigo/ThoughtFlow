//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLFreeformModalProtocol.h"
#import "TFViewController.h"
#import "TFModalViewController.h"

@class DPTableView;

@interface LoginModalController : TFModalViewController <TLFreeformModalProtocol, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {

}

@property (weak) IBOutlet DPTableView *table;
- (void) prepareDatasource;
- (IBAction) signInInstead: (id) sender;
- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath;
@end