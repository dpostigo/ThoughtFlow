//
// Created by Dani Postigo on 7/1/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFContentNavigationController.h"
#import "TFContentView.h"

@implementation TFContentNavigationController

- (void) toggleViewController: (UIViewController *) controller animated: (BOOL) flag {
    if ([self.visibleViewController isKindOfClass: [controller class]]) {
        [self popViewControllerAnimated: flag];
    } else {
        [self pushViewController: controller animated: flag];
    }
}


- (void) setViewControllers: (NSArray *) viewControllers animated: (BOOL) animated {
    if ([viewControllers count] == 1 && [self.viewControllers count] == 1) {
        UIViewController *controller = viewControllers[0];
        if ([controller isKindOfClass: [self.visibleViewController class]]) {
            return;
        }
    }

    [super setViewControllers: viewControllers animated: animated];
}









#pragma mark - Content view


- (void) setContentView: (TFContentView *) contentView {
    _contentView = contentView;
    _contentView.delegate = self;
}

- (TFNewDrawerController *) leftDrawerController {
    return self.contentView.leftDrawerController;
}

- (void) setLeftDrawerController: (TFNewDrawerController *) leftDrawerController {
    self.contentView.leftDrawerController = leftDrawerController;

}

- (TFNewDrawerController *) rightDrawerController {
    return self.contentView.rightDrawerController;
}

- (void) setRightDrawerController: (TFNewDrawerController *) rightDrawerController {
    self.contentView.rightDrawerController = rightDrawerController;
}

- (void) openLeftContainer {
    [self.contentView openLeftContainer];
}

- (void) openRightContainer {
    [self.contentView openRightContainer];

}

#pragma mark - TFContentViewDelegate





- (void) contentView: (TFContentView *) contentView didCloseLeftController: (TFNewDrawerController *) leftController {
    if (self.delegate && [self.delegate respondsToSelector: @selector(navigationController:didShowViewController:animated:)]) {
        [self.delegate navigationController: self didShowViewController: self.visibleViewController animated: YES];
    }
}

- (void) contentView: (TFContentView *) contentView didCloseRightController: (TFNewDrawerController *) rightController {
    if (self.delegate && [self.delegate respondsToSelector: @selector(navigationController:didShowViewController:animated:)]) {
        [self.delegate navigationController: self didShowViewController: self.visibleViewController animated: YES];
    }
}


@end