//
// Created by Dani Postigo on 4/28/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "UILabel+TFFonts.h"
#import "UIFont+ThoughtFlow.h"

@implementation UILabel (TFFonts)

- (void) setKerning: (CGFloat) kerningSize {
    CGFloat pointSize = self.font.pointSize;

    NSDictionary *attributes;
    kerningSize = 60 * (pointSize / 1000);
    attributes = @{
            NSFontAttributeName : self.font,
            NSKernAttributeName : @(kerningSize)
    };

    self.attributedText = [[NSMutableAttributedString alloc] initWithString: self.text attributes: attributes];
}

- (void) convertLabelFonts {
    CGFloat kerningSize = 0;
    CGFloat pointSize = self.font.pointSize;

    NSDictionary *attributes;
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

    if ([self.font.fontName isEqualToString: @"Avenir-Light"]) {
        kerningSize = 60 * (pointSize / 1000);
        attributes = @{
                NSFontAttributeName : [UIFont gothamLight: pointSize],
                NSKernAttributeName : @(kerningSize)
        };

    } else if ([self.font.fontName isEqualToString: @"TimesNewRomanPS-ItalicMT"]) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 25.6 / 18;
        paragraphStyle.alignment = self.textAlignment;
        attributes = @{
                NSFontAttributeName : [UIFont fontWithName: @"Mercury-TextG1Italic" size: pointSize],
                NSKernAttributeName : @(kerningSize),
                NSParagraphStyleAttributeName : paragraphStyle
        };

    } else if ([self.font.fontName isEqualToString: @"Baskerville-Italic"]) {
        //            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //            paragraphStyle.lineSpacing = 25.6 / 18;
        //            paragraphStyle.alignment = label.textAlignment;
        attributes = @{
                NSFontAttributeName : [UIFont fontWithName: @"AGaramondPro-Italic" size: pointSize],
                NSKernAttributeName : @(kerningSize),
                NSParagraphStyleAttributeName : paragraphStyle
        };

    } else {
        //        NSLog(@"font.fontName = %@", font.fontName);
    }

    if (attributes) {
        self.attributedText = [[NSMutableAttributedString alloc] initWithString: self.text attributes: attributes];
        [self sizeToFit];
    }

}

@end