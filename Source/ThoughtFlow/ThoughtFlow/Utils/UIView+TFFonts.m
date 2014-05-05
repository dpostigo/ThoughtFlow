//
// Created by Dani Postigo on 4/28/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "UIView+TFFonts.h"
#import "UIView+DPKitChildren.h"
#import "UILabel+TFFonts.h"
#import "UITextField+TFFonts.h"

@implementation UIView (TFFonts)

- (void) convertFonts {

    NSArray *labels = [self childrenOfClass: [UILabel class]];
    [labels enumerateObjectsUsingBlock: ^(UILabel *label, NSUInteger idx, BOOL *stop) {
        [label convertLabelFonts];
    }];


    NSArray *textFields = [self childrenOfClass: [UITextField class]];
    [textFields enumerateObjectsUsingBlock: ^(UITextField *textField, NSUInteger idx, BOOL *stop) {
        [textField convertFonts];
    }];

    NSArray *textViews = [self childrenOfClass: [UITextView class]];
    [textViews enumerateObjectsUsingBlock: ^(UITextView *item, NSUInteger idx, BOOL *stop) {
        [item convertFonts];
    }];

}


@end