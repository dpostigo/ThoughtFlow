//
// Created by Dani Postigo on 7/11/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFString.h"


@implementation TFString

+ (NSDictionary *) attributesWithAttributes: (NSDictionary *) attributes
                                       font: (UIFont *) font
                                      color: (UIColor *) color
                                    kerning: (CGFloat) kerning
                                lineSpacing: (CGFloat) lineSpacing
                              textAlignment: (NSTextAlignment) textAlignment {

    NSDictionary *ret = nil;
    id kerningAttribute = @(kerning * (font.pointSize / 1000));
    id paragraphAttribute = [self paragraphAttribute: lineSpacing alignment: textAlignment lineBreakMode: NSLineBreakByWordWrapping];

    ret = @{
            NSForegroundColorAttributeName : color,
            NSFontAttributeName : font,
            NSKernAttributeName : kerningAttribute,
            NSParagraphStyleAttributeName : paragraphAttribute
    };

    return ret;
}

+ (NSMutableAttributedString *) tfAttributedString: (NSString *) string {

    NSDictionary *attributes = [TFString attributesWithAttributes: nil
            font: [UIFont systemFontOfSize: 12.0]
            color: [UIColor whiteColor]
            kerning: 100
            lineSpacing: 1
            textAlignment: NSTextAlignmentLeft];

    NSMutableAttributedString *ret = [[NSMutableAttributedString alloc] initWithString: string attributes: attributes];
    return ret;
}
//
//+ (NSParagraphStyle *) paragraphAttribute: (CGFloat) lineSpacing alignment: (NSTextAlignment) textAlignment {
//
//}

+ (NSParagraphStyle *) paragraphAttribute: (CGFloat) lineSpacing alignment: (NSTextAlignment) textAlignment lineBreakMode: (NSLineBreakMode) breakMode {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.alignment = textAlignment;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    return paragraphStyle;
}
@end