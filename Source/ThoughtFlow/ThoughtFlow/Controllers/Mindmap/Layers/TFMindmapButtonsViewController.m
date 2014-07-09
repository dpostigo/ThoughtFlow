//
// Created by Dani Postigo on 6/15/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFMindmapButtonsViewController.h"
#import "Project.h"
#import "TFPhoto.h"


@implementation TFMindmapButtonsViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    [_pinButton setImage: [UIImage imageNamed: @"remove-button"] forState: UIControlStateSelected];
}

- (void) updatePinButtonForImage: (TFPhoto *) image inProject: (Project *) project {
    _pinButton.selected = [project.pinnedImages containsObject: image] ? YES : NO;
}

- (UIButton *) buttonForType: (TFMindmapButtonType) type {
    UIButton *ret = nil;

    switch (type) {
        case TFMindmapButtonTypeGrid :
            ret = _gridButton;
            break;

        case TFMindmapButtonTypeInfo :
            ret = _infoButton;
            break;

        case TFMindmapButtonTypePin :
            ret = _pinButton;
            break;
    }

    return ret;
}


#pragma mark IBActions

- (IBAction) handleGridButton: (UIButton *) sender {
    [self _notifyTappedButtonWithType: TFMindmapButtonTypeGrid];
}

- (IBAction) handleInfoButton: (UIButton *) sender {
    [self _notifyTappedButtonWithType: TFMindmapButtonTypeInfo];
}

- (IBAction) handlePinButton: (UIButton *) sender {
    [self _notifyTappedButtonWithType: TFMindmapButtonTypePin];
}


#pragma mark - Notify

- (void) _notifyTappedButtonWithType: (TFMindmapButtonType) type {
    if (_delegate && [_delegate respondsToSelector: @selector(buttonsController:tappedButtonWithType:)]) {
        [_delegate buttonsController: self tappedButtonWithType: type];
    }
}


@end