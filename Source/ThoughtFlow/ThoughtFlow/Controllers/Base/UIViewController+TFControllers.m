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


- (UIStoryboard *) mindmapStoryboard {
    return [UIStoryboard storyboardWithName: @"Mindmap" bundle: nil];
}

- (UIStoryboard *) moodboardStoryboard {
    return [UIStoryboard storyboardWithName: @"Moodboard" bundle: nil];
}


#pragma mark Main controllers

- (UIViewController *) moodboardController {
    return [self.moodboardStoryboard instantiateViewControllerWithIdentifier: @"MoodboardController"];
}


- (UIViewController *) mainController {
    return [self.mainStoryboard instantiateViewControllerWithIdentifier: @"NewMainAppController"];
}



#pragma mark - Projects


- (UIViewController *) projectsController {
    return [self.mainStoryboard instantiateViewControllerWithIdentifier: @"ProjectsController"];
}




- (UIViewController *) createProjectController {
    return [self.mainStoryboard instantiateViewControllerWithIdentifier: @"CreateProjectController"];
}




#pragma mark Mindmap

- (UIViewController *) mindmapController {
    return [self.mindmapStoryboard instantiateViewControllerWithIdentifier: @"MindmapController"];
}


- (UIViewController *) mindmapGridController {
    return [self.mindmapStoryboard instantiateViewControllerWithIdentifier: @"MindmapGridController"];
}




#pragma mark Mindmap Layers


- (UIViewController *) minimizedLayerController {
    return [self.mindmapStoryboard instantiateViewControllerWithIdentifier: @"MinimizedLayerController"];
}

- (UIViewController *) mindmapBackgroundController {
    return [self.mindmapStoryboard instantiateViewControllerWithIdentifier: @"MindmapBackgroundController"];
}

- (UIViewController *) mindmapButtonsController {
    return [self.mindmapStoryboard instantiateViewControllerWithIdentifier: @"MindmapButtonsController"];
}


#pragma mark Toolbar controllers

- (UIViewController *) notesViewController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"NotesDrawerController"];
}

- (UIViewController *) accountViewController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"TFAccountDrawerController"];
}

- (UIViewController *) imageDrawerController {
    return [self.storyboard instantiateViewControllerWithIdentifier: @"NewImageDrawerController"];
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


@end