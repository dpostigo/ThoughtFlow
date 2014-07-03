//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import "TFNewMindmapGridViewController.h"
#import "Project.h"
#import "TFImageGridViewCell.h"
#import "TFPhoto.h"
#import "TFNewMindmapFullscreenViewController.h"
#import "APIModel.h"


@implementation TFNewMindmapGridViewController

- (instancetype) initWithProject: (Project *) project images: (NSArray *) images {
    self = [super init];
    if (self) {
        _project = project;
        _images = images;
    }

    return self;
}



#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setup];

}



#pragma mark - Public


- (void) setImages: (NSArray *) images {
    _images = images;
    _imagesController.images = _images;
}


#pragma mark - TFImageGridViewControllerDelegate

- (void) imageGridViewController: (TFImageGridViewController *) controller dequeuedCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    cell.overlayView.alpha = 1;
}

- (void) imageGridViewController: (TFImageGridViewController *) controller didClickButton: (UIButton *) button inCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    return;
}


- (void) imageGridViewController: (TFImageGridViewController *) gridController didSelectImage: (TFPhoto *) image atIndexPath: (NSIndexPath *) indexPath {
    TFNewMindmapFullscreenViewController *controller = [[TFNewMindmapFullscreenViewController alloc] initWithProject: _project images: _images];
    [self.navigationController pushViewController: controller animated: YES];

}


#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView {

    //    TFPhoto *image = [_imagesController.images objectAtIndex: <#(NSUInteger)index#>]

}


#pragma mark - Setup


- (void) _setup {
    [self _setupView];
    [self _setupControllers];
    [self _setupProject];
}

- (void) _setupControllers {

    _imagesController = [[TFImageGridViewController alloc] init];
    _imagesController.delegate = self;
    [self embedFullscreenController: _imagesController];
}

- (void) _setupProject {

    if (_project) {

    }
}


- (void) _setupView {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
}

@end