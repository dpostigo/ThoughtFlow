//
// Created by Dani Postigo on 5/5/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TFControllerNone = 0,
    TFControllerProjects = 1,
    TFControllerMoodboard = 2,
    TFControllerMindmap = 3,
    TFControllerCreateProject = 4
} TFViewControllerType;

extern NSString *const TFViewControllerTypeKey;
extern NSString *const TFViewControllerShouldPushKey;
extern NSString *const TFViewControllerTypeName;

extern NSString *const TFNavigationNotification;



extern NSString *const TFInfoNotification;
extern NSString *const TFToolbarAccountDrawerClosed;
extern NSString *const TFToolbarSettingsDrawerClosed;


@interface TFConstants : NSObject {

}

+ (NSString *) stringForControllerType: (TFViewControllerType) type;
@end