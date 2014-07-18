//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"


@class DPTableView;

@interface TFLoginViewController : TFViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {

}

@property(weak) IBOutlet DPTableView *table;
@property(weak) IBOutlet UIButton *submitButton;
@property(weak) IBOutlet UIButton *registerButton;
@property(weak) IBOutlet UIButton *passwordButton;
@property(weak) IBOutlet UIButton *insteadButton;
@property(nonatomic, strong) UITextField *currentTextField;
- (void) submit;
- (void) prepareDatasource;


- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath;
@end