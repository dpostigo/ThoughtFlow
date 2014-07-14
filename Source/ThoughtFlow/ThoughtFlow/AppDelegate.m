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
#import "DDTTYLogger.h"
#import "DDASLLogger.h"
#import "APIModel.h"
#import "AFNetworkActivityLogger.h"
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate ()

@property(nonatomic, strong) APIModel *apiModel;
@end

@implementation AppDelegate {
    Model *_model;
}

- (BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) launchOptions {

    _apiModel = [APIModel sharedModel];

    [self _setup];
    [self _testAPI];

    //    [self testDestore];
    //    [self _setupSampleProject];
    //    [self preloadKeyboard];

    [[UITextField appearance] setKeyboardAppearance: UIKeyboardAppearanceDark];

    self.window.backgroundColor = [UIColor tfBackgroundColor];
    [Crashlytics startWithAPIKey: @"7c4a623c37a77f191460d4ffa903c608f7577228"];

    return YES;
}


- (void) _testAPI {

    //    [_apiModel userExists: @"alex1" completion: ^(BOOL exists) {
    //        NSLog(@"%s", __PRETTY_FUNCTION__);
    //    }];
}

- (void) _setup {
    //    [self _setupAppearance];
    [self _setupLogging];
}


- (void) _setupLogging {
    [DDLog addLogger: [DDASLLogger sharedInstance]];
    [DDLog addLogger: [DDTTYLogger sharedInstance]];

    [[DDTTYLogger sharedInstance] setColorsEnabled: YES];
    [[DDTTYLogger sharedInstance] setForegroundColor: [UIColor colorWithRed: (255 / 255.0) green: (58 / 255.0) blue: (159 / 255.0) alpha: 1.0] backgroundColor: nil forFlag: LOG_FLAG_VERBOSE];

    //    [[AFNetworkActivityLogger sharedLogger] startLogging];
}

- (void) _setupAppearance {

}

- (void) _setupSampleProject {
    _model = [Model sharedModel];
    Project *project = [[Project alloc] initWithWord: @"test2"];
    project.modifiedDate = [NSDate date];

    //    TFNode *node = [[TFNode alloc] initWithTitle: @"node1" position: CGPointMake(100, 300)];
    //    [node.mutableChildren addObject: [[TFNode alloc] initWithTitle: @"node1 child1" position: CGPointMake(100, 200)]];
    //    [node.mutableChildren addObject: [[TFNode alloc] initWithTitle: @"node1 child2" position: CGPointMake(100, 300)]];
    //    [node.mutableChildren addObject: [[TFNode alloc] initWithTitle: @"node1 child2" position: CGPointMake(100, 300)]];

    TFNode *node = [[TFNode alloc] initWithTitle: @"node1" position: CGPointMake(100, 100)];
    [node.mutableChildren addObject: [[TFNode alloc] initWithTitle: @"node1 child1" position: CGPointMake(300, 100)]];
    [node.mutableChildren addObject: [[TFNode alloc] initWithTitle: @"node1 child2" position: CGPointMake(300, 200)]];
    [node.mutableChildren addObject: [[TFNode alloc] initWithTitle: @"node1 child3" position: CGPointMake(300, 300)]];

    [project.firstNode.mutableChildren addObject: node];
    [project.firstNode.mutableChildren addObject: [[TFNode alloc] initWithTitle: @"node2" position: CGPointMake(700, 300)]];
    [project.firstNode.mutableChildren addObject: [[TFNode alloc] initWithTitle: @"node3" position: CGPointMake(700, 200)]];

    [_model addProject: project];

}


- (void) testDestore {
    _model = [Model sharedModel];
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
