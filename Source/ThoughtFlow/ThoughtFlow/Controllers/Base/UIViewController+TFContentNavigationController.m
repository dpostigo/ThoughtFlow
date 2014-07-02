//
// Created by Dani Postigo on 7/1/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "UIViewController+TFContentNavigationController.h"
#import "TFContentNavigationController.h"

@implementation UIViewController (TFContentNavigationController)

- (TFContentNavigationController *) contentNavigationController {
    return (TFContentNavigationController *) ([self.navigationController isKindOfClass: [TFContentNavigationController class]] ? self.navigationController : nil);
}
@end