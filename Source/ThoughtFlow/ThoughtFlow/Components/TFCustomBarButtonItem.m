//
// Created by Dani Postigo on 7/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFCustomBarButtonItem.h"
#import "TFKernedGothamLightLabel.h"
#import "UIView+DPKit.h"
#import "TFLabelButton.h"
#import "TFSpacedGothamLightLabel.h"


@implementation TFCustomBarButtonItem

- (instancetype) initWithTitle: (NSString *) aTitle image: (UIImage *) anImage {

    TFLabelButton *aButton = [TFLabelButton buttonWithType: UIButtonTypeCustom];

    UILabel *label = aButton.prototype;
    //    aButton.prototypeClass = [TFKernedGothamLightLabel class];
    aButton.prototype.text = aTitle;
    aButton.prototype.font = [UIFont fontWithName: label.font.fontName size: 12.0];
    aButton.prototype.textColor = [UIColor whiteColor];
    [aButton setTitle: aTitle forState: UIControlStateNormal];
    [aButton setImage: anImage forState: UIControlStateNormal];
    aButton.width = 320;
    aButton.height = 44;
    [aButton sizeToFit];

    self = [super initWithCustomView: aButton];
    if (self) {
        _button = aButton;
    }

    return self;
}


@end