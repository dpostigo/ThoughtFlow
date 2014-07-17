//
// Created by Dani Postigo on 5/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "UIViewController+TFControllers.h"


@implementation UIViewController (TFControllers)


#pragma mark Storyboards

- (UIStoryboard *) mainStoryboard {
    return [UIStoryboard storyboardWithName: @"Storyboard" bundle: nil];
}


#pragma mark Main controllers


- (UIViewController *) mainController {
    return [self.mainStoryboard instantiateViewControllerWithIdentifier: @"TFMainViewController"];
}


- (UIViewController *) preloginController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"PreloginController"];
}


@end