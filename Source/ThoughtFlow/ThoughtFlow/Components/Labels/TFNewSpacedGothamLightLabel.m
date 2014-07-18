//
// Created by Dani Postigo on 7/17/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNewSpacedGothamLightLabel.h"
#import "UIFont+DPKitFonts.h"


@implementation TFNewSpacedGothamLightLabel

- (void) setupLabel {
    [super setupLabel];

    self.lineSpacing = 100 / 12;
    self.fontName = [UIFont gothamRoundedLightFont].fontName;
    self.kerning = 100;
}



//- (CGSize) intrinsicContentSize {
//    CGSize ret = [super intrinsicContentSize];
//
//    CGFloat minHeight = self.font.pointSize + self.lineSpacing;
//    //    CGFloat minHeight = self.font.pointSize;
//
//    return CGSizeMake(ret.width, fmaxf(ret.height + self.lineSpacing, minHeight));
//    //    return CGSizeMake(ret.width, fmaxf(ret.height, minHeight));
//}
//

@end