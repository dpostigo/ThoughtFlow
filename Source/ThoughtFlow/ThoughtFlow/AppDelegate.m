//
//  AppDelegate.m
//  ThoughtFlow
//
//  Created by Dani Postigo on 4/24/14.
//  Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "AppDelegate.h"
#import "Model.h"
#import "Project.h"
#import "NSObject+AutoDescription.h"
#import "TFNode.h"
#import "UIColor+TFApp.h"

@implementation AppDelegate

- (BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) launchOptions {
    //  [TestFlight takeOff: @"fa4efa7c-ddc8-4377-a8da-c2708c1b0216"];
    [self testDestore];
    [self preloadKeyboard];

    [[UITextField appearance] setKeyboardAppearance: UIKeyboardAppearanceDark];

    self.window.backgroundColor = [UIColor tfBackgroundColor];
    return YES;
}

- (void) testDestore {
    Model *_model = [Model sharedModel];
    NSLog(@"[_model.projects count] = %u", [_model.projects count]);

    for (Project *project in _model.projects) {
        //        NSLog(@"[project autoDescription] = %@", [project autoDescription]);
        NSArray *nodes = project.nodes;
        for (TFNode *node in nodes) {
            NSLog(@"[node autoDescription] = %@", [node autoDescription]);
        }
    }

}

- (void) preloadKeyboard {
    UITextField *lagFreeField = [[UITextField alloc] init];
    [self.window addSubview: lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];

}

- (void) applicationWillResignActive: (UIApplication *) application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void) applicationDidEnterBackground: (UIApplication *) application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void) applicationWillEnterForeground: (UIApplication *) application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void) applicationDidBecomeActive: (UIApplication *) application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void) applicationWillTerminate: (UIApplication *) application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
