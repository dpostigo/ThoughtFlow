//
// Created by Dani Postigo on 5/11/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-UIView/UIView+DPConstraints.h>
#import "MindmapGridController.h"
#import "TFMoodboardCollectionViewCell.h"
#import "Model.h"
#import "TFNode.h"
#import "APIModel.h"
#import "MinimizedLayerController.h"
#import "UIViewController+TFControllers.h"

@implementation MindmapGridController

- (void) viewDidLoad {
    [super viewDidLoad];

    MinimizedLayerController *controller = (MinimizedLayerController *) self.minimizedLayerController;
    [controller.nodeButton addTarget: self action: @selector(handleNodeDown:) forControlEvents: UIControlEventTouchUpInside];
    UIView *view = controller.view;
    [self addChildViewController: controller];
    [self.view addSubview: view];

    view.frame = self.view.bounds;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view updateSuperLeadingConstraint: 0];
    [view updateSuperTrailingConstraint: 0];
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.topLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0]];
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: view attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self.bottomLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0]];

    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor blackColor];
    self.collection.alpha = 0;

    NSString *imageString = _model.selectedNode.title;
    [_apiModel getImages: imageString success: ^(NSArray *imageArray) {
        self.images = imageArray;
        [self.collection reloadData];
        //        [self.collection scrollToItemAtIndexPath: [NSIndexPath indexPathForItem: 0 inSection: 0] atScrollPosition: UICollectionViewScrollPositionNone animated: NO];
        [UIView animateWithDuration: 0.4 animations: ^{
            self.collection.alpha = 1;
        }];

    } failure: nil];
}


- (void) handleNodeDown: (id) sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    TFMoodboardCollectionViewCell *cell = (TFMoodboardCollectionViewCell *) [super collectionView: collectionView cellForItemAtIndexPath: indexPath];

    [cell.button setImage: [UIImage imageNamed: @"heart-button-icon"] forState: UIControlStateNormal];
    return cell;
}

@end