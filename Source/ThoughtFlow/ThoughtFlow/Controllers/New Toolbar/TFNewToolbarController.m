//
// Created by Dani Postigo on 6/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNewToolbarController.h"


@implementation TFNewToolbarController

- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setupButtons];
}


#pragma mark - Public

- (UIButton *) buttonForType: (TFNewToolbarButtonType) type {
    return [self.buttons objectAtIndex: type];
}

- (void) setSelectedIndex: (NSInteger) selectedIndex {
    _selectedIndex = selectedIndex;

    [_buttons enumerateObjectsUsingBlock: ^(UIButton *button, NSUInteger index, BOOL *stop) {
        button.selected = index == _selectedIndex ? YES : NO;
    }];

}


#pragma mark - Setup

- (void) _setupButtons {
    int count = TFNewToolbarButtonTypeInfo + 1;

    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int j = 0; j < count; j++) {
        UIButton *button = (UIButton *) [_buttonsView viewWithTag: j];
        if (button) {
            [array addObject: button];
            [button addTarget: self action: @selector(handleButton:) forControlEvents: UIControlEventTouchUpInside];

            TFNewToolbarButtonType type = (TFNewToolbarButtonType) j;

            switch (type) {

                case TFNewToolbarButtonTypeHome:
                    break;
                case TFNewToolbarButtonTypeProjects:
                    break;
                case TFNewToolbarButtonTypeNotes : {

                    [button setImage: [UIImage imageNamed: @"icon-toolbar-notes"] forState: UIControlStateNormal];
                    [button setImage: [UIImage imageNamed: @"icon-toolbar-notes-active"] forState: UIControlStateSelected];

                }
                    break;
                case TFNewToolbarButtonTypeMoodboard:
                    break;
                case TFNewToolbarButtonTypeImageSettings:
                    break;
                case TFNewToolbarButtonTypeAccount : {
                    [button setImage: [UIImage imageNamed: @"icon-toolbar-user"] forState: UIControlStateNormal];
                    [button setImage: [UIImage imageNamed: @"icon-toolbar-user-active"] forState: UIControlStateSelected];
                }
                    break;
                case TFNewToolbarButtonTypeInfo:
                    break;
            }
        }
    }

    _buttons = array;
}


- (void) handleButton: (UIButton *) button {
    NSInteger tag = button.tag;
    button.selected = !button.selected;
    [self _notifyButtonClickedWithType: (TFNewToolbarButtonType) tag];

}
#pragma mark - Notify

- (void) _notifyButtonClickedWithType: (TFNewToolbarButtonType) type {
    if (_delegate && [_delegate respondsToSelector: @selector(toolbarControllerClickedButtonWithType:)]) {
        [_delegate toolbarControllerClickedButtonWithType: type];
    }
}
@end