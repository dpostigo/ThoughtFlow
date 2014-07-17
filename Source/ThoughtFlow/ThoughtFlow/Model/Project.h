//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibraryObject.h"


@class TFNode;
@class TFPhoto;

@interface Project : LibraryObject

@property(nonatomic, strong) NSDate *creationDate;
@property(nonatomic, strong) NSDate *modifiedDate;
@property(nonatomic, copy) NSString *notes;


@property(nonatomic, readonly) TFNode *firstNode;
@property(nonatomic, readonly) NSString *word;
@property(nonatomic, readonly) NSArray *nodes;
@property(nonatomic, readonly) NSArray *flattenedChildren;
@property(nonatomic, readonly) NSArray *pinnedImages;

- (instancetype) initWithWord: (NSString *) word;

- (void) addPin: (TFPhoto *) image;
- (void) removePin: (TFPhoto *) image;

@end