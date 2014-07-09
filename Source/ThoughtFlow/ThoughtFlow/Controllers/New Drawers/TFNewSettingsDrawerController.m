//
// Created by Dani Postigo on 7/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import "TFNewSettingsDrawerController.h"
#import "TFCustomBarButtonItem.h"
#import "TFTranslucentView.h"
#import "TFTableViewCell.h"


static NSString *const TFSettingsTableCell = @"ImageSettingsCell";

@interface TFNewSettingsDrawerController ()

@property(nonatomic, strong) NSArray *rows;
@end

@implementation TFNewSettingsDrawerController

- (void) loadView {
    [super loadView];

    _rows = [NSArray array];

    _rows = @[
            @{
                    @"title" : @"IMAGE SEARCH",
                    @"subtitle" : @"Turn this OFF to use the default canvas when working with your mindmap."
            },
            @{
                    @"title" : @"AUTO-REFRESH",
                    @"subtitle" : @"Automatically update image results when interacting with your mindmap."
            }];

    self.view = [[TFTranslucentView alloc] initWithFrame: self.view.bounds];
    [self _setup];
}


#pragma mark - Delegates
#pragma mark - UITableViewDelegate

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    TFTableViewCell *ret = [tableView dequeueReusableCellWithIdentifier: TFSettingsTableCell forIndexPath: indexPath];
    return ret;
}

- (void) configureCell: (UITableViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    NSDictionary *dictionary = [_rows objectAtIndex: indexPath.row];
    cell.textLabel.text = [dictionary objectForKey: @"title"];
    cell.detailTextLabel.text = [dictionary objectForKey: @"subtitle"];
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return [_rows count];
}



#pragma mark - Setup


- (void) _setup {
    [self _setupControllers];
    [self _setupNavigationController];

}

- (void) _setupControllers {
    _tableViewController = [[TFTableViewController alloc] init];
    _tableViewController.cellIdentifier = TFSettingsTableCell;
    _tableViewController.delegate = self;

    _viewNavigationController = [[UINavigationController alloc] initWithRootViewController: _tableViewController];
    [self embedFullscreenController: _viewNavigationController];
    //    [self embedFullscreenController: _viewNavigationController withInsets: UIEdgeInsetsMake(10, 5, 40, 5)];

}

- (void) _setupNavigationController {

    _viewNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    _tableViewController.navigationItem.leftBarButtonItem = [[TFCustomBarButtonItem alloc] initWithTitle: @"SETTINGS" image: nil];
    _tableViewController.navigationItem.rightBarButtonItem = [[TFCustomBarButtonItem alloc] initWithTitle: @"CLOSE" image: [UIImage imageNamed: @"icon-chevron-left"]];

}


- (void) _setupView {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;

}

- (IBAction) closeDrawer: (id) sender {
    [self _notifyDrawerControllerShouldDismiss];
}


@end