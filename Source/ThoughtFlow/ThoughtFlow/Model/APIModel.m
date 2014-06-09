//
// Created by Dani Postigo on 6/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "APIModel.h"
#import "Model.h"
#import "AFOAuth2Client.h"
#import "UIAlertView+Blocks.h"
#import "APIUser.h"

NSString *const ThoughtFlowIdentifier = @"188.226.201.79";
NSString *const ThoughtFlowBaseURL = @"http://188.226.201.79";

@implementation APIModel

@synthesize currentUser;

- (id) init {
    self = [super init];
    if (self) {
        _model = [Model sharedModel];
    }

    return self;
}


- (BOOL) loggedIn {
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier: ThoughtFlowIdentifier];
    if (credential) {

        NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey: @"currentUser"];
        self.currentUser = [NSKeyedUnarchiver unarchiveObjectWithData: encodedObject];

    }
    return credential != nil;
}

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


- (void) login: (NSString *) username password: (NSString *) password completion: (void (^)()) completion failure: (void (^)()) failure {
    [_model.authClient authenticateUsingOAuthWithURLString: @"http://188.226.201.79/api/oauth/token"
            username: username
            password: password
            scope: @"email"
            success: ^(AFOAuthCredential *credential) {
                NSLog(@"_model.authClient.serviceProviderIdentifier = %@", _model.authClient.serviceProviderIdentifier);

                self.currentUser = [[APIUser alloc] initWithUsername: username password: password];
                [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject: self.currentUser] forKey: @"currentUser"];
                [[NSUserDefaults standardUserDefaults] synchronize];

                [AFOAuthCredential storeCredential: credential withIdentifier: _model.authClient.serviceProviderIdentifier];

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

- (void) userExists: (NSString *) username completion: (void (^)(BOOL exists)) success {
    [_model.authClient GET: [NSString stringWithFormat: @"username/%@", username]
            parameters: nil
            success: ^(AFHTTPRequestOperation *task, id responseObject) {
                success(YES);
            }
            failure: ^(AFHTTPRequestOperation *task, NSError *error) {
                success(NO);
            }];
}


- (void) createUser: (NSString *) username password: (NSString *) password email: (NSString *) email
            success: (void (^)()) success failure: (void (^)()) failure {

    [_model.authClient POST: @"user"
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
@end