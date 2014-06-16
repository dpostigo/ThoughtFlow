//
// Created by Dani Postigo on 6/15/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "GothamLightLabel.h"
#import "UIFont+ThoughtFlow.h"

@implementation GothamLightLabel

- (void) awakeFromNib {
    [super awakeFromNib];

    self.text = self.text;
}

- (void) setText: (NSString *) text {
    [super setText: text];

    NSDictionary *attributes = nil;
    CGFloat kerningSize = 0;
    CGFloat pointSize = self.font.pointSize;

    kerningSize = 60 * (pointSize / 1000);

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = (12 / 12) * pointSize;
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    attributes = @{
            NSFontAttributeName : [UIFont gothamLight: pointSize],
            NSKernAttributeName : @(kerningSize),
            NSParagraphStyleAttributeName : paragraphStyle
    };

    self.attributedText = [[NSAttributedString alloc] initWithString: self.text attributes: attributes];
    [self sizeToFit];
}


@end