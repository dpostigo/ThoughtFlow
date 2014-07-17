//
// Created by Dani Postigo on 7/6/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TFTableViewControllerDelegate <UITableViewDelegate, UITableViewDataSource>

- (void) configureCell: (UITableViewCell *) cell atIndexPath: (NSIndexPath *) indexPath;

@end;

@interface TFTableViewController : UITableViewController

extern NSString *const TFTableViewDefaultCellIdentifier;
extern NSString *const TFButtonTableViewCellIdentifier;
extern NSString *const TFTableViewBlankCellIdentifier;

@property(nonatomic, assign) id <TFTableViewControllerDelegate> delegate;
@property(nonatomic, copy) NSString *cellIdentifier;
- (void) reloadData;
- (void) reloadRowsAtIndexPaths: (NSArray *) indexPaths withRowAnimation: (UITableViewRowAnimation) animation;
@end