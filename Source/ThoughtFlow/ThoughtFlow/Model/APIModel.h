//
// Created by Dani Postigo on 6/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Model;
@class APIUser;

extern NSString *const ThoughtFlowIdentifier;
extern NSString *const ThoughtFlowBaseURL;

@interface APIModel : NSObject {

    APIUser *currentUser;
    Model *_model;
}

@property(nonatomic, strong) APIUser *currentUser;
+ (void) alertErrorWithTitle: (NSString *) title message: (NSString *) message;
- (BOOL) loggedIn;
- (void (^)()) generalFailureBlock;
- (void) login: (NSString *) username password: (NSString *) password completion: (void (^)()) completion failure: (void (^)()) failure;
- (void) userExists: (NSString *) username completion: (void (^)(BOOL exists)) success;
- (void) createUser: (NSString *) username password: (NSString *) password email: (NSString *) email success: (void (^)()) success failure: (void (^)()) failure;
@end