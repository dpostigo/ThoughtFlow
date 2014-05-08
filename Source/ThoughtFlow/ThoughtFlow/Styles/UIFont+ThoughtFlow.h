//
// Created by Dani Postigo on 4/28/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIFont (ThoughtFlow)

+ (void) printFontNames;
+ (UIFont *) gothamLight: (CGFloat) fontSize;
+ (UIFont *) italicSerif: (CGFloat) fontSize;
+ (CGFloat) pixelToPoints: (CGFloat) px;
+ (NSDictionary *) attributesForFont: (UIFont *) font;
@end