//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFViewController.h"
#import "Model.h"
#import "UIColor+DPKit.h"
#import "UIView+DPKitChildren.h"
#import "UIFont+ThoughtFlow.h"

@implementation TFViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    _model = [Model sharedModel];
    _queue = _model.queue;

    if ([self.view.backgroundColor isEqual: [UIColor whiteColor]]) {
        self.view.backgroundColor = [UIColor colorWithString: @"29292E"];
    }

    [self replaceFonts];

}

- (void) replaceFonts {
    NSMutableArray *labels = [NSMutableArray arrayWithArray: [self.view childrenOfClass: [UILabel class]]];
    [labels addObjectsFromArray: self.buttonLabels];

    for (UILabel *label in labels) {
        NSAttributedString *string = [self attributedStringForString: label.text
                                                                font: label.font
                                                       textAlignment: label.textAlignment];

        if (string) {
            label.attributedText = string;
            [label sizeToFit];
        }
    }

    //    NSArray *buttons = [self.view childrenOfClass: [UIButton class]];
    //
    //    for (UILabel *label in self.buttonLabels) {
    //        NSAttributedString *string = [self attributedStringForString: label.text
    //                                                                font: label.font
    //                                                       textAlignment: label.textAlignment];
    //
    //        if (string) {
    //            label.attributedText = string;
    //            //            [label sizeToFit];
    //        }
    //    }
    //
    //    for (UIButton *button in buttons) {
    //        if ([labels containsObject: button.titleLabel]) {
    //            [button sizeToFit];
    //        }
    //    }
}


- (NSArray *) buttonLabels {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSArray *buttons = [self.view childrenOfClass: [UIButton class]];

    for (UIButton *button in buttons) {
        [ret addObject: button.titleLabel];
    }
    return ret;
}

- (NSAttributedString *) attributedStringForString: (NSString *) string font: (UIFont *) font textAlignment: (NSTextAlignment) textAlignment {
    CGFloat kerningSize = 0;
    CGFloat pointSize = font.pointSize;

    NSDictionary *attributes;
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

    if ([font.fontName isEqualToString: @"Avenir-Light"]) {
        kerningSize = 60 * (pointSize / 1000);
        attributes = @{
                NSFontAttributeName : [UIFont gothamLight: pointSize],
                NSKernAttributeName : @(kerningSize)
        };

    } else if ([font.fontName isEqualToString: @"TimesNewRomanPS-ItalicMT"]) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 25.6 / 18;
        paragraphStyle.alignment = textAlignment;
        attributes = @{
                NSFontAttributeName : [UIFont fontWithName: @"Mercury-TextG1Italic" size: pointSize],
                NSKernAttributeName : @(kerningSize),
                NSParagraphStyleAttributeName : paragraphStyle
        };

    } else if ([font.fontName isEqualToString: @"Baskerville-Italic"]) {
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

    NSAttributedString *ret = nil;
    if (attributes) {
        ret = [[NSAttributedString alloc] initWithString: string attributes: attributes];
    }
    return ret;

}

@end