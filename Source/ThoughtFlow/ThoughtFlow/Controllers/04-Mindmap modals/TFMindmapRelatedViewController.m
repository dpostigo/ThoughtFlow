//
// Created by Dani Postigo on 7/6/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import <BlocksKit/UIControl+BlocksKit.h>
#import "TFMindmapRelatedViewController.h"
#import "TFNode.h"
#import "UIViewController+DPKit.h"
#import "TFTableViewCell.h"
#import "APIModel.h"
#import "TFTopic.h"
#import "NSObject+Delay.h"


static NSString *TFRelatedCellIdentifier = @"RelatedCell";

@interface TFMindmapRelatedViewController ()

@property(nonatomic, strong) NSArray *topics;
@end

@implementation TFMindmapRelatedViewController

- (instancetype) initWithNode: (TFNode *) node {
    self = [super init];
    if (self) {
        _node = node;
        _topics = [NSArray array];

        //
        //        _topics = @[
        //                @{
        //                        @"title" : @"Bull-leaping",
        //                        @"description" : @"Bull-leaping (also taurokathapsia, from Greek) is a motif of Middle Bronze Age figurative art, notably of Minoan Crete, but also found in Hittite Anatolia, the Levant, Bactria and the Indus Valley."
        //                },
        //                @{
        //                        @"title" : @"Correbous",
        //                        @"description" : @"Correbous, correbou or bous al carrer (meaning in Catalan, bulls in the street) is a typical festivity in many villages in the Valencian region, Terres de l'Ebre, Catalonia and Fornalutx, Mallorca."
        //                },
        //                @{
        //                        @"title" : @"Jallikattu",
        //                        @"description" : @"Jallikattu is a bull taming sport played in Tamil Nadu as a part of Pongal celebrations on Mattu Pongal day."
        //                },
        //                @{
        //                        @"title" : @"Jallikattu",
        //                        @"description" : @"Spanish-style bullfighting is called a corrida de toros (literally a \"running of bulls\"), tauromaquía or fiesta brava and is practiced in Spain and Mexico, Colombia, Ecuador, Venezuela, Peru, as well as in Southern France."
        //                }
        //        ];

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

    self.tableViewController.refreshControl = [[UIRefreshControl alloc] init];;
    //    [self.tableViewController.refreshControl bk_addEventHandler: ^(id sender) {
    //        [self _refresh];
    //    } forControlEvents: UIControlEventValueChanged];

    [self.tableViewController.refreshControl beginRefreshing];

    [self _refresh];

}


- (void) _refresh {

    [[APIModel sharedModel] getRelated: _node.title
            success: ^(NSArray *topics) {

                [self.tableViewController.refreshControl endRefreshing];
                self.tableViewController.refreshControl = nil;

                [self performBlock: ^() {

                    NSArray *indexPaths;
                    UITableView *table = self.tableViewController.tableView;
                    [table beginUpdates];

                    indexPaths = [_topics bk_map: ^(NSDictionary *dictionary) {
                        return [NSIndexPath indexPathForRow: [_topics indexOfObject: dictionary] inSection: 0];
                    }];
                    [table deleteRowsAtIndexPaths: indexPaths withRowAnimation: UITableViewRowAnimationRight];

                    if ([topics count] == 0) {
                        _topics = @[@{
                                @"title" : @"",
                                @"description" : @"No results found."
                        }];

                    } else {
                        _topics = [topics bk_map: ^(TFTopic *topic) {
                            return @{
                                    @"title" : topic.title,
                                    @"description" : topic.description
                            };
                        }];

                    }

                    indexPaths = [_topics bk_map: ^(NSDictionary *dictionary) {
                        return [NSIndexPath indexPathForRow: [_topics indexOfObject: dictionary] inSection: 0];
                    }];

                    [table insertRowsAtIndexPaths: indexPaths withRowAnimation: UITableViewRowAnimationFade];
                    [table endUpdates];
                    //                [self.tableViewController reloadData];




                } withDelay: 0.5];

            }
            failure: ^(NSError *error) {
                [self.tableViewController.refreshControl endRefreshing];
            }];
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

    NSDictionary *topic = [_topics objectAtIndex: indexPath.row];
    cell.textLabel.text = [[topic objectForKey: @"title"] uppercaseString];

    UIFont *font = cell.textLabel.font;
    cell.textLabel.font = [UIFont fontWithName: font.fontName size: 18.0];

    NSString *description = [topic objectForKey: @"description"];
    cell.detailTextLabel.text = description;

}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return [_topics count];
}


//
//- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
//    return [_topics count];
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
//    NSDictionary *dictionary = [_topics objectAtIndex: indexPath.row];
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