//
// Created by Dani Postigo on 7/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFLabelButton.h"
#import "TFSpacedGothamLightLabel.h"
#import "TFKernedGothamLightLabel.h"


@implementation TFLabelButton

- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
        [self _setup];
    }

    return self;
}


- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self _setup];
    }

    return self;
}


#pragma mark - Setup

- (void) _setup {
    _prototypeClass = [TFSpacedGothamLightLabel class];
    [self _refreshPrototype];
}


#pragma mark - Overrides

- (void) setTitleColor: (UIColor *) color forState: (UIControlState) state {
    [super setTitleColor: color forState: state];
    self.prototype.textColor = color;
    [self _refreshTitle];
}


- (void) setTitle: (NSString *) title forState: (UIControlState) state {
    [super setTitle: title forState: state];
    [self setAttributedTitle: [self attributedTitleForString: title] forState: state];
}


- (NSAttributedString *) attributedTitleForString: (NSString *) title {
    self.prototype.text = title;
    return self.prototype.attributedText;
}


#pragma mark - Setters


- (void) setPrototypeClass: (Class) prototypeClass {
    _prototypeClass = prototypeClass;
    [self _refreshPrototype];
}


#pragma mark - Refresh

- (void) _refreshPrototype {
    _prototype = [[_prototypeClass alloc] init];
}

- (void) _refreshTitle {
    [self setTitle: [self titleForState: UIControlStateNormal] forState: UIControlStateNormal];
}


@end