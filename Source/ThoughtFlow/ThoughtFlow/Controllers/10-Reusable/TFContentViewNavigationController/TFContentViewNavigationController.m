//
// Created by Dani Postigo on 7/1/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFContentViewNavigationController.h"
#import "TFContentView.h"


@implementation TFContentViewNavigationController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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


#pragma mark - View lifecycle

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    if (self.rightContainerIsOpen) {
        [self.rightDrawerController viewDidAppear: animated];
    }
    if (self.leftContainerIsOpen) {
        [self.leftDrawerController viewDidAppear: animated];
    }

}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    if (self.rightContainerIsOpen) {
        [self.rightDrawerController viewWillAppear: animated];
    }
    if (self.leftContainerIsOpen) {
        [self.leftDrawerController viewWillAppear: animated];
    }
}


- (void) viewWillDisappear: (BOOL) animated {
    [super viewWillDisappear: animated];

    if (self.rightContainerIsOpen) {
        [self.rightDrawerController viewWillDisappear: animated];
    }
    if (self.leftContainerIsOpen) {
        [self.leftDrawerController viewWillDisappear: animated];
    }

    if (_autocloses) {
        if (self.leftContainerIsOpen) {
            [self closeLeftContainer];
        }

        if (self.rightContainerIsOpen) {
            [self closeRightContainer];
        }
    }
}


- (void) viewDidDisappear: (BOOL) animated {
    [super viewDidDisappear: animated];

    if (self.rightContainerIsOpen) {
        [self.rightDrawerController viewDidDisappear: animated];
    }
    if (self.leftContainerIsOpen) {
        [self.leftDrawerController viewDidDisappear: animated];
    }

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
    [self.leftDrawerController willMoveToParentViewController: self.parentViewController];
    [self.contentView openLeftContainer: ^() {
        [self.leftDrawerController didMoveToParentViewController: self.parentViewController];
    }];
}

- (void) openRightContainer {
    [self.rightDrawerController willMoveToParentViewController: self.parentViewController];
    [self.contentView openRightContainer: ^() {
        [self.rightDrawerController didMoveToParentViewController: self.parentViewController];
    }];

}

- (void) closeLeftContainer {
    [self.contentView closeLeftContainer: ^{
        //        [self.leftDrawerController didMoveToParentViewController: nil];

    }];
}

- (void) closeRightContainer {
    [self.contentView closeRightContainer: ^{
        //        [self.rightDrawerController didMoveToParentViewController: nil];

    }];

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