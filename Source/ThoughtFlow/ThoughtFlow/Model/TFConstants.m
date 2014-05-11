//
// Created by Dani Postigo on 5/5/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFConstants.h"

@implementation TFConstants

NSString *const TFViewControllerTypeName = @"TFViewControllerTypeName";
NSString *const TFViewControllerTypeKey = @"TFViewControllerTypeKey";
NSString *const TFViewControllerShouldPushKey = @"TFViewControllerShouldPushKey";
NSString *const TFNavigationNotification = @"TFNavigationNotification";
NSString *const TFToolbarProjectsNotification = @"TFToolbarProjectsNotification";
NSString *const TFToolbarMindmapNotification = @"TFToolbarMindmapNotification";

NSString *const TFToolbarAccountDrawerClosed = @"TFToolbarAccountDrawerClosed";
NSString *const TFToolbarSettingsDrawerClosed = @"TFToolbarSettingsDrawerClosed";

+ (NSString *) stringForControllerType: (TFViewControllerType) type {
    NSString *ret = nil;
    switch (type) {
        case TFControllerNone :
            ret = @"TFControllerNone";
            break;

        case TFControllerProjects :
            ret = @"ProjectsController";
            break;

        case TFControllerMoodboard :
            ret = @"MoodboardController";
            break;

        case TFControllerMindmap :
            ret = @"MindmapController";
            break;

        case TFControllerCreateProject :
            ret = @"CreateProjectController";
            break;

    }
    return ret;
}

@end