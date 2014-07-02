//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFMoodboardViewController.h"
#import "Project.h"
#import "TFMoodboardGridViewController.h"


@implementation TFMoodboardViewController

- (instancetype) initWithProject: (Project *) project {
    TFMoodboardGridViewController *controller = [[TFMoodboardGridViewController alloc] initWithProject: project];
    self = [super initWithRootViewController: controller];
    if (self) {
        _project = project;
        self.navigationBarHidden = YES;
    }

    return self;
}

//
//- (void) viewDidLoad {
//    [super viewDidLoad];
//
//    [self _setupView];
//    [self _setupControllers];
//    [self _setupProject];
//
//}
//
//
//#pragma mark - TFImageGridViewControllerDelegate
//
//- (void) imageGridViewController: (TFImageGridViewController *) controller dequeuedCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
//    [cell.bottomRightButton setImage: [UIImage imageNamed: @"remove-button"] forState: UIControlStateNormal];
//    [controller addTargetToButton: cell.bottomRightButton];
//}
//
//- (void) imageGridViewController: (TFImageGridViewController *) controller didClickButton: (UIButton *) button inCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
//    TFPhoto *image = [_imagesController.images objectAtIndex: indexPath.item];
//    [_project.pinnedImages removeObject: image];
//}
//
//
//- (void) imageGridViewController: (TFImageGridViewController *) gridController didSelectImage: (TFPhoto *) image atIndexPath: (NSIndexPath *) indexPath {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//
//    TFMoodboardFullscreenViewController *controller = [[TFMoodboardFullscreenViewController alloc] init];
//    [self.navigationController pushViewController: controller animated: YES];
//
//}
//
//
//#pragma mark - Setup
//
//- (void) _setupControllers {
//
//    _emptyController = [[TFEmptyViewController alloc] initWithTitle: @"You don't have any pins in your moodboard."];
//    [self embedFullscreenController: _emptyController];
//
//    _imagesController = [[TFImageGridViewController alloc] init];
//    _imagesController.delegate = self;
//    [self embedFullscreenController: _imagesController];
//}
//
//- (void) _setupProject {
//
//    if (_project) {
//        if ([_project.pinnedImages count] == 0) {
//            _imagesController.view.hidden = YES;
//
//        } else {
//            _emptyController.view.hidden = YES;
//            _imagesController.images = _project.pinnedImages;
//
//        }
//    }
//}
//
//- (void) _setupView {
//    self.view.backgroundColor = [UIColor clearColor];
//    self.view.opaque = NO;
//}

@end