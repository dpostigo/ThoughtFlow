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


NSString *const ThoughtFlowIdentifier = @"188.226.201.79";
NSString *const ThoughtFlowBaseURL = @"http://188.226.201.79";

@implementation APIModel

- (id) init {
    self = [super init];
    if (self) {
        _model = [Model sharedModel];
        _photoLibrary = [PhotoLibrary sharedLibrary];

        NSURL *url = [NSURL URLWithString: @"http://188.226.201.79/api/v1"];
        _authClient = [AFOAuth2Client clientWithBaseURL: url
                clientID: @"2dc300c232a003156fddd1d9aecb38d9da9ad49a"
                secret: @"66df225f66bdbe89d5f04825aea2efa9731edd5a"];

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
                    if (DEBUG) {
                        _usesDummyData = YES;
                    }

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
            [AFOAuthCredential deleteCredentialWithIdentifier: ThoughtFlowIdentifier];
        } else {
            NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey: @"currentUser"];
            if (encodedObject) {
                _currentUser = [NSKeyedUnarchiver unarchiveObjectWithData: encodedObject];
            }
        }
    }

    return _currentUser != nil;
}

#pragma mark Errors

- (void (^)()) generalFailureBlock {
    return ^{
        [APIModel alertErrorWithTitle: @"Error" message: @"There was en error."];
    };
}


+ (void) alertErrorWithTitle: (NSString *) title message: (NSString *) message {
    [UIAlertView showWithTitle: title
            message: message
            cancelButtonTitle: @"OK"
            otherButtonTitles: @[]
            tapBlock: nil];
}

#pragma mark Login / Register

- (void) login: (NSString *) username password: (NSString *) password completion: (void (^)()) completion failure: (void (^)()) failure {
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);

    [self.authClient authenticateUsingOAuthWithURLString: @"http://188.226.201.79/api/oauth/token"
            username: username
            password: password
            scope: @"email"
            success: ^(AFOAuthCredential *credential) {
                NSLog(@"_model.authClient.serviceProviderIdentifier = %@", self.authClient.serviceProviderIdentifier);

                self.currentUser = [[APIUser alloc] initWithUsername: username password: password];
                [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject: self.currentUser] forKey: @"currentUser"];
                [[NSUserDefaults standardUserDefaults] synchronize];

                [self getUserInfo: username completion: ^(id response) {
                    self.currentUser.email = [response objectForKey: @"email"];
                } failure: nil];

                [AFOAuthCredential storeCredential: credential withIdentifier: self.authClient.serviceProviderIdentifier];

                if (completion) {
                    completion();
                }
            }
            failure: ^(NSError *error) {
                NSLog(@"%s, error = %@", __PRETTY_FUNCTION__, error);
                if (failure) {
                    failure();
                }
            }];

}


- (void) getUserInfo: (NSString *) username completion: (void (^)(id response)) success failure: (void (^)()) failure {
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    [self.authClient GET: [NSString stringWithFormat: @"user/%@", username]
            parameters: nil
            success: ^(AFHTTPRequestOperation *task, id responseObject) {
                success(responseObject);
            }
            failure: ^(AFHTTPRequestOperation *task, NSError *error) {
                failure();
            }];
}

- (void) userExists: (NSString *) username completion: (void (^)(BOOL exists)) success {
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    [self.authClient GET: [NSString stringWithFormat: @"username/%@", username]
            parameters: nil
            success: ^(AFHTTPRequestOperation *task, id responseObject) {
                success(YES);
                DDLogVerbose(@"%s, responseObject = %@", __PRETTY_FUNCTION__, responseObject);

            }
            failure: ^(AFHTTPRequestOperation *task, NSError *error) {
                success(NO);
                DDLogVerbose(@"%s, error = %@", __PRETTY_FUNCTION__, error);
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


- (void) updateUser: (NSString *) username email: (NSString *) email {

}


#pragma mark Image query

- (void) getImages: (NSString *) string
           success: (void (^)(NSArray *images)) success failure: (void (^)()) failure {

    @try {
        [self.authClient GET: [NSString stringWithFormat: @"inspiration?q=%@", string]
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

    }
    return _authClient;
}


@end