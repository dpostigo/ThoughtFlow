//
// Created by Dani Postigo on 6/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <NSObject+AutoDescription/NSObject+AutoDescription.h>
#import "APIModel.h"
#import "Model.h"
#import "AFOAuth2Client.h"
#import "UIAlertView+Blocks.h"
#import "APIUser.h"
#import "TFPhoto.h"
#import "PhotoLibrary.h"
#import "NSString+RMURLEncoding.h"


NSString *const TFScopeEmail = @"email";


NSString *const ThoughtFlowIdentifier = @"188.226.201.79";
NSString *const ThoughtFlowBaseURL = @"http://188.226.201.79";
NSString *const TFAuthURL = @"http://188.226.201.79/api/oauth/token";


@implementation APIModel

- (id) init {
    self = [super init];
    if (self) {
        _model = [Model sharedModel];
        _photoLibrary = [PhotoLibrary sharedLibrary];

        [self initAuthClient];

        //        if (!self.loggedIn) {
        //        [self authenticateWithCompletion: nil failure: nil];
        //        }

        //        [self.authClient.reachabilityManager startMonitoring];

    }

    return self;
}


+ (APIModel *) sharedModel {
    static APIModel *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (BOOL) loggedIn {

    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier: ThoughtFlowIdentifier];

    if (credential) {
        if (credential.isExpired) {
            DDLogWarn(@"Credential is expired.");
            //            [AFOAuthCredential deleteCredentialWithIdentifier: ThoughtFlowIdentifier];

        } else {
            NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey: @"currentUser"];
            if (encodedObject) {
                DDLogVerbose(@"Got user.");
                _currentUser = [NSKeyedUnarchiver unarchiveObjectWithData: encodedObject];
            } else {
                DDLogVerbose(@"No saved user.");
            }
        }
    } else {
        DDLogWarn(@"Credential does not exist.");
    }

    return _currentUser != nil;
}

#pragma mark Errors

- (void (^)()) generalFailureBlock {
    return ^{
        [APIModel alertErrorWithTitle: @"Error" message: @"There was en error."];
    };
}


- (void (^)()) failureBlockWithTitle: (NSString *) title message: (NSString *) message {
    return ^{
        [UIAlertView showWithTitle: title
                message: message
                cancelButtonTitle: @"OK"
                otherButtonTitles: @[]
                tapBlock: nil];
    };
}


+ (void) alertErrorWithTitle: (NSString *) title message: (NSString *) message {
    [UIAlertView showWithTitle: title
            message: message
            cancelButtonTitle: @"OK"
            otherButtonTitles: @[]
            tapBlock: nil];
}


#pragma mark - Authentication


- (void) authenticateWithCompletion: (void (^)()) completion failure: (void (^)()) failure {
    DDLogVerbose(@"AUTH started.");

    [self.authClient authenticateUsingOAuthWithURLString: TFAuthURL
            username: @"alex1"
            password: @"qwerty"
            scope: TFScopeEmail
            success: ^(AFOAuthCredential *credential) {
                DDLogVerbose(@"AUTH Authentication succeeded.");
                [AFOAuthCredential storeCredential: credential withIdentifier: self.authClient.serviceProviderIdentifier];
                if (completion) {
                    completion();
                }
            }
            failure: ^(NSError *error) {
                DDLogVerbose(@"AUTH Authentication failed. Error = %@", error);
                if (failure) {
                    failure();
                }
            }];

}


#pragma mark Login / Register



- (void) userExists: (NSString *) username completion: (void (^)(BOOL exists)) success {
    DDLogVerbose(@"USEREXISTS, username = %@", username);

    [self.authClient GET: [NSString stringWithFormat: @"username/%@", username]
            parameters: nil
            success: ^(AFHTTPRequestOperation *task, id responseObject) {
                DDLogVerbose(@"USEREXISTS, user does exist.");
                if (success) {
                    success(YES);
                }
            }
            failure: ^(AFHTTPRequestOperation *task, NSError *error) {
                if (success) {
                    success(NO);
                }
                DDLogVerbose(@"USEREXISTS, user does NOT exist.");
            }];
}


- (void) registerUser: (NSString *) username password: (NSString *) password email: (NSString *) email
              success: (void (^)()) success failure: (void (^)()) failure {

    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    [self.authClient POST: @"user"
            parameters: @{
                    @"username" : username,
                    @"password" : password,
                    @"email" : email
            }
            success: ^(AFHTTPRequestOperation *task, id responseObject) {
                if (success) {
                    success();
                }
            }
            failure: ^(AFHTTPRequestOperation *task, NSError *error) {
                if (failure) {
                    failure();
                } else {
                    self.generalFailureBlock();
                }
            }];
}

- (void) loginUser: (NSString *) username password: (NSString *) password completion: (void (^)()) completion failure: (void (^)()) failure {
    DDLogVerbose(@"LOGIN with username: %@, password: %@", username, password);

    [self.authClient authenticateUsingOAuthWithURLString: TFAuthURL
            username: username
            password: password
            scope: TFScopeEmail
            success: ^(AFOAuthCredential *credential) {
                DDLogVerbose(@"LOGIN succeeded.");

                [AFOAuthCredential storeCredential: credential withIdentifier: self.authClient.serviceProviderIdentifier];

                self.currentUser = [[APIUser alloc] initWithUsername: username password: password];
                [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject: self.currentUser] forKey: @"currentUser"];
                [[NSUserDefaults standardUserDefaults] synchronize];

                [self getUserInfo: username completion: ^(id response) {
                    self.currentUser.email = [response objectForKey: @"email"];
                } failure: nil];

                if (completion) {
                    completion();
                }

            }

            failure: ^(NSError *error) {
                DDLogVerbose(@"LOGIN failed. Error = %@", error);

                if (failure) {
                    failure();
                }
            }];

    return;

    DDLogVerbose(@"LOGIN with username: %@, password: %@", username, password);

    [self getUserInfo: username completion: ^(id response) {
        DDLogVerbose(@"LOGIN succeeded.");

        self.currentUser = [[APIUser alloc] initWithUsername: username password: password];
        self.currentUser.email = [response objectForKey: @"email"];
        [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject: self.currentUser] forKey: @"currentUser"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        if (completion) {
            completion();
        }

    } failure: ^(NSError *error) {
        DDLogVerbose(@"LOGIN failed. Error = %@", error);

        if (failure) {
            failure();
        }
    }];

    return;

}


- (void) updateCurrentUserWithPassword: (NSString *) password
                               success: (void (^)()) success
                               failure: (void (^)(NSString *message)) failure {

    if ([self.currentUser.password isEqualToString: password]) {
        return;
    }
    [self updateUser: self.currentUser.username password: password success: success failure: failure];
}

- (void) updateCurrentUserWithEmail: (NSString *) email
                            success: (void (^)()) success
                            failure: (void (^)(NSString *message)) failure {
    if ([self.currentUser.email isEqualToString: email]) {
        return;
    }
    [self updateUser: self.currentUser.username email: email success: success failure: failure];
}

- (void) updateUser: (NSString *) username password: (NSString *) password
            success: (void (^)()) success failure: (void (^)(NSString *message)) failure {
    [self updateUser: self.currentUser.username
            params: @{@"password" : password}
            success: success
            failure: failure];
}


- (void) updateUser: (NSString *) username email: (NSString *) email
            success: (void (^)()) success failure: (void (^)(NSString *message)) failure {

    [self updateUser: self.currentUser.username
            params: @{@"email" : email}
            success: success
            failure: failure];
}

- (void) updateUser: (NSString *) username
             params: (NSDictionary *) params
            success: (void (^)()) success
            failure: (void (^)(NSString *message)) failure {

    [self.authClient PUT: [NSString stringWithFormat: @"user/%@", username]
            parameters: params
            success: ^(AFHTTPRequestOperation *task, id responseObject) {
                DDLogVerbose(@"UPDATE USER succeeded.");
                if (success) {
                    success();
                }
            }
            failure: ^(AFHTTPRequestOperation *task, NSError *error) {
                NSError *jsonError;
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData: task.responseData options: 0 error: &jsonError];
                NSString *message = [jsonDict objectForKey: @"message"];

                DDLogVerbose(@"UPDATE USER failed. Error = %@", error);
                if (failure) {
                    failure(message);
                } else {
                    [self failureBlockWithTitle: @"Oops" message: message]();
                }
            }];
}


- (void) signOutWithCompletion: (void (^)()) completion {

    //    [AFOAuthCredential deleteCredentialWithIdentifier: ThoughtFlowIdentifier];
    _currentUser = nil;

    AFOAuthCredential *storedCredential = [AFOAuthCredential retrieveCredentialWithIdentifier: self.authClient.serviceProviderIdentifier];

    //    [self.authClient authenticateUsingOAuthWithURLString: TFAuthURL
    //            username: @"dani3"
    //            password: @"dani3"
    //            scope: TFScopeEmail
    //            success: ^(AFOAuthCredential *credential) {
    //
    //                NSLog(@"%s", __PRETTY_FUNCTION__);
    //            }
    //
    //            failure: ^(NSError *error) {
    //
    //                NSLog(@"%s", __PRETTY_FUNCTION__);
    //            }];

    NSLog(@"storedCredential = %@", storedCredential);

    [self.authClient authenticateUsingOAuthWithURLString: TFAuthURL
            refreshToken: storedCredential.refreshToken
            success: ^(AFOAuthCredential *credential) {

                NSLog(@"Succeeded refresh token.");

                //                NSLog(@"credential = %@", credential);
            }

            failure: ^(NSError *error) {

                NSLog(@"error = %@", error);
                //                NSLog(@"%s", __PRETTY_FUNCTION__);
            }];

    //    _authClient = nil;



    [[NSUserDefaults standardUserDefaults] setObject: nil forKey: @"currentUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    DDLogVerbose(@"Sign out completed. %s", __PRETTY_FUNCTION__);
    if (completion) {
        completion();
    }
}

#pragma mark - TFUser


- (void) getUserInfo: (NSString *) username completion: (void (^)(id response)) success failure: (void (^)(NSError *error)) failure {
    DDLogVerbose(@"USERINFO with username = %@.", username);
    [self.authClient GET: [NSString stringWithFormat: @"user/%@", username]
            parameters: nil
            success: ^(AFHTTPRequestOperation *task, id responseObject) {
                DDLogVerbose(@"USERINFO Suceeded.");
                if (success) {
                    success(responseObject);
                }
            }
            failure: ^(AFHTTPRequestOperation *task, NSError *error) {
                DDLogVerbose(@"USERINFO Failed.");
                if (failure) {
                    failure(error);
                }
            }];
}


#pragma mark Image query

- (void) getImages: (NSString *) string
           success: (void (^)(NSArray *images)) success failure: (void (^)()) failure {

    @try {
        [self.authClient GET: [NSString stringWithFormat: @"inspiration?q=%@", [string rm_URLEncodedString]]
                parameters: @{

                }
                success: ^(AFHTTPRequestOperation *task, id responseObject) {
                    NSArray *photos = [responseObject objectForKey: @"photos"];

                    DDLogVerbose(@"%s, [photos count] = %u", __PRETTY_FUNCTION__, [photos count]);

                    NSMutableArray *ret = [[NSMutableArray alloc] init];
                    for (NSDictionary *photo in photos) {
                        TFPhoto *tfPhoto = [[PhotoLibrary sharedLibrary] photoFromDictionary: photo];
                        [ret addObject: tfPhoto];
                    }

                    if (success) {
                        success(ret);
                    }
                }
                failure: ^(AFHTTPRequestOperation *task, NSError *error) {
                    if (failure) {
                        failure();
                    }
                }];

    } @catch (NSException *exception1) {

    }

}

- (void) preloadImages: (NSArray *) images {

    for (TFPhoto *photo in images) {
        NSURLRequest *imageRequest = [[NSURLRequest alloc] initWithURL: photo.URL];

        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest: imageRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        requestOperation.queuePriority = NSOperationQueuePriorityLow;
        [requestOperation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
            //            NSLog(@"Response: %@", responseObject);

        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            //            NSLog(@"Image error: %@", error);
        }];

        [[NSOperationQueue mainQueue] addOperation: requestOperation];

    }



    //
    //    [ret.imageView setImageWithURLRequest: imageRequest placeholderImage: nil
    //            success: ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    //                ret.imageView.alpha = 0;
    //                ret.imageView.image = image;
    //
    //                [UIView animateWithDuration: 0.4 animations: ^{
    //                    ret.imageView.alpha = 0.2;
    //                }];
    //            }
    //            failure: ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    //
    //            }];
}

- (void) cacheImageWithURL: (NSURL *) url {

}


- (AFOAuth2Client *) authClient {
    if (_authClient == nil) {
        [self initAuthClient];
    }
    return _authClient;
}


- (void) initAuthClient {
    NSURL *url = [NSURL URLWithString: @"http://188.226.201.79/api/v1"];
    _authClient = [AFOAuth2Client clientWithBaseURL: url
            clientID: @"2dc300c232a003156fddd1d9aecb38d9da9ad49a"
            secret: @"66df225f66bdbe89d5f04825aea2efa9731edd5a"];

    //    _authClient.shouldUseCredentialStorage = YES;

    //    _authClient.

    //        _authClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    //        _authClient.responseSerializer = [AFJSONResponseSerializer serializer];

    [_authClient.reachabilityManager setReachabilityStatusChangeBlock: ^(AFNetworkReachabilityStatus status) {
        switch (status) {

            case AFNetworkReachabilityStatusUnknown : {
                NSLog(@"Unknown.");

            }
                break;
            case AFNetworkReachabilityStatusNotReachable : {
                NSLog(@"Not reachable.");
                //                    if (DEBUG) {
                //                        _usesDummyData = YES;
                //                    }

            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN : {
                NSLog(@"AFNetworkReachabilityStatusReachableViaWWAN");
            }

                break;
            case AFNetworkReachabilityStatusReachableViaWiFi : {
                NSLog(@"AFNetworkReachabilityStatusReachableViaWiFi");
            }
                break;
        }
    }];
}

@end