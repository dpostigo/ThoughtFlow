//
// Created by Dani Postigo on 6/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Model;
@class APIUser;
@class AFOAuth2Client;
@class PhotoLibrary;
@class TFLibrary;

extern NSString *const ThoughtFlowIdentifier;
extern NSString *const ThoughtFlowBaseURL;

@interface APIModel : NSObject {
    Model *_model;
}

@property(nonatomic) BOOL usesConnections;
@property(nonatomic) BOOL usesDummyData;
@property(nonatomic, readonly) BOOL loggedIn;
@property(nonatomic, readonly) PhotoLibrary *photoLibrary;
@property(nonatomic, readonly) NSArray *projects;
@property(nonatomic, strong) TFLibrary *library;
@property(nonatomic, strong) APIUser *currentUser;
@property(nonatomic, strong) AFOAuth2Client *authClient;
+ (void) alertErrorWithTitle: (NSString *) title message: (NSString *) message;
- (void) authenticateWithCompletion: (void (^)()) completion failure: (void (^)()) failure;
+ (APIModel *) sharedModel;

- (void) saveUser;
- (void (^)()) generalFailureBlock;
- (void (^)()) failureBlockWithTitle: (NSString *) title message: (NSString *) message;
- (void) loginUser: (NSString *) username password: (NSString *) password completion: (void (^)()) completion failure: (void (^)()) failure;
- (void) updateCurrentUserWithPassword: (NSString *) password success: (void (^)()) success failure: (void (^)(NSString *message)) failure;
- (void) updateCurrentUserWithEmail: (NSString *) email success: (void (^)()) success failure: (void (^)(NSString *message)) failure;
- (void) userExists: (NSString *) username completion: (void (^)(BOOL exists)) success;
- (void) registerUser: (NSString *) username password: (NSString *) password email: (NSString *) email success: (void (^)()) success failure: (void (^)()) failure;
- (void) signOutWithCompletion: (void (^)()) completion;
- (void) hasImages: (NSString *) string completion: (void (^)(BOOL hasImages)) completion;
- (void) getImages: (NSString *) string success: (void (^)(NSArray *images)) success failure: (void (^)()) failure;
- (void) getRelated: (NSString *) string success: (void (^)(NSArray *topics)) success failure: (void (^)(NSError *)) failure;
- (void) preloadImages: (NSArray *) images;
@end