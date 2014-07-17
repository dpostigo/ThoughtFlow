//
// Created by Dani Postigo on 7/17/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <TWRBorderedView/TWRBorderedView.h>
#import "TFNewToolbarViewController.h"
#import "UIColor+TFApp.h"
#import "TFMenuButton.h"
#import "UIControl+BlocksKit.h"


CGFloat const TFToolbarButtonWidth = 60;
CGFloat const TFToolbarButtonHeight = 60;

@interface TFNewToolbarViewController ()

@property(nonatomic) CGFloat homeButtonHeight;
@property(nonatomic) CGFloat interitemSpacing;
@property(nonatomic, strong) NSArray *buttons;
@end

@implementation TFNewToolbarViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        _interitemSpacing = ALT_STYLING ? TFToolbarButtonHeight : TFToolbarButtonHeight * 2;
        _homeButtonHeight = TFToolbarButtonHeight * 1.75;
    }

    return self;
}

#pragma mark - View lifecycle

- (void) loadView {

    if (ALT_STYLING) {
        self.view = [[TWRBorderedView alloc] initWithFrame: CGRectMake(0, 0, 300, 300) borderWidth: 0.5 color: [UIColor tfToolbarBorderColor] andMask: TWRBorderMaskRight];
    } else {
        self.view = [[UIView alloc] init];
        self.view.backgroundColor = [UIColor colorWithWhite: 0.1 alpha: 1.0];
    }
    //    self.view.backgroundColor = [UIColor clearColor];
    //    self.view.opaque = NO;
    [self _setup];
}


#pragma mark - Public

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
    [self _setupConstraints];
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

    _buttons = array;
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



- (void) _setupConstraints {
    [self _setupConstraintsForButtons];
    [self _setupTopConstraints];
    [self _setupBottomConstraints];

}

- (void) _setupConstraintsForButtons {
    for (int j = 0; j < [_buttons count]; j++) {
        TFMenuButton *button = _buttons[j];
        TFToolbarButtonType type = (TFToolbarButtonType) j;

        CGFloat buttonHeight = type == TFToolbarButtonTypeHome ? _homeButtonHeight : TFToolbarButtonHeight;

        [self.view addConstraints: @[
                [NSLayoutConstraint constraintWithItem: button attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0.0],
                [NSLayoutConstraint constraintWithItem: button attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0],
        ]];

        [button addConstraint: [NSLayoutConstraint constraintWithItem: button attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: buttonHeight]];

    }
}

- (void) _setupTopConstraints {
    UIButton *homeButton = [self buttonForType: TFToolbarButtonTypeHome];
    UIButton *projectsButton = [self buttonForType: TFToolbarButtonTypeProjects];
    UIButton *notesButton = [self buttonForType: TFToolbarButtonTypeNotes];
    UIButton *moodboardButton = [self buttonForType: TFToolbarButtonTypeMoodboard];

    [self.view addConstraints: @[
            [NSLayoutConstraint constraintWithItem: homeButton attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.topLayoutGuide attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: homeButton attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: projectsButton attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: projectsButton attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: homeButton attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: projectsButton attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: notesButton attribute: NSLayoutAttributeTop multiplier: 1.0 constant: -_interitemSpacing],

            [NSLayoutConstraint constraintWithItem: notesButton attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: projectsButton attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: _interitemSpacing],
            [NSLayoutConstraint constraintWithItem: notesButton attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: moodboardButton attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],

            [NSLayoutConstraint constraintWithItem: moodboardButton attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: notesButton attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0],
    ]];

}

- (void) _setupBottomConstraints {
    UIButton *infoButton = [self buttonForType: TFToolbarButtonTypeInfo];
    UIButton *accountButton = [self buttonForType: TFToolbarButtonTypeAccount];
    UIButton *imageSettingsButton = [self buttonForType: TFToolbarButtonTypeImageSettings];

    [self.view addConstraints: @[
            [NSLayoutConstraint constraintWithItem: infoButton attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self.bottomLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: infoButton attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: accountButton attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: accountButton attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: infoButton attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: accountButton attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: imageSettingsButton attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: imageSettingsButton attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: accountButton attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],

    ]];

}

#pragma mark - Notify

- (void) _notifyButtonClickedWithType: (TFToolbarButtonType) type {
    if (_delegate && [_delegate respondsToSelector: @selector(toolbarControllerClickedButtonWithType:)]) {
        [_delegate toolbarControllerClickedButtonWithType: type];
    }
}
@end