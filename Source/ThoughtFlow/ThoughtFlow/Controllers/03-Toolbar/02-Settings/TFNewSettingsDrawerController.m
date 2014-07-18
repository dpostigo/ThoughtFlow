//
// Created by Dani Postigo on 7/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import <BlocksKit/UIControl+BlocksKit.h>
#import <BlocksKit/NSObject+BKBlockExecution.h>
#import "TFNewSettingsDrawerController.h"
#import "TFCustomBarButtonItem.h"
#import "TFTranslucentView.h"
#import "TFTableViewCell.h"
#import "TFBarButtonItem.h"
#import "APIModel.h"
#import "TFUserPreferences.h"
#import "APIUser.h"


static NSString *const TFSettingsTableCell = @"ImageSettingsCell";


static NSString *const TFSettingsImageSearchString = @"IMAGE SEARCH";
static NSString *const TFSettingsAutoRefreshString = @"AUTO-REFRESH";

@interface TFNewSettingsDrawerController ()

@property(nonatomic, strong) NSArray *rows;
@end

@implementation TFNewSettingsDrawerController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {

        //    _rows = [NSArray array];

        [self _refreshContent];
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

- (void) configureCell: (UITableViewCell *) tableCell atIndexPath: (NSIndexPath *) indexPath {
    TFTableViewCell *cell = (TFTableViewCell *) tableCell;
    NSDictionary *dictionary = [_rows objectAtIndex: indexPath.row];

    NSString *title = [dictionary objectForKey: @"title"];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = [dictionary objectForKey: @"subtitle"];

    BOOL selected = [[dictionary objectForKey: @"selected"] boolValue];

    cell.button.tag = indexPath.row;
    cell.button.selected = [[dictionary objectForKey: @"selected"] boolValue];;

    [cell.button bk_addEventHandler: ^(id sender) {
        UIButton *button = sender;
        button.selected = !button.selected;

        NSInteger row = button.tag;
        [self toggleUserPreferenceType: (TFUserPreferenceType) row flag: button.selected];

    } forControlEvents: UIControlEventTouchUpInside];
}


- (void) toggleUserPreferenceType: (TFUserPreferenceType) type flag: (BOOL) flag {
    TFUserPreferences *preferences = [APIModel sharedModel].currentUser.preferences;
    UITableView *table = _tableViewController.tableView;

    if (type == TFUserPreferenceTypeAutorefresh) {
        [preferences toggleForType: type flag: flag];
        [self _refreshContent];

        //        [table reloadRowsAtIndexPaths: @[
        //                [NSIndexPath indexPathForRow: 0 inSection: 0],
        //                [NSIndexPath indexPathForRow: 1 inSection: 0]
        //        ] withRowAnimation: UITableViewRowAnimationNone];

    }

    else if (type == TFUserPreferenceTypeImageSearch) {

        NSUInteger row = 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: row inSection: 0];

        if (!flag) {
            [preferences toggleForType: TFUserPreferenceTypeImageSearch flag: flag];

            TFTableViewCell *cell = (TFTableViewCell *) [table cellForRowAtIndexPath: indexPath];
            cell.button.selected = NO;

            NSMutableArray *rows = [_rows mutableCopy];
            NSMutableDictionary *dictionary = [[_rows objectAtIndex: row] mutableCopy];
            [preferences toggleForType: TFUserPreferenceTypeAutorefresh flag: flag];
            [table beginUpdates];
            [rows removeObject: dictionary];
            _rows = rows;
            [table deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationLeft];
            [table endUpdates];

        } else {
            // toggle autorefresh ON
            [preferences toggleForType: TFUserPreferenceTypeImageSearch flag: flag];
            [preferences toggleForType: TFUserPreferenceTypeAutorefresh flag: flag];
            [self _refreshContent];
            [table insertRowsAtIndexPaths: @[
                    [NSIndexPath indexPathForRow: 1 inSection: 0]
            ] withRowAnimation: UITableViewRowAnimationLeft];

        }
    }

    [[APIModel sharedModel] saveUser];
}

- (void) reloadAtIndexPath: (NSIndexPath *) indexPath {
    [_tableViewController reloadRowsAtIndexPaths: @[indexPath]
            withRowAnimation: UITableViewRowAnimationFade];

}


- (void) deleteAtIndexPath: (NSIndexPath *) indexPath {
    UITableView *table = _tableViewController.tableView;
    [table beginUpdates];
    [self _refreshContent];
    NSMutableDictionary *dictionary = [[_rows objectAtIndex: indexPath.row] mutableCopy];

    [table deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationLeft];
    [table endUpdates];

}

- (void) _refreshPreferences {
    TFUserPreferences *preferences = [APIModel sharedModel].currentUser.preferences;

    if (!preferences.imageSearchEnabled && preferences.autoRefreshEnabled) {

        NSIndexPath *refreshIndexPath = [NSIndexPath indexPathForRow: 1 inSection: 0];
        preferences.autoRefreshEnabled = NO;
        [_tableViewController reloadRowsAtIndexPaths: @[refreshIndexPath]
                withRowAnimation: UITableViewRowAnimationFade];

        [self bk_performBlock: ^(id obj) {

            NSLog(@"obj = %@", obj);
            UITableView *table = _tableViewController.tableView;
            [table beginUpdates];
            [self _refreshContent];

            NSLog(@"[_rows count] = %u", [_rows count]);
            [table deleteRowsAtIndexPaths: @[refreshIndexPath] withRowAnimation: UITableViewRowAnimationLeft];
            [table endUpdates];

        } afterDelay: 1.0];
    }
}


- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return [_rows count];
}



#pragma mark - Refresh

- (void) _refreshContent {
    _rows = [self _refreshedRows];
}

- (NSArray *) _refreshedRows {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    TFUserPreferences *preferences = [APIModel sharedModel].currentUser.preferences;

    [ret addObject: @{
            @"title" : TFSettingsImageSearchString,
            @"subtitle" : @"Turn this OFF to use the default canvas when working with your mindmap.",
            @"selected" : @(preferences.imageSearchEnabled)
    }];

    if (preferences.imageSearchEnabled) {
        [ret addObject: @{
                @"title" : TFSettingsAutoRefreshString,
                @"subtitle" : @"Automatically update image results when interacting with your mindmap.",
                @"selected" : @(preferences.autoRefreshEnabled)
        }];
    }

    return ret;
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