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

@implementation ProjectsController

@synthesize collection;

- (void) viewDidLoad {
    [super viewDidLoad];

    collection.delegate = self;
    collection.dataSource = self;
    //    collection.layout

    //    ((UICollectionViewFlowLayout *) collection.collectionViewLayout).minimumLineSpacing = 0.0f;
    //    ((UICollectionViewFlowLayout *) collection.collectionViewLayout).scrollDirection = UICollectionViewScrollDirectionHorizontal;
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


    //    collection.scroll
}


#pragma mark IBActions

- (IBAction) handleNewProject: (id) sender {
    [self.navigationController popViewControllerAnimated: YES];
}
#pragma mark UICollectionViewDelegateFlowLayout


#pragma mark UICollectionView

- (void) collectionView: (UICollectionView *) collectionView didSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    _model.selectedProject = [self projectForIndexPath: indexPath];
    [[NSNotificationCenter defaultCenter] postNotificationName: TFToolbarMindmapNotification object: nil];
    [self performSegueWithIdentifier: @"MindmapSegue" sender: nil];

}


- (NSInteger) collectionView: (UICollectionView *) collectionView numberOfItemsInSection: (NSInteger) section {
    return [_model.projects count];
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    UICollectionViewCell *ret = [collection dequeueReusableCellWithReuseIdentifier: @"CollectionCell"
                                                                      forIndexPath: indexPath];

    [ret convertFonts];

    if ([ret isKindOfClass: [TFProjectCollectionViewCell class]]) {

        TFProjectCollectionViewCell *cell = (TFProjectCollectionViewCell *) ret;
        Project *project = [self projectForIndexPath: indexPath];
        if (project) {
            cell.firstWordField.text = project.word;
        }
        cell.button.tag = indexPath.item;
        [cell.button addTarget: self action: @selector(handleTrashButton:)
              forControlEvents: UIControlEventTouchUpInside];
    }

    return ret;
}

- (void) handleTrashButton: (UIButton *) button {

    TFProjectCollectionViewCell *cell = (TFProjectCollectionViewCell *) button.superview.superview;
    if (cell) {
        NSLog(@"cell = %@", cell);
        NSIndexPath *indexPath = [collection indexPathForCell: cell];
        Project *project = [self projectForIndexPath: indexPath];

        [_model.projectLibrary removeItem: project];
        [collection deleteItemsAtIndexPaths: @[indexPath]];

    }

}

- (Project *) projectForIndexPath: (NSIndexPath *) indexPath {
    Project *ret = nil;
    ret = [_model.projectsSortedByDate objectAtIndex: indexPath.item];
    return ret;
}


@end