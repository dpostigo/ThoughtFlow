//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "Model.h"

@implementation Model

@synthesize queue;
@synthesize projects;

@synthesize selectedProject;

NSString *const TFProjectName = @"TF Project Name";

+ (Model *) sharedModel {
    static Model *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

#pragma mark Getters

- (NSOperationQueue *) queue {
    if (queue == nil) {
        queue = [NSOperationQueue new];
    }
    return queue;
}


- (NSMutableArray *) projects {
    if (projects == nil) {
        projects = [[NSMutableArray alloc] init];

        [projects addObject: @{
                TFProjectName : @"Sample Project 1"
        }];
    }
    return projects;
}

@end