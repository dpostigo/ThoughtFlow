//
// Created by Dani Postigo on 6/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "APIUser.h"

@implementation APIUser

@synthesize username;
@synthesize email;
@synthesize password;

- (instancetype) initWithUsername: (NSString *) anUsername password: (NSString *) aPassword {
    return [self initWithUsername: anUsername email: nil password: aPassword];
}

+ (instancetype) userWithUsername: (NSString *) anUsername password: (NSString *) aPassword {
    return [[self alloc] initWithUsername: anUsername password: aPassword];
}

+ (instancetype) userWithUsername: (NSString *) anUsername email: (NSString *) anEmail password: (NSString *) aPassword {
    return [[self alloc] initWithUsername: anUsername email: anEmail password: aPassword];
}

- (instancetype) initWithUsername: (NSString *) anUsername email: (NSString *) anEmail password: (NSString *) aPassword {
    self = [super init];
    if (self) {
        username = anUsername;
        email = anEmail;
        password = aPassword;
    }

    return self;
}


- (void) encodeWithCoder: (NSCoder *) coder {
    [coder encodeObject: username forKey: @"username"];
    [coder encodeObject: email forKey: @"email"];
    [coder encodeObject: password forKey: @"password"];
}

- (id) initWithCoder: (NSCoder *) coder {
    self = [super init];
    if (self) {
        username = [coder decodeObjectForKey: @"username"];
        email = [coder decodeObjectForKey: @"email"];
        password = [coder decodeObjectForKey: @"password"];

    }

    return self;
}


@end