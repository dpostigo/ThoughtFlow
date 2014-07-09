//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Project;
@class ProjectLibrary;
@class TFNode;
@class AFHTTPSessionManager;
@class APIModel;
@class TFPhoto;
@class TFLibrary;

NSString *const TFProjectName;
NSString *const TFSelectedPhotoDidChange;


@interface Model : NSObject {
    BOOL loggedIn;
    APIModel *apiModel;
    NSOperationQueue *queue;

    TFPhoto *selectedPhoto;
    Project *selectedProject;
    TFNode *selectedNode;
    NSDictionary *selectedProjectDictionary;
}

@property(nonatomic, strong) NSOperationQueue *queue;
@property(nonatomic, readonly) NSArray *projects;
@property(nonatomic, strong) NSDictionary *selectedProjectDictionary;
@property(nonatomic, strong) Project *selectedProject;
@property(nonatomic, strong) TFNode *selectedNode;
@property(nonatomic, readonly) ProjectLibrary *projectLibrary;
@property(nonatomic, strong) TFLibrary *tfLibrary;
@property(nonatomic) BOOL loggedIn;
@property(nonatomic, strong) APIModel *apiModel;
@property(nonatomic, strong) TFPhoto *selectedPhoto;
+ (Model *) sharedModel;

- (NSArray *) projectsSortedByDate;
- (void) addProject: (Project *) project;
- (void) addProjects: (NSArray *) projects;
@end