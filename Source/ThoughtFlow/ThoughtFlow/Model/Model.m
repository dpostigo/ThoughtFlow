//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "Model.h"
#import "Project.h"
#import "ProjectLibrary.h"
#import "TFNode.h"
#import "NSArray+DPKit.h"

@implementation Model

@synthesize queue;

@synthesize selectedProject;
@synthesize selectedProjectDictionary;

@synthesize projectLibrary;
@synthesize selectedNode;
@synthesize loggedIn;
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



#pragma mark Projects
- (NSArray *) projects {
    return self.projectLibrary.items;
}


- (NSArray *) projectsSortedByDate {
    return [self.projects sortedArrayUsingDescriptor: [NSSortDescriptor sortDescriptorWithKey: @"creationDate"
                                                                                    ascending: NO]];
}

- (ProjectLibrary *) projectLibrary {
    if (projectLibrary == nil) {
        projectLibrary = [ProjectLibrary sharedLibrary];
    }
    return projectLibrary;
}

#pragma mark Projects

- (void) addProject: (Project *) project {
    [self.projectLibrary addItem: project];
}

- (void) addProjects: (NSArray *) projects {
    [self.projectLibrary addItems: projects];
}

@end