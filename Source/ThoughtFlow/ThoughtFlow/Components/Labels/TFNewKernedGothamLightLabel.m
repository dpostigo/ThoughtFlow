//
// Created by Dani Postigo on 7/17/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-UIFont/UIFont+DPKitFonts.h>
#import "TFNewKernedGothamLightLabel.h"


@implementation TFNewKernedGothamLightLabel

- (void) setupLabel {
    [super setupLabel];

    self.fontName = [UIFont gothamRoundedLightFont].fontName;
    self.kerning = 100;
    self.lineSpacing = 0;
}


@end