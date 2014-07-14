//
// Created by Dani Postigo on 7/11/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-UIFont/UIFont+DPKitFonts.h>
#import "TFBarButtonItem.h"
#import "TFString.h"
#import "UIColor+TFApp.h"


@implementation TFBarButtonItem

- (instancetype) initWithTitle: (NSString *) title {
    TFBarButtonItem *leftItem = [[TFBarButtonItem alloc] initWithButton: nil];
    [leftItem.button setAttributedTitle: [[NSAttributedString alloc] initWithString: title attributes: [TFBarButtonItem defaultAttributes]] forState: UIControlStateNormal];
    [leftItem.button sizeToFit];
    return leftItem;
}

- (instancetype) initWithButton: (UIButton *) button {
    if (button == nil) {
        button = [TFBarButtonItem defaultButton];
    }
    self = [super initWithCustomView: button];
    if (self) {
        _button = button;
    }

    return self;
}


#pragma mark - Buttons

+ (UIButton *) closeButton {
    UIButton *button = [TFBarButtonItem defaultButton];
    [button setAttributedTitle: [[NSAttributedString alloc] initWithString: @"CLOSE"
            attributes: [TFBarButtonItem defaultAttributes]] forState: UIControlStateNormal];
    [button setImage: [UIImage imageNamed: @"icon-chevron-left"] forState: UIControlStateNormal];
    [button sizeToFit];
    return button;

}

+ (UIButton *) defaultButton {
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];


    NSDictionary *normalAttributes = [TFBarButtonItem defaultAttributes];

    NSDictionary *selectedAttributes = [TFString attributesWithAttributes: nil
            font: [UIFont gothamRoundedLightFontOfSize: 11.0]
            color: [UIColor tfGreenColor]
            kerning: 100
            lineSpacing: 1
            textAlignment: NSTextAlignmentRight];


    NSAttributedString *normalString = [[NSAttributedString alloc] initWithString: @"EDIT" attributes: normalAttributes];
    NSAttributedString *selectedString = [[NSAttributedString alloc] initWithString: @"SAVE" attributes: selectedAttributes];

    [button setAttributedTitle: normalString forState: UIControlStateNormal];
    [button setAttributedTitle: selectedString forState: UIControlStateSelected];
    //        button.width = 320;
    //        button.height = 44;
    button.frame = CGRectMake(0, 0, 320, 44);
    [button sizeToFit];
    return button;

}

+ (NSDictionary *) defaultAttributes {
    NSDictionary *ret = [TFString attributesWithAttributes: nil
            font: [UIFont gothamRoundedLightFontOfSize: 11.0]
            color: [UIColor whiteColor]
            kerning: 100
            lineSpacing: 1
            textAlignment: NSTextAlignmentLeft];

    return ret;
}

@end