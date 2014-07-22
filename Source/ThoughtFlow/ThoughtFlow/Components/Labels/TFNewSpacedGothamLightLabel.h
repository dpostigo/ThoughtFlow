//
// Created by Dani Postigo on 7/17/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFNewKernedGothamLightLabel.h"


@interface TFNewSpacedGothamLightLabel : UILabel {

}

@property(nonatomic, strong) NSString *fontName;
@property(nonatomic) CGFloat pointSize;
@property(nonatomic) CGFloat kerning;
@property(nonatomic) CGFloat lineSpacing;

@end