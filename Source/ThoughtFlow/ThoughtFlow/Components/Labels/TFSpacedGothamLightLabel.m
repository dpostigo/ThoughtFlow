//
// Created by Dani Postigo on 6/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFSpacedGothamLightLabel.h"
#import "UIFont+DPKitFonts.h"


@implementation TFSpacedGothamLightLabel

- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {
        self.fontAttribute = [UIFont gothamRoundedLightFontOfSize: [UIFont systemFontSize]];
    }

    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];

    self.font = [UIFont gothamRoundedLightFontOfSize: self.font.pointSize];
}


+ (CGFloat) lineSpacing {
    return 100 / 12;
}


- (CGSize) intrinsicContentSize {
    CGSize ret = [super intrinsicContentSize];

    CGFloat lineSpacing = [[self class] lineSpacing];
    CGFloat minHeight = self.font.pointSize + lineSpacing;
    //    CGFloat minHeight = self.font.pointSize;

    return CGSizeMake(ret.width, fmaxf(ret.height + lineSpacing, minHeight));
    //    return CGSizeMake(ret.width, fmaxf(ret.height, minHeight));
}




//- (NSDictionary *) defaultAttributes {
//
//    NSLog(@"self.fontAttribute = %@", self.fontAttribute);
//
//    NSDictionary *attributes = nil;
//    CGFloat pointSize = self.font.pointSize;
//    CGFloat kerningSize = (self.kerning == 0 ? [[self class] defaultClassKerning] : self.kerning) * (pointSize / 1000);
//
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = [[self class] lineSpacing];
//    paragraphStyle.alignment = self.textAlignment;
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//
//    attributes = @{
//            NSForegroundColorAttributeName : self.textColor,
//            NSFontAttributeName : self.fontAttribute,
//            NSKernAttributeName : @(kerningSize),
//            NSParagraphStyleAttributeName : paragraphStyle
//    };
//
//    return attributes;
//
//}

@end