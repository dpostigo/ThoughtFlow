//
// Created by Dani Postigo on 5/6/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFNodeView.h"

@interface TFNodeView (Utils)

- (NSString *) nodeStateAsString;
+ (NSString *) stringForNodeState: (TFNodeViewState) state;
- (void) enableButtons;
- (void) disableButtons;
- (CGFloat) constrainPositionX: (CGFloat) snapX;
- (CGFloat) constrainPositionY: (CGFloat) posY;
- (void) _setupNormalView;
- (void) _setupGreenView;
- (void) _setupRedView;
- (void) _setupRelatedView;
- (void) toggleSelection: (id) sender;
@end