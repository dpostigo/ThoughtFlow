//
// Created by Dani Postigo on 7/6/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import <DPTableView/DPTableViewCell.h>
#import "TFTableViewController.h"
#import "NSMutableAttributedString+DPKit.h"


NSString *const TFTableViewDefaultCellIdentifier = @"TableCell";
NSString *const TFTableViewImageDrawerCellIdentifier = @"TFImageDrawerCell";
NSString *const TFButtonTableViewCellIdentifier = @"TFButtonCell";
NSString *const TFTableViewBlankCellIdentifier = @"TFBlankCell";


@interface TFTableViewController ()

@property(nonatomic, strong) DPTableViewCell *prototype;
@end

@implementation TFTableViewController

- (id) init {
    return [self viewControllerFromStoryboard];
}


- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        _cellIdentifier = TFTableViewDefaultCellIdentifier;
    }

    return self;
}


- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setup];
}


#pragma mark - Public

- (void) reloadData {
    [self.tableView reloadData];
}

- (void) reloadRowsAtIndexPaths: (NSArray *) indexPaths withRowAnimation: (UITableViewRowAnimation) animation {
    [self.tableView reloadRowsAtIndexPaths: indexPaths withRowAnimation: animation];
}

#pragma mark - Setup

- (void) _setup {
    [self _setupView];
    [self _setupTableView];
}

- (void) _setupView {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
}

- (void) _setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Cells




- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    NSInteger ret = 0;
    if (_delegate && [_delegate respondsToSelector: @selector(tableView:numberOfRowsInSection:)]) {
        ret = [_delegate tableView: tableView numberOfRowsInSection: section];
    }

    return ret;
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    UITableViewCell *ret = nil;
    if (_delegate && [_delegate respondsToSelector: @selector(tableView:cellForRowAtIndexPath:)]) {
        ret = [_delegate tableView: tableView cellForRowAtIndexPath: indexPath];
    } else {
        ret = [tableView dequeueReusableCellWithIdentifier: _cellIdentifier forIndexPath: indexPath];
    }

    [self configureCell: ret atIndexPath: indexPath];

    return ret;
}


- (void) configureCell: (UITableViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    cell.backgroundColor = [UIColor clearColor];

    if (_delegate && [_delegate respondsToSelector: @selector(configureCell:atIndexPath:)]) {
        [_delegate configureCell: cell atIndexPath: indexPath];
    }
}


- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {

    [self configureCell: self.prototype atIndexPath: indexPath];

    self.prototype.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), 44);
    [self.prototype layoutIfNeeded];

    CGFloat height = [self.prototype.contentView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height;

    if (_delegate && [_delegate respondsToSelector: @selector(tableView:heightForRowAtIndexPath:)]) {
        return [_delegate tableView: tableView heightForRowAtIndexPath: indexPath];
    } else {
        return height + 1;
    }
    return 0;

}


- (CGFloat) tableView: (UITableView *) tableView estimatedHeightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 44;
}


#pragma mark - Getters

- (void) setCellIdentifier: (NSString *) cellIdentifier {
    _cellIdentifier = [cellIdentifier mutableCopy];
    self.prototype = [self.tableView dequeueReusableCellWithIdentifier: _cellIdentifier];
    [self.tableView reloadData];
}


- (DPTableViewCell *) prototype {
    if (_prototype == nil) {
        _prototype = [self.tableView dequeueReusableCellWithIdentifier: _cellIdentifier];
    }
    return _prototype;
}

@end