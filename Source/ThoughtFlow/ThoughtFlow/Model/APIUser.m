//
// Created by Dani Postigo on 6/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "APIUser.h"
#import "TFUserPreferences.h"


@implementation APIUser

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
        _username = anUsername;
        _email = anEmail;
        _password = aPassword;
        _preferences = [[TFUserPreferences alloc] init];
    }

    return self;
}


- (void) encodeWithCoder: (NSCoder *) coder {
    [coder encodeObject: _username forKey: @"username"];
    [coder encodeObject: _email forKey: @"email"];
    [coder encodeObject: _password forKey: @"password"];
    [coder encodeObject: _preferences forKey: @"preferences"];
}

- (id) initWithCoder: (NSCoder *) coder {
    self = [super init];
    if (self) {
        _username = [coder decodeObjectForKey: @"username"];
        _email = [coder decodeObjectForKey: @"email"];
        _password = [coder decodeObjectForKey: @"password"];
        _preferences = [coder decodeObjectForKey: @"preferences"];

        if (_preferences == nil) {
            _preferences = [[TFUserPreferences alloc] init];
        }

    }

    return self;
}


@end