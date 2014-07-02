//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import <DPKit-Utils/UIView+DPKitDebug.h>
#import <DPKit-Utils/UIView+DPKit.h>
#import "TFMindmapGridViewController.h"
#import "TFEmptyViewController.h"
#import "APIModel.h"
#import "TFImageGridViewCell.h"
#import "TFPhoto.h"
#import "Project.h"


@implementation TFMindmapGridViewController

- (instancetype) initWithProject: (Project *) project imageString: (NSString *) imageString {
    self = [super init];
    if (self) {
        _project = project;
        _imageString = imageString;
    }

    return self;
}

+ (instancetype) controllerWithProject: (Project *) project imageString: (NSString *) imageString {
    return [[self alloc] initWithProject: project imageString: imageString];
}

- (instancetype) initWithImageString: (NSString *) imageString {
    self = [super init];
    if (self) {
        _imageString = imageString;
    }

    return self;
}

+ (instancetype) controllerWithImageString: (NSString *) imageString {
    return [[self alloc] initWithImageString: imageString];
}



#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setupControllers];
    [self _setupImages];
}


#pragma mark - Public


- (void) reloadImage: (TFPhoto *) image {
    NSUInteger index = [_imagesController.images indexOfObject: image];
    [self reloadImageAtIndexPath: [NSIndexPath indexPathForItem: index inSection: 0]];
}

- (void) reloadImageAtIndexPath: (NSIndexPath *) indexPath {
    [_imagesController.collection reloadItemsAtIndexPaths: @[indexPath]];
}

#pragma mark - TFImageGridViewControllerDelegate

- (void) imageGridViewController: (TFImageGridViewController *) controller dequeuedCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {

    TFPhoto *photo = [controller.images objectAtIndex: indexPath.item];
    UIImage *image = [UIImage imageNamed: [_project.pinnedImages containsObject: photo] ? @"remove-button" : @"pin-button-icon"];
    [cell.topRightButton setImage: image forState: UIControlStateNormal];
    [controller addTargetToButton: cell.topRightButton];

}

- (void) imageGridViewController: (TFImageGridViewController *) controller didClickButton: (UIButton *) button inCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    TFPhoto *image = [_imagesController.images objectAtIndex: indexPath.item];
    [self _notifyClickedButtonForImage: image];

}




#pragma mark - Setup

- (void) _setupControllers {

    _emptyController = [[TFEmptyViewController alloc] initWithTitle: @"You don't have any pins in your moodboard."];
    [self embedFullscreenController: _emptyController];

    _imagesController = [[TFImageGridViewController alloc] init];
    _imagesController.delegate = self;
    [self embedFullscreenController: _imagesController];

}

- (void) _setupImages {
    if (_imageString) {
        [[APIModel sharedModel] getImages: _imageString success: ^(NSArray *imageArray) {
            _imagesController.images = imageArray;
            //        [self.collection scrollToItemAtIndexPath: [NSIndexPath indexPathForItem: 0 inSection: 0] atScrollPosition: UICollectionViewScrollPositionNone animated: NO];
            //            [UIView animateWithDuration: 0.4 animations: ^{
            //                self.collection.alpha = 1;
            //            }];

        } failure: nil];
    }
}


#pragma mark - Notify

- (void) _notifyClickedButtonForImage: (TFPhoto *) image {
    if (_delegate && [_delegate respondsToSelector: @selector(mindmapGridViewController:clickedButtonForImage:)]) {
        [_delegate mindmapGridViewController: self clickedButtonForImage: image];
    }

}
@end