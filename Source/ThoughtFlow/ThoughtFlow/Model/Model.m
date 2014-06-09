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

@implementation Model

@synthesize queue;

@synthesize selectedProject;
@synthesize selectedProjectDictionary;

@synthesize projectLibrary;
@synthesize selectedNode;
@synthesize loggedIn;
@synthesize authClient;

@synthesize apiModel;
NSString *const TFProjectName = @"TF Project Name";


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


- (AFOAuth2Client *) authClient {
    if (authClient == nil) {

        NSURL *url = [NSURL URLWithString: @"http://188.226.201.79/api"];
        authClient = [AFOAuth2Client clientWithBaseURL: url
                clientID: @"2dc300c232a003156fddd1d9aecb38d9da9ad49a"
                secret: @"66df225f66bdbe89d5f04825aea2efa9731edd5a"];
    }
    return authClient;
}


- (APIModel *) apiModel {
    if (apiModel == nil) {
        apiModel = [[APIModel alloc] init];
    }
    return apiModel;
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