//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Model;

@interface TFOperation : NSOperation {

    Model *_model;
    void (^success)();
    void (^failure)();
}

@property(nonatomic, copy) void (^success)();
@property(nonatomic, copy) void (^failure)();

- (instancetype) initWithSuccess: (void (^)()) aSuccess failure: (void (^)()) aFailure;
- (instancetype) initWithSuccess: (void (^)()) aSuccess;
+ (instancetype) operationWithSuccess: (void (^)()) aSuccess;

+ (instancetype) operationWithSuccess: (void (^)()) aSuccess failure: (void (^)()) aFailure;


- (void) performSuccess;
- (void) performFailure;
@end