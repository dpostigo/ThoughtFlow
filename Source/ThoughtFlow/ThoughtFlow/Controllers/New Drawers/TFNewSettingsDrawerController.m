//
// Created by Dani Postigo on 7/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import "TFNewSettingsDrawerController.h"
#import "TFCustomBarButtonItem.h"
#import "TFTranslucentView.h"
#import "TFTableViewCell.h"
#import "TFBarButtonItem.h"


static NSString *const TFSettingsTableCell = @"ImageSettingsCell";

@interface TFNewSettingsDrawerController ()

@property(nonatomic, strong) NSArray *rows;
@end

@implementation TFNewSettingsDrawerController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {

        //    _rows = [NSArray array];

        _rows = @[
                @{
                        @"title" : @"IMAGE SEARCH",
                        @"subtitle" : @"Turn this OFF to use the default canvas when working with your mindmap."
                },
                @{
                        @"title" : @"AUTO-REFRESH",
                        @"subtitle" : @"Automatically update image results when interacting with your mindmap."
                }];
    }

    return self;
}


- (void) loadView {
    [super loadView];

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

}

- (void) _setupControllers {

    UIViewController *container = [[UIViewController alloc] init];
    container.navigationItem.leftBarButtonItem = [[TFBarButtonItem alloc] initWithTitle: @"SETTINGS"];

    TFCustomBarButtonItem *rightItem = [[TFCustomBarButtonItem alloc] initWithTitle: @"CLOSE" image: [UIImage imageNamed: @"icon-chevron-left"]];
    rightItem.target = self;
    rightItem.action = @selector(closeDrawer:);
    [rightItem.button addTarget: self action: @selector(closeDrawer:) forControlEvents: UIControlEventTouchUpInside];
    container.navigationItem.rightBarButtonItem = rightItem;

    _tableViewController = [[TFTableViewController alloc] init];
    _tableViewController.cellIdentifier = TFSettingsTableCell;
    _tableViewController.delegate = self;
    [container embedFullscreenController: _tableViewController withInsets: UIEdgeInsetsMake(10, 0, 0, 0)];

    _viewNavigationController = [[UINavigationController alloc] initWithRootViewController: container];
    _viewNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self embedFullscreenController: _viewNavigationController];

    [self _setupNavItems];
}

- (void) _setupNavItems {
    UIViewController *controller = _viewNavigationController.visibleViewController;

    TFBarButtonItem *rightItem = [[TFBarButtonItem alloc] initWithButton: [TFBarButtonItem closeButton]];
    [rightItem.button addTarget: self action: @selector(closeDrawer:) forControlEvents: UIControlEventTouchUpInside];
    controller.navigationItem.rightBarButtonItem = rightItem;

}


- (void) _setupView {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;

}

- (IBAction) closeDrawer: (id) sender {
    [self _notifyDrawerControllerShouldDismiss];
}


@end