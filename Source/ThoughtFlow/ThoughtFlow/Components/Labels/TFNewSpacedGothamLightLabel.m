//
// Created by Dani Postigo on 7/17/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNewSpacedGothamLightLabel.h"
#import "UIFont+DPKitFonts.h"
#import "UIView+DPKitDebug.h"


@implementation TFNewSpacedGothamLightLabel

- (void) setupLabel {

    _fontName = [UIFont gothamRoundedLightFont].fontName;
    _pointSize = 0;
    _kerning = 100;
    _lineSpacing = 0.5;

    [self addDebugBorder: [UIColor redColor]];
}


- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
        _pointSize = self.font.pointSize;
        NSLog(@"_pointSize = %f", _pointSize);
        [self setupLabel];

    }

    return self;
}


- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self setupLabel];
    }

    return self;
}


- (void) awakeFromNib {
    [super awakeFromNib];

    //    [self _refresh];
}


#pragma mark - Setters

- (void) setPointSize: (CGFloat) pointSize {
    _pointSize = pointSize;
    [self _refresh];
}


- (void) setLineSpacing: (CGFloat) lineSpacing {
    _lineSpacing = lineSpacing;
    [self _refresh];
}

- (void) setKerning: (CGFloat) kerning {
    _kerning = kerning;
    [self _refresh];
}



#pragma mark - Overrides

- (void) setText: (NSString *) text {
    [super setText: text];

    [self _refresh];
}




#pragma mark - Setup


- (void) _refresh {
    NSString *string = self.text;
    if (string != nil && [string length] > 0) {
        NSDictionary *attributes = [self defaultAttributes];
        self.attributedText = [[NSAttributedString alloc] initWithString: string attributes: attributes];
    }
}


#pragma mark - Attributes

- (NSDictionary *) defaultAttributes {
    NSDictionary *attributes = nil;


    CGFloat pointSize = _pointSize == 0 ? self.font.pointSize : _pointSize;
    CGFloat kerningSize = _kerning * (pointSize / 1000);

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = _lineSpacing;
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    attributes = @{
            NSForegroundColorAttributeName : self.textColor,
            NSFontAttributeName : [UIFont fontWithName: _fontName size: pointSize],
            NSKernAttributeName : @(kerningSize),
            NSParagraphStyleAttributeName : paragraphStyle
    };

    return attributes;

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