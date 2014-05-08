//
// Created by Dani Postigo on 4/28/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "UIFont+ThoughtFlow.h"

@implementation UIFont (ThoughtFlow)

+ (void) printFontNames {
    for (NSString *family in [UIFont familyNames]) {
        NSLog(@"%@", family);

        for (NSString *name in [UIFont fontNamesForFamilyName: family]) {
            NSLog(@"  %@", name);
        }
    }
}

+ (UIFont *) gothamLight: (CGFloat) fontSize {
    return [UIFont fontWithName: @"GothamRounded-Light" size: fontSize];
}


+ (UIFont *) italicSerif: (CGFloat) fontSize {
    return [UIFont fontWithName: @"Mercury-TextG1Italic" size: fontSize];
}

+ (CGFloat) pixelToPoints: (CGFloat) px {
    CGFloat pointsPerInch = 72.0; // see: http://en.wikipedia.org/wiki/Point%5Fsize#Current%5FDTP%5Fpoint%5Fsystem
    CGFloat scale = 1; // We dont't use [[UIScreen mainScreen] scale] as we don't want the native pixel, we want pixels for UIFont - it does the retina scaling for us
    float pixelPerInch; // aka dpi
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        pixelPerInch = 132 * scale;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        pixelPerInch = 163 * scale;
    } else {
        pixelPerInch = 160 * scale;
    }
    CGFloat result = px * pointsPerInch / pixelPerInch;
    return result;
}


+ (NSDictionary *) attributesForFont: (UIFont *) font {
    NSDictionary *ret = nil;
    CGFloat pointSize = font.pointSize;
    CGFloat kerningSize = 0;

    NSMutableParagraphStyle *paragraphStyle;

    if ([font.fontName isEqualToString: @"Avenir-Light"] || [font.fontName isEqualToString: @"GothamRounded-Light"]) {
        kerningSize = 60 * (pointSize / 1000);
        ret = @{
                NSFontAttributeName : [UIFont gothamLight: pointSize],
                NSKernAttributeName : @(kerningSize)
        };

    } else if ([font.fontName isEqualToString: @"TimesNewRomanPS-ItalicMT"] || [font.fontName isEqualToString: @"Mercury-TextG1Italic"]) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 25.6 / 18;
        ret = @{
                NSFontAttributeName : [UIFont fontWithName: @"Mercury-TextG1Italic" size: pointSize],
                NSKernAttributeName : @(kerningSize),
                NSParagraphStyleAttributeName : paragraphStyle
        };

    } else if ([font.fontName isEqualToString: @"Baskerville-Italic"]) {
        paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        ret = @{
                NSFontAttributeName : [UIFont fontWithName: @"AGaramondPro-Italic" size: pointSize],
                NSKernAttributeName : @(kerningSize),
                NSParagraphStyleAttributeName : paragraphStyle
        };

    }
    return ret;
}
@end