//
// Created by Dani Postigo on 6/14/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFPhoto : NSObject {
    NSString *title;
    NSString *description;
    NSURL *URL;
    NSString *tagString;

}

@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSURL *URL;
@property(nonatomic, copy) NSString *tagString;
- (instancetype) initWithTitle: (NSString *) aTitle description: (NSString *) aDescription URL: (NSURL *) aURL;
- (instancetype) initWithTitle: (NSString *) aTitle description: (NSString *) aDescription URL: (NSURL *) aURL tagString: (NSString *) aTagString;
+ (instancetype) photoWithTitle: (NSString *) aTitle description: (NSString *) aDescription URL: (NSURL *) aURL tagString: (NSString *) aTagString;

+ (instancetype) photoWithTitle: (NSString *) aTitle description: (NSString *) aDescription URL: (NSURL *) aURL;

@end