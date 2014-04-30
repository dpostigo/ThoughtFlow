//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFOperation.h"

@implementation TFOperation

@synthesize success;
@synthesize failure;

- (instancetype) initWithSuccess: (void (^)()) aSuccess failure: (void (^)()) aFailure {
    self = [super init];
    if (self) {
        success = aSuccess;
        failure = aFailure;
    }

    return self;
}

+ (instancetype) operationWithSuccess: (void (^)()) aSuccess failure: (void (^)()) aFailure {
    return [[self alloc] initWithSuccess: aSuccess failure: aFailure];
}


- (void) performSuccess {
    if (success) success();
}

- (void) performFailure {
    if (failure) failure();
}
@end