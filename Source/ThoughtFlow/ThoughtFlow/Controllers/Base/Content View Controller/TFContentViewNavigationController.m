//
// Created by Dani Postigo on 7/1/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFContentViewNavigationController.h"
#import "TFContentView.h"


@implementation TFContentViewNavigationController

- (void) viewWillDisappear: (BOOL) animated {
    [super viewWillDisappear: animated];

    if (_autocloses) {
        if (self.leftContainerIsOpen) {
            [self closeLeftContainer];
        }

        if (self.rightContainerIsOpen) {
            [self closeRightContainer];
        }
    }
}


- (void) toggleViewController: (UIViewController *) controller animated: (BOOL) flag {
    if (self.visibleViewController == controller || [self.visibleViewController isKindOfClass: [controller class]]) {
        [self popViewControllerAnimated: flag];
    } else {
        [self pushViewController: controller animated: flag];
    }
}


- (BOOL) leftContainerIsOpen {
    return _contentView.leftContainerIsOpen;
}

- (BOOL) rightContainerIsOpen {
    return _contentView.rightContainerIsOpen;
}

- (BOOL) isOpen {
    return _contentView.isOpen;
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

- (void) closeLeftContainer {
    [self.contentView closeLeftContainer];
}

- (void) closeRightContainer {
    [self.contentView closeRightContainer];

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