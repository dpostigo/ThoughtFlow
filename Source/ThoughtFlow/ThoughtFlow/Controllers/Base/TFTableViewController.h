//
// Created by Dani Postigo on 7/6/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TFTableViewControllerDelegate <UITableViewDelegate, UITableViewDataSource>

- (void) configureCell: (UITableViewCell *) cell atIndexPath: (NSIndexPath *) indexPath;

@end;

@interface TFTableViewController : UITableViewController

@property(nonatomic, assign) id <TFTableViewControllerDelegate> delegate;
@property(nonatomic, copy) NSString *cellIdentifier;
@end