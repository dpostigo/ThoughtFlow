//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"


@class DPTableView;

@interface LoginModalController : TFViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {

}

@property(weak) IBOutlet DPTableView *table;
@property(nonatomic, strong) UITextField *currentTextField;
- (void) prepareDatasource;


- (IBAction) signInInstead: (id) sender;
- (IBAction) submit: (UIButton *) button;
- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath;
@end