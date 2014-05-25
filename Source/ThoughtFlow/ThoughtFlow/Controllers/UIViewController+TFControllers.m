//
// Created by Dani Postigo on 5/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "UIViewController+TFControllers.h"

@implementation UIViewController (TFControllers)

- (UIViewController *) imageDrawerController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"ImageDrawerController"];
}
@end