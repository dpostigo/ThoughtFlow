//
// Created by Dani Postigo on 7/6/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKitDebug.h>
#import "TFMindmapRelatedViewController.h"
#import "TFNode.h"
#import "TFTranslucentView.h"
#import "UIViewController+DPKit.h"
#import "TFTableViewController.h"
#import "TFTableViewCell.h"


static NSString *TFRelatedCellIdentifier = @"RelatedCell";

@implementation TFMindmapRelatedViewController

- (instancetype) initWithNode: (TFNode *) node {
    self = [super init];
    if (self) {
        _node = node;
        //        _suggestions = [NSArray array];

        _suggestions = @[
                @{
                        @"title" : @"Bull-leaping",
                        @"description" : @"Bull-leaping (also taurokathapsia, from Greek) is a motif of Middle Bronze Age figurative art, notably of Minoan Crete, but also found in Hittite Anatolia, the Levant, Bactria and the Indus Valley."
                },
                @{
                        @"title" : @"Correbous",
                        @"description" : @"Correbous, correbou or bous al carrer (meaning in Catalan, bulls in the street) is a typical festivity in many villages in the Valencian region, Terres de l'Ebre, Catalonia and Fornalutx, Mallorca."
                },
                @{
                        @"title" : @"Jallikattu",
                        @"description" : @"Jallikattu is a bull taming sport played in Tamil Nadu as a part of Pongal celebrations on Mattu Pongal day."
                },
                @{
                        @"title" : @"Jallikattu",
                        @"description" : @"Spanish-style bullfighting is called a corrida de toros (literally a \"running of bulls\"), tauromaquía or fiesta brava and is practiced in Spain and Mexico, Colombia, Ecuador, Venezuela, Peru, as well as in Southern France."
                }
        ];

    }

    return self;
}


- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    return [self viewControllerFromStoryboard: @"Modals"];

}




#pragma mark - View lifecycle


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    [self _setupView];
    _recognizer = [self addTapBehindRecognizer: @selector(handleTapBehind:)];
}


- (void) viewWillDisappear: (BOOL) animated {
    [super viewWillDisappear: animated];
    [self.view.window removeGestureRecognizer: _recognizer];
}


- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setup];

}


#pragma mark - Dismiss

- (void) handleTapBehind: (UITapGestureRecognizer *) recognizer {

    BOOL isBehind = [self recognizerDidTapBehind: recognizer];
    if (isBehind) {
        [self dismissController: nil];
    }
}


- (IBAction) dismissController: (id) sender {
    [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Delegate

#pragma mark - UITableViewDelegate


- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    TFTableViewCell *ret = [tableView dequeueReusableCellWithIdentifier: TFRelatedCellIdentifier forIndexPath: indexPath];
    return ret;
}

- (void) configureCell: (UITableViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    NSDictionary *dictionary = [_suggestions objectAtIndex: indexPath.row];
    cell.textLabel.text = [[dictionary objectForKey: @"title"] uppercaseString];

    UIFont *font = cell.textLabel.font;
    cell.textLabel.font = [UIFont fontWithName: font.fontName size: 18.0];

    NSString *description = [dictionary objectForKey: @"description"];
    cell.detailTextLabel.text = description;

}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return [_suggestions count];
}


//
//- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
//    return [_suggestions count];
//}
//
//- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
//
//    TFTableViewCell *ret = [tableView dequeueReusableCellWithIdentifier: TFTableViewDefaultCellIdentifier forIndexPath: indexPath];
//
//    return ret;
//}
//
//
//- (void) configureCell: (UITableViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
//
//    NSDictionary *dictionary = [_suggestions objectAtIndex: indexPath.row];
//
//    cell.textLabel.text = [dictionary objectForKey: @"title"];
//    cell.detailTextLabel.text = [dictionary objectForKey: @"description"];
//}




#pragma mark - Setup


- (void) _setup {

    [self _setupView];

    [self _setupLabels];

    [self _setupResultsTableView];

    [self _setupDummyData];
}

- (void) _setupLabels {

    _textLabel.text = _node.title;
}

- (void) _setupResultsTableView {

    _tableViewController = [[TFTableViewController alloc] init];
    _tableViewController.delegate = self;
    _tableViewController.cellIdentifier = TFRelatedCellIdentifier;
    [self embedController: _tableViewController inView: _containerView];

}

- (void) _setupDummyData {

}

- (void) _setupView {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;

    _containerView.backgroundColor = [UIColor clearColor];
}


@end