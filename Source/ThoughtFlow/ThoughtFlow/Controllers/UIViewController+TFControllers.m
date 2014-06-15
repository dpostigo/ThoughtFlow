//
// Created by Dani Postigo on 5/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "UIViewController+TFControllers.h"

@implementation UIViewController (TFControllers)


#pragma mark Main controllers

- (UIViewController *) moodboardController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"MoodboardController"];
}


- (UIViewController *) mainController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"MainAppController"];
}


- (UIViewController *) moodboardBackgroundController {
    return [self.backgroundStoryboard instantiateViewControllerWithIdentifier: @"MindmapBackgroundController"];
}


#pragma mark Toolbar controllers

- (UIViewController *) notesViewController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"NotesDrawerController"];
}

- (UIViewController *) accountViewController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"TFAccountDrawerController"];
}

- (UIViewController *) imageDrawerController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"ImageDrawerController"];
}


- (UIViewController *) imageSettingsController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"TFSettingsDrawerController"];
}


- (UIViewController *) preloginController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"PreloginController"];
}


- (UIViewController *) infoViewController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"TFInfoViewController"];
}


#pragma mark Storyboards

- (UIStoryboard *) backgroundStoryboard {
    return [UIStoryboard storyboardWithName: @"MindmapBackground" bundle: nil];
}


@end