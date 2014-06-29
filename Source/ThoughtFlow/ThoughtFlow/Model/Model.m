//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "Model.h"
#import "Project.h"
#import "ProjectLibrary.h"
#import "TFNode.h"
#import "NSArray+DPKit.h"
#import "AFOAuth2Client.h"
#import "AFHTTPSessionManager.h"
#import "APIModel.h"
#import "TFPhoto.h"

@implementation Model

@synthesize queue;

@synthesize selectedProject;
@synthesize selectedProjectDictionary;

@synthesize projectLibrary;
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