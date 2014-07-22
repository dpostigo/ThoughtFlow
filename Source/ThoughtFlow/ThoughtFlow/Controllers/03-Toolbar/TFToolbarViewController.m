//
// Created by Dani Postigo on 7/17/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <TWRBorderedView/TWRBorderedView.h>
#import "TFToolbarViewController.h"
#import "UIColor+TFApp.h"
#import "TFMenuButton.h"
#import "UIControl+BlocksKit.h"


@interface TFToolbarViewController ()

@property(nonatomic, strong) NSArray *buttons;
@end

@implementation TFToolbarViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
    }

    return self;
}

#pragma mark - View lifecycle

- (void) loadView {
    if (ALT_STYLING) {
        self.view = [[TWRBorderedView alloc] initWithFrame: CGRectMake(0, 0, 300, 300) borderWidth: 0.5 color: [UIColor tfToolbarBorderColor] andMask: TWRBorderMaskRight];
    } else {
        self.view = [[UIView alloc] init];
    }

    self.view.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.4];
    self.view.backgroundColor = [[UIColor tfToolbarBackgroundColor] colorWithAlphaComponent: 0.5];
    self.view.opaque = NO;

    [self _setup];
}


#pragma mark - Public

- (void) setButtons: (NSArray *) buttons {
    _buttons = buttons;
    self.items = _buttons;
}

- (UIButton *) buttonForType: (TFToolbarButtonType) type {
    return [_buttons objectAtIndex: type];
}


- (void) setSelectedIndex: (NSInteger) selectedIndex {
    _selectedIndex = selectedIndex;

    [_buttons enumerateObjectsUsingBlock: ^(UIButton *button, NSUInteger index, BOOL *stop) {
        button.selected = index == _selectedIndex ? YES : NO;
    }];

}




#pragma mark - Setup




- (void) _setup {
    [self _setupButtons];
    //    [self _setupConstraints];
}

- (void) _setupButtons {

    [self _setupButtonInit];
    [self _setupButtonImages];
    [self _setupButtonBorders];
    [self _setupButtonHandlers];
}


- (void) _setupButtonInit {
    int count = TFToolbarButtonTypeInfo + 1;

    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int j = 0; j < count; j++) {
        TFToolbarButtonType type = (TFToolbarButtonType) j;
        TFMenuButton *button = [TFMenuButton buttonWithType: UIButtonTypeCustom];
        button.tag = type;
        [array addObject: button];
        [self.view addSubview: button];

        button.translatesAutoresizingMaskIntoConstraints = NO;
    }

    self.buttons = array;
}

- (void) _setupButtonImages {

    for (int j = 0; j < [_buttons count]; j++) {
        NSString *imageString = nil;
        TFMenuButton *button = _buttons[j];
        TFToolbarButtonType type = (TFToolbarButtonType) j;

        switch (type) {

            case TFToolbarButtonTypeHome : {
                imageString = @"home";
                break;
            }
            case TFToolbarButtonTypeProjects : {
                imageString = @"projects";

                break;
            }
            case TFToolbarButtonTypeNotes : {
                imageString = @"notes";
                break;
            }
            case TFToolbarButtonTypeMoodboard : {
                imageString = @"moodboard";

                break;
            }
            case TFToolbarButtonTypeImageSettings : {
                imageString = @"settings";

                break;
            }
            case TFToolbarButtonTypeAccount : {
                imageString = @"user";
                break;
            }
            case TFToolbarButtonTypeInfo : {
                imageString = @"info";
                break;
            }
        }

        NSString *imageFormat = @"icon-toolbar-%@";
        NSString *imageFormatActive = @"icon-toolbar-%@-active";
        [button setImage: [UIImage imageNamed: [NSString stringWithFormat: imageFormat, imageString]] forState: UIControlStateNormal];
        [button setImage: [UIImage imageNamed: [NSString stringWithFormat: imageFormatActive, imageString]] forState: UIControlStateSelected];

    }

}

- (void) _setupButtonBorders {

    for (int j = 0; j < [_buttons count]; j++) {
        TFMenuButton *button = _buttons[j];
        TFToolbarButtonType type = (TFToolbarButtonType) j;

        switch (type) {

            case TFToolbarButtonTypeNotes :
            case TFToolbarButtonTypeImageSettings : {
                button.borderedView.mask = TWRBorderMaskTop | TWRBorderMaskBottom;
                break;
            }

            default : {

                break;
            }
        }
    }

}


- (void) _setupButtonHandlers {

    for (int j = 0; j < [_buttons count]; j++) {
        TFMenuButton *button = _buttons[j];
        TFToolbarButtonType type = (TFToolbarButtonType) j;

        [button bk_addEventHandler: ^(id sender) {
            NSInteger tag = button.tag;
            button.selected = !button.selected;
            [self _notifyButtonClickedWithType: (TFToolbarButtonType) tag];

        } forControlEvents: UIControlEventTouchUpInside];
    }
}

#pragma mark - Setup constraints


#pragma mark - Notify

- (void) _notifyButtonClickedWithType: (TFToolbarButtonType) type {
    if (_delegate && [_delegate respondsToSelector: @selector(toolbarControllerClickedButtonWithType:)]) {
        [_delegate toolbarControllerClickedButtonWithType: type];
    }
}
@end