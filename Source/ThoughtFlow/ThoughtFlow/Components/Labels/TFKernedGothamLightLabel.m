//
// Created by Dani Postigo on 6/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFKernedGothamLightLabel.h"
#import "UIFont+DPKitFonts.h"

@implementation TFKernedGothamLightLabel

- (void) awakeFromNib {
    [super awakeFromNib];

    //    [UIFont registerFontWithResourceName:@"GothamRnd-Book" extension:@"otf" ];
    self.font = [UIFont gothamRoundedFontOfSize: self.font.pointSize];
}

+ (CGFloat) kerning {
    return 100;
}



@end