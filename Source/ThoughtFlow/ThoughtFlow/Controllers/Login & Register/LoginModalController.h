//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLFreeformModalProtocol.h"
#import "TFViewController.h"

@class DPTableView;

@interface LoginModalController : TFViewController <TLFreeformModalProtocol, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {

   IBOutlet DPTableView *table;

}

@property(nonatomic, strong) DPTableView *table;
@end