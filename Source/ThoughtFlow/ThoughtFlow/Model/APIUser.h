//
// Created by Dani Postigo on 6/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFUserPreferences;


@interface APIUser : NSObject <NSCoding> {
    NSString *username;
    NSString *email;
    NSString *password;

}

@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *email;
@property(nonatomic, copy) NSString *password;

@property(nonatomic, strong) TFUserPreferences *preferences;
- (instancetype) initWithUsername: (NSString *) anUsername email: (NSString *) anEmail password: (NSString *) aPassword;
- (instancetype) initWithUsername: (NSString *) anUsername password: (NSString *) aPassword;
+ (instancetype) userWithUsername: (NSString *) anUsername password: (NSString *) aPassword;
+ (instancetype) userWithUsername: (NSString *) anUsername email: (NSString *) anEmail password: (NSString *) aPassword;

@end