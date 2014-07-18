//
// Created by Dani Postigo on 7/17/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFBaseToolbarViewController.h"
#import "UIView+DPKit.h"


CGFloat const TFToolbarButtonWidth = 60;
CGFloat const TFToolbarButtonHeight = 60;

@implementation TFBaseToolbarViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        _interitemSpacing = ALT_STYLING ? TFToolbarButtonHeight : TFToolbarButtonHeight * 2;
        _homeButtonHeight = TFToolbarButtonHeight * 1.75;
    }

    return self;
}


#pragma mark - Public

- (UIView *) itemAtIndex: (NSUInteger) index {
    return [_items objectAtIndex: index];
}

- (void) setItems: (NSArray *) items {

    if (_items) {
        for (int j = 0; j < [_items count]; j++) {
            UIView *item = _items[j];
            [item removeFromSuperview];
        }
    }

    _items = items;

    for (int k = 0; k < [_items count]; k++) {
        UIView *item = _items[k];
        item.tag = k;
        [self.view addSubview: item];
        item.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self _setupConstraints];

}


- (void) _setupConstraints {
    [self _setupConstraintsForButtons];
    [self _setupTopConstraints];
    [self _setupBottomConstraints];

}

- (void) _setupConstraintsForButtons {
    for (int j = 0; j < [_items count]; j++) {
        UIView *button = _items[j];
        NSInteger index = j;

        CGFloat buttonHeight = index == 0 ? _homeButtonHeight : TFToolbarButtonHeight;

        [self.view addConstraints: @[
                [NSLayoutConstraint constraintWithItem: button attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: _insets.left],
                [NSLayoutConstraint constraintWithItem: button attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: -_insets.right],
        ]];

        [button addConstraint: [NSLayoutConstraint constraintWithItem: button attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: buttonHeight]];

    }
}

- (void) _setupTopConstraints {
    UIView *item1 = [self itemAtIndex: 0];
    UIView *projectsButton = [self itemAtIndex: 1];
    UIView *notesButton = [self itemAtIndex: 2];
    UIView *moodboardButton = [self itemAtIndex: 3];

    [self.view addConstraints: @[
            [NSLayoutConstraint constraintWithItem: item1 attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.topLayoutGuide attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: item1 attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: projectsButton attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: projectsButton attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: item1 attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: projectsButton attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: notesButton attribute: NSLayoutAttributeTop multiplier: 1.0 constant: -_interitemSpacing],

            [NSLayoutConstraint constraintWithItem: notesButton attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: projectsButton attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: _interitemSpacing],
            [NSLayoutConstraint constraintWithItem: notesButton attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: moodboardButton attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],

            [NSLayoutConstraint constraintWithItem: moodboardButton attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: notesButton attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0],
    ]];

}

- (void) _setupBottomConstraints {
    NSUInteger count = [_items count];
    UIView *infoButton = [self itemAtIndex: count - 1];
    UIView *accountButton = [self itemAtIndex: count - 2];
    UIView *imageSettingsButton = [self itemAtIndex: count - 3];

    [self.view addConstraints: @[
            [NSLayoutConstraint constraintWithItem: infoButton attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self.bottomLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: infoButton attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: accountButton attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: accountButton attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: infoButton attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: accountButton attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: imageSettingsButton attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: imageSettingsButton attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: accountButton attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],

    ]];

}

@end