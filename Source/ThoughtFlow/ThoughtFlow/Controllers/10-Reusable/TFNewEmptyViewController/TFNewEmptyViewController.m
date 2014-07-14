//
// Created by Dani Postigo on 7/14/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNewEmptyViewController.h"
#import "TFTranslucentView.h"
#import "TFKernedGothamLightLabel.h"
#import "TFSpacedGothamLightLabel.h"


@interface TFNewEmptyViewController ()

@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) UILabel *detailTextLabel;
@property(nonatomic, copy) NSString *text;
@property(nonatomic, copy) NSString *detailText;
@end

@implementation TFNewEmptyViewController

- (instancetype) initWithText: (NSString *) text {
    return [self initWithText: text detailText: @""];
}


- (instancetype) initWithText: (NSString *) aText detailText: (NSString *) aDetailText {
    self = [super init];
    if (self) {
        _text = aText;
        _detailText = aDetailText;
    }

    return self;
}


- (void) loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;

    _textLabel = [[TFKernedGothamLightLabel alloc] init];
    _textLabel.text = _text;
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont fontWithName: _textLabel.font.fontName size: 12.0];
    [self.view addSubview: _textLabel];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;

    _detailTextLabel = [[TFSpacedGothamLightLabel alloc] init];
    _detailTextLabel.text = _detailText;
    _detailTextLabel.textColor = [UIColor whiteColor];
    _detailTextLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview: _detailTextLabel];
    _detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addConstraints: @[
            [NSLayoutConstraint constraintWithItem: _textLabel attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 40.0],
            [NSLayoutConstraint constraintWithItem: _textLabel attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 40.0],

            [NSLayoutConstraint constraintWithItem: _textLabel attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeCenterY multiplier: 1.0 constant: -40.0],
            [NSLayoutConstraint constraintWithItem: _detailTextLabel attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: _textLabel attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _detailTextLabel attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: _textLabel attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _detailTextLabel attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: _textLabel attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0]
    ]];
}

@end