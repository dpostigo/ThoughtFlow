//
// Created by Dani Postigo on 5/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFToolbarController.h"
#import "TFConstants.h"

@interface TFToolbarController (Utils)

- (void) selectButtonForType: (TFViewControllerType) type;
- (void) toggleButton: (UIButton *) button;
- (void) deselectAll: (id) sender;
@end