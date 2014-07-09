//
// Created by Dani Postigo on 7/3/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFPhoto;
@class Project;


@interface PhotoLibrary : NSObject

//@property(nonatomic, strong) NSMutableDictionary *pins;
@property(nonatomic, strong) NSArray *pins;
@property(nonatomic, strong) NSArray *pinIds;
@property(nonatomic, strong) NSArray *photos;
@property(nonatomic, strong) NSArray *photoURLs;
+ (PhotoLibrary *) sharedLibrary;

- (void) save;
- (NSMutableArray *) pinsForProject: (Project *) project;
- (NSArray *) storePins: (NSMutableArray *) pins forProject: (Project *) project;
- (TFPhoto *) photoFromDictionary: (NSDictionary *) dictionary;
- (void) addPhoto: (TFPhoto *) image;
@end