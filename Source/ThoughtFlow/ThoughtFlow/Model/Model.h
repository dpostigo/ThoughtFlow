//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *const TFProjectName;


@interface Model : NSObject {
    NSOperationQueue *queue;
    NSMutableArray *projects;

    NSDictionary *selectedProject;
}

@property(nonatomic, strong) NSOperationQueue *queue;
@property(nonatomic, strong) NSMutableArray *projects;
@property(nonatomic, strong) NSDictionary *selectedProject;
+ (Model *) sharedModel;

@end