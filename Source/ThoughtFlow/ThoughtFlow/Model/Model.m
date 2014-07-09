//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "Model.h"
#import "Project.h"
#import "ProjectLibrary.h"
#import "NSArray+DPKit.h"
#import "APIModel.h"
#import "TFPhoto.h"
#import "TFLibrary.h"


@implementation Model

@synthesize queue;

@synthesize selectedProject;
@synthesize selectedProjectDictionary;

@synthesize selectedNode;
@synthesize loggedIn;

@synthesize apiModel;
@synthesize selectedPhoto;
NSString *const TFProjectName = @"TF Project Name";
NSString *const TFSelectedPhotoDidChange = @"TFSelectedPhotoDidChange";


static NSString *baseURL = @"http://188.226.201.79/api";

+ (Model *) sharedModel {
    static Model *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}


- (id) init {
    self = [super init];
    if (self) {
        _tfLibrary = [TFLibrary sharedLibrary];
    }

    return self;
}

#pragma mark Getters

- (NSOperationQueue *) queue {
    if (queue == nil) {
        queue = [NSOperationQueue new];
    }
    return queue;
}


- (APIModel *) apiModel {
    if (apiModel == nil) {
        apiModel = [APIModel sharedModel];
    }
    return apiModel;
}



#pragma mark Property notifications

- (void) setSelectedPhoto: (TFPhoto *) selectedPhoto1 {
    if (selectedPhoto != selectedPhoto1) {
        selectedPhoto = selectedPhoto1;
        [[NSNotificationCenter defaultCenter] postNotificationName: TFSelectedPhotoDidChange object: nil];
    }
}

#pragma mark Projects
- (NSArray *) projects {
    return self.projectLibrary.children;
}


- (NSArray *) projectsSortedByDate {
    return [self.projects sortedArrayUsingDescriptor: [NSSortDescriptor sortDescriptorWithKey: @"creationDate"
            ascending: NO]];
}

- (ProjectLibrary *) projectLibrary {
    return _tfLibrary.projectsLibrary;
}


- (TFLibrary *) tfLibrary {
    if (_tfLibrary == nil) {
        _tfLibrary = [TFLibrary sharedLibrary];
    }
    return _tfLibrary;
}

#pragma mark Projects

- (void) addProject: (Project *) project {
    [self.projectLibrary addChild: project];
}

- (void) addProjects: (NSArray *) projects {
    [self.projectLibrary addItems: projects];
}

@end