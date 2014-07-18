//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import <DPKit-Utils/UIView+DPKitDebug.h>
#import "TFMoodboardGridViewController.h"
#import "Project.h"
#import "TFImageGridViewCell.h"
#import "TFPhoto.h"
#import "TFMoodboardFullscreenViewController.h"
#import "TFNewEmptyViewController.h"


@interface TFMoodboardGridViewController ()

@property(nonatomic, strong) TFNewEmptyViewController *emptyController;
@end

@implementation TFMoodboardGridViewController

- (instancetype) initWithProject: (Project *) project {
    self = [super init];
    if (self) {
        _project = project;
    }

    return self;
}



#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setupView];
    [self _setupControllers];
    [self _setupProject];

}

- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    [self.view layoutIfNeeded];
}



#pragma mark - Public

- (void) deleteItemAtIndexPath: (NSIndexPath *) indexPath completion: (void (^)()) completion {
    TFPhoto *image = [_imagesController.images objectAtIndex: indexPath.item];

    [_imagesController.collection performBatchUpdates: ^{
        if (image == _imagesController.selectedImage) {
            _imagesController.selectedImage = nil;
        }
        [_project removePin: image];
        NSMutableArray *images = [_imagesController.images mutableCopy];
        [images removeObject: image];
        _imagesController.images = images;
        [_imagesController.collection deleteItemsAtIndexPaths: @[indexPath]];

    } completion: ^(BOOL finished) {
        [self _refreshControllers];
        if (completion) {
            completion();
        }
    }];
}



#pragma mark - TFImageGridViewControllerDelegate

- (void) imageGridViewController: (TFImageGridViewController *) controller dequeuedCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    [cell.bottomRightButton setImage: [UIImage imageNamed: @"remove-button"] forState: UIControlStateNormal];
    [controller addTargetToButton: cell.bottomRightButton];
}

- (void) imageGridViewController: (TFImageGridViewController *) controller didClickButton: (UIButton *) button inCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    [self deleteItemAtIndexPath: indexPath completion: nil];

}


- (void) imageGridViewController: (TFImageGridViewController *) gridController didSelectImage: (TFPhoto *) image atIndexPath: (NSIndexPath *) indexPath {
    TFMoodboardFullscreenViewController *controller = [[TFMoodboardFullscreenViewController alloc] initWithProject: _project];
    controller.selectedImage = image;
    [self.navigationController pushViewController: controller animated: YES];

}



//- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
//    CGFloat cellHeight = collectionView.height / 3;
//    return CGSizeMake(cellHeight, cellHeight);
//}

- (UIEdgeInsets) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout insetForSectionAtIndex: (NSInteger) section {
    return UIEdgeInsetsMake(0, 0, 0, 0);;
}



#pragma mark - Refresh

- (void) _refreshControllers {

    if ([_project.pinnedImages count] == 0) {
        _imagesController.view.hidden = YES;
        _emptyController.view.alpha = 0;
        _emptyController.view.hidden = NO;

        [UIView animateWithDuration: 0.4 animations: ^{
            _emptyController.view.alpha = 1;
        }];

    } else {
        _emptyController.view.hidden = YES;
        _imagesController.images = _project.pinnedImages;
    }

}
#pragma mark - Setup

- (void) _setupView {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
}

- (void) _setupControllers {
    _emptyController = [[TFNewEmptyViewController alloc] initWithText: @"You don't have any pins in your moodboard."];
    [self embedFullscreenController: _emptyController];

    _imagesController = [[TFImageGridViewController alloc] init];
    _imagesController.delegate = self;
    [self embedFullscreenController: _imagesController];
}

- (void) _setupProject {

    if (_project) {
        if ([_project.pinnedImages count] == 0) {
            _imagesController.view.hidden = YES;

        } else {
            _emptyController.view.hidden = YES;
            _imagesController.images = _project.pinnedImages;

        }
    }
}

@end