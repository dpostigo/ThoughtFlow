//
//  AppDelegate.h
//  PinchTransitionTest
//
//  Created by Dani Postigo on 7/22/14.
//  Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NavigationControllerDelegate;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NavigationControllerDelegate *navDelegate;
}

@property (strong, nonatomic) UIWindow *window;

@end
