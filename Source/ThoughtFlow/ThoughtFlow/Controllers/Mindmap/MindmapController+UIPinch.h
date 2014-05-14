//
// Created by Dani Postigo on 5/11/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MindmapController.h"

@interface MindmapController (UIPinch)

- (void) startPinchWithScale: (CGFloat) scale;
- (void) updatePinchWithScale: (CGFloat) scale;
- (void) endPinchWithScale: (CGFloat) scale;
- (void) unpinch;
- (void) mindmapDidCompletePinch;
@end