//
// Created by Dani Postigo on 4/28/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <UIAlertView+Blocks/UIAlertView+Blocks.h>
#import <DPKit-Utils/UIViewController+DPKit.h>
#import <DPKit-Utils/UIView+DPKit.h>
#import <BlocksKit/UIControl+BlocksKit.h>
#import "ProjectsController.h"
#import "Model.h"
#import "TFProjectCollectionViewCell.h"
#import "Project.h"
#import "ProjectLibrary.h"
#import "APIModel.h"
#import "TFMindmapViewController.h"
#import "CreateProjectController.h"
#import "TFLibrary.h"


@implementation ProjectsController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    return [self viewControllerFromStoryboard: @"Storyboard"];
}




#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setup];
    _collection.delegate = self;
    _collection.dataSource = self;
    [_collection reloadData];

    [self _refreshCollectionAlignment: NO];
}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    if (_model.selectedProject) {

    }

}

- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

}


- (void) _refreshCollectionAlignment: (BOOL) animated {
    NSUInteger projectCount = [[APIModel sharedModel].projects count];
    NSLog(@"projectCount = %u", projectCount);
    if (_collection.contentSize.width < self.view.width && projectCount < 3) {
        CGFloat differenceX = self.view.width - _collection.contentSize.width;
        //        _collection.contentOffset = CGPointMake(-differenceX / 2, 0);
        [_collection setContentOffset: CGPointMake(-differenceX / 2, 0) animated: animated];
    }
}


- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self _refreshCollectionAlignment: YES];
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
    TFProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"CollectionCell"
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
        NSIndexPath *indexPath = [_collection indexPathForCell: cell];
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
    [_collection deleteItemsAtIndexPaths: @[indexPath]];

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


- (void) _setupButtons {

    [_addProjectButton bk_addEventHandler: ^(id sender) {

        CreateProjectController *controller = [[CreateProjectController alloc] init];
        [self.navigationController setViewControllers: @[controller] animated: YES];

    } forControlEvents: UIControlEventTouchUpInside];

}
@end