//
// Created by Dani Postigo on 4/28/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <UIAlertView+Blocks/UIAlertView+Blocks.h>
#import <DPKit-Utils/UIViewController+DPKit.h>
#import "ProjectsController.h"
#import "Model.h"
#import "UIView+TFFonts.h"
#import "TFProjectCollectionViewCell.h"
#import "Project.h"
#import "TFConstants.h"
#import "ProjectLibrary.h"
#import "APIModel.h"
#import "APIUser.h"
#import "UIViewController+TFControllers.h"
#import "TFMindmapViewController.h"
#import "CreateProjectController.h"


@implementation ProjectsController

@synthesize collection;

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    return [self viewControllerFromStoryboard: @"Storyboard"];
}




#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setup];
    collection.delegate = self;
    collection.dataSource = self;
    [collection reloadData];

}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    if (_model.selectedProject) {

        //        NSUInteger index = [_model.projects indexOfObject: _model.selectedProject];
        //        NSIndexPath *indexPath = [NSIndexPath indexPathForItem: index
        //                                                     inSection: 0];
        //
        //
        //        CGFloat collectionViewHeight = 450;
        //        collection.contentInset = UIEdgeInsetsMake(collectionViewHeight / 2, 0, collectionViewHeight / 2, 0);
        //
        //        UICollectionViewCell *cell = [collection cellForItemAtIndexPath: indexPath];
        //
        //
        //        CGPoint startingOffset = CGPointMake(700, 0);
        //        [collection setContentOffset: startingOffset animated: YES];

    }

}

- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    [collection reloadData];
}



#pragma mark IBActions

- (IBAction) handleNewProject: (id) sender {
    CreateProjectController *controller = [[CreateProjectController alloc] init];
    [self.navigationController setViewControllers: @[controller] animated: YES];
}


#pragma mark - Delegates

#pragma mark - UICollectionViewDelegate


- (void) collectionView: (UICollectionView *) collectionView didSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    Project *project = [self projectForIndexPath: indexPath];
    _model.selectedProject = project;

    [self postNavigationNotificationForType: TFControllerMindmap pushes: NO];

    TFMindmapViewController *controller = [[TFMindmapViewController alloc] initWithProject: _model.selectedProject];
    [self.navigationController pushViewController: controller animated: YES];

}


- (NSInteger) collectionView: (UICollectionView *) collectionView numberOfItemsInSection: (NSInteger) section {
    return [_model.projects count];
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    TFProjectCollectionViewCell *cell = [collection dequeueReusableCellWithReuseIdentifier: @"CollectionCell"
            forIndexPath: indexPath];


    Project *project = [self projectForIndexPath: indexPath];
    if (project) {
        cell.project = project;
    }
    cell.button.tag = indexPath.item;
    [cell.button addTarget: self action: @selector(handleTrashButton:)
            forControlEvents: UIControlEventTouchUpInside];

    return cell;
}

- (void) handleTrashButton: (UIButton *) button {

    TFProjectCollectionViewCell *cell = (TFProjectCollectionViewCell *) button.superview.superview;
    if (cell) {
        NSIndexPath *indexPath = [collection indexPathForCell: cell];
        Project *project = [self projectForIndexPath: indexPath];

        [UIAlertView showWithTitle: @"Delete Project"
                message: @"Are you sure you'd like to delete this project?"
                cancelButtonTitle: @"Cancel" otherButtonTitles: @[@"Yes, Delete"]
                tapBlock: ^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex != alertView.cancelButtonIndex) {
                        [self deleteProject: project atIndexPath: indexPath];
                    }
                }];
    }
}


- (void) deleteProject: (Project *) project atIndexPath: (NSIndexPath *) indexPath {
    [_model.projectLibrary removeChild: project];
    [collection deleteItemsAtIndexPaths: @[indexPath]];

    if ([_model.projects count] == 0) {
        [self postNavigationNotificationForType: TFControllerCreateProject pushes: YES];
    }

}

- (Project *) projectForIndexPath: (NSIndexPath *) indexPath {
    Project *ret = nil;
    ret = [_model.projectsSortedByDate objectAtIndex: indexPath.item];
    return ret;
}


#pragma mark - Private

- (void) _setup {
    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor clearColor];

    self.navigationController.view.opaque = NO;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}

@end