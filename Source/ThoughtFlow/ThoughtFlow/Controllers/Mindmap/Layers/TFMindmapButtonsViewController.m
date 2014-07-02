//
// Created by Dani Postigo on 6/15/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFMindmapButtonsViewController.h"



@implementation TFMindmapButtonsViewController



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