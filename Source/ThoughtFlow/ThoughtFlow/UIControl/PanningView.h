//
// Created by Dani Postigo on 5/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPPassThroughView.h"

@interface PanningView : DPPassThroughView {
    CGPoint startingPoint;
    CGPoint offsetPoint;
}

@property(nonatomic) CGPoint startingPoint;
@property(nonatomic) CGPoint offsetPoint;
@end