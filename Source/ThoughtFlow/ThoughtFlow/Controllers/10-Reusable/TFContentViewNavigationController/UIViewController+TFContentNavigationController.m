//
// Created by Dani Postigo on 7/1/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "UIViewController+TFContentNavigationController.h"
#import "TFContentViewNavigationController.h"

@implementation UIViewController (TFContentNavigationController)

- (TFContentViewNavigationController *) contentNavigationController {
    return (TFContentViewNavigationController *) ([self.navigationController isKindOfClass: [TFContentViewNavigationController class]] ? self.navigationController : nil);
}
@end