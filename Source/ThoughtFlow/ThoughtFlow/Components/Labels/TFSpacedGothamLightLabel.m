//
// Created by Dani Postigo on 6/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFSpacedGothamLightLabel.h"
#import "UIFont+DPKitFonts.h"

@implementation TFSpacedGothamLightLabel



- (void) awakeFromNib {
    [super awakeFromNib];

    self.font = [UIFont gothamRoundedFontOfSize: self.font.pointSize];
}


+ (CGFloat) lineSpacing {
    return 20 / 12;
}

@end