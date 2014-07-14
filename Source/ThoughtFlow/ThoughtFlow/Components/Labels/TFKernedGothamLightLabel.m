//
// Created by Dani Postigo on 6/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFKernedGothamLightLabel.h"
#import "UIFont+DPKitFonts.h"


@implementation TFKernedGothamLightLabel

- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {
        self.fontAttribute = [UIFont gothamRoundedLightFontOfSize: [UIFont systemFontSize]];
    }

    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];

    //    [UIFont registerFontWithResourceName:@"GothamRnd-Book" extension:@"otf" ];
    self.font = [UIFont gothamRoundedFontOfSize: self.font.pointSize];
}


+ (UIFont *) font {
    return [UIFont gothamRoundedLightFontOfSize: 12.0];
}

+ (CGFloat) defaultClassKerning {
    return 100;
}


@end