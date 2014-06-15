//
// Created by Dani Postigo on 4/28/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "ProjectsController.h"
#import "Model.h"
#import "UIView+TFFonts.h"
#import "TFProjectCollectionViewCell.h"
#import "Project.h"
#import "TFConstants.h"
#import "ProjectLibrary.h"
#import "APIModel.h"
#import "APIUser.h"

@implementation ProjectsController

@synthesize collection;

- (void) viewDidLoad {
    [super viewDidLoad];

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
        //        CGPoint offset = CGPointMake(700, 0);
        //        [collection setContentOffset: offset animated: YES];

    }

}

- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    [collection reloadData];
}



#pragma mark IBActions

- (IBAction) handleNewProject: (id) sender {
    [self.navigationController popViewControllerAnimated: YES];
}


#pragma mark UICollectionViewDelegateFlowLayout


#pragma mark UICollectionView

- (void) collectionView: (UICollectionView *) collectionView didSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    _model.selectedProject = [self projectForIndexPath: indexPath];

    [self postNavigationNotificationForType: TFControllerMindmap pushes: NO];
    [self performSegueWithIdentifier: @"MindmapSegue" sender: nil];

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

        [_model.projectLibrary removeItem: project];
        [collection deleteItemsAtIndexPaths: @[indexPath]];

        if ([_model.projects count] == 0) {
            [self postNavigationNotificationForType: TFControllerCreateProject pushes: YES];
        }
    }
}

- (Project *) projectForIndexPath: (NSIndexPath *) indexPath {
    Project *ret = nil;
    ret = [_model.projectsSortedByDate objectAtIndex: indexPath.item];
    return ret;
}


@end