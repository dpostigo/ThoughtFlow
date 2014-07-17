//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFMenuButton.h"
#import "UIColor+TFApp.h"
#import "UIView+DPKit.h"
#import "TWRBorderedView.h"
#import "TWRBorderedView.h"


@implementation TFMenuButton

- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self _setup];
    }

    return self;
}


- (void) awakeFromNib {
    [super awakeFromNib];
    [self _setup];
}


- (void) _setup {

    if (ALT_STYLING) {
        _borderedView = [[TWRBorderedView alloc] initWithFrame: self.bounds
                borderWidth: 0.5
                color: [UIColor tfToolbarBorderColor]
                andMask: TWRBorderMaskBottom];
        _borderedView.backgroundColor = [UIColor clearColor];
        _borderedView.userInteractionEnabled = NO;

        [self embedView: _borderedView];
    }

}
@end