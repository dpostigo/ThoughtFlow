//
// Created by Dani Postigo on 7/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFSpacedGothamLightButton.h"
#import "TFSpacedGothamLightLabel.h"
#import "TFKernedGothamLightLabel.h"


@implementation TFSpacedGothamLightButton

- (void) setTitleColor: (UIColor *) color forState: (UIControlState) state {
    [super setTitleColor: color forState: state];
    self.prototype.textColor = color;
    [self _refreshTitle];
}


- (void) setTitle: (NSString *) title forState: (UIControlState) state {
    [super setTitle: title forState: state];
    [self setAttributedTitle: [self attributedTitleForString: title] forState: state];
}


- (void) _refreshTitle {
    [self setTitle: [self titleForState: UIControlStateNormal] forState: UIControlStateNormal];
}


- (NSAttributedString *) attributedTitleForString: (NSString *) title {
    self.prototype.text = title;
    return self.prototype.attributedText;
}


- (TFSpacedGothamLightLabel *) prototype {
    if (_prototype == nil) {
        _prototype = [[TFSpacedGothamLightLabel alloc] init];
    }
    return _prototype;
}

@end