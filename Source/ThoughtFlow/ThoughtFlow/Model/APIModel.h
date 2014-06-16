//
// Created by Dani Postigo on 6/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Model;
@class APIUser;
@class AFOAuth2Client;

extern NSString *const ThoughtFlowIdentifier;
extern NSString *const ThoughtFlowBaseURL;

@interface APIModel : NSObject {
    AFOAuth2Client *authClient;
    APIUser *currentUser;
    Model *_model;
}

@property(nonatomic, strong) APIUser *currentUser;
@property(nonatomic, strong) AFOAuth2Client *authClient;
+ (void) alertErrorWithTitle: (NSString *) title message: (NSString *) message;
+ (APIModel *) sharedModel;

- (BOOL) loggedIn;
- (void (^)()) generalFailureBlock;
- (void) login: (NSString *) username password: (NSString *) password completion: (void (^)()) completion failure: (void (^)()) failure;
- (void) userExists: (NSString *) username completion: (void (^)(BOOL exists)) success;
- (void) registerUser: (NSString *) username password: (NSString *) password email: (NSString *) email success: (void (^)()) success failure: (void (^)()) failure;
- (void) getImages: (NSString *) string success: (void (^)(NSArray *images)) success failure: (void (^)()) failure;
@end