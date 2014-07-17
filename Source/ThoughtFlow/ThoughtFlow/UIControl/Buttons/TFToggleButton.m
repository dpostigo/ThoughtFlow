//
// Created by Dani Postigo on 5/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFToggleButton.h"


@implementation TFToggleButton

- (void) awakeFromNib {
    [super awakeFromNib];

    if (!_toggleDisabled) {
        [self addTarget: self action: @selector(handleToggle:) forControlEvents: UIControlEventTouchUpInside];
    }
}

- (void) handleToggle: (id) sender {
    self.selected = !self.selected;

}


@end