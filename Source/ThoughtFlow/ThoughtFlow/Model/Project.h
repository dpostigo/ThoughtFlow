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
@property(nonatomic, copy) NSString *word;
@property(nonatomic, copy) NSString *notes;


//@property(nonatomic, readonly) NSMutableArray *pinnedImages;

- (instancetype) initWithWord: (NSString *) aWord;
+ (instancetype) projectWithWord: (NSString *) aWord;
- (NSArray *) nodes;

- (TFNode *) firstNode;
- (NSArray *) flattenedChildren;
- (void) addPin: (TFPhoto *) image;
- (void) removePin: (TFPhoto *) image;
- (NSMutableArray *) pinnedImages;
- (void) addNode: (id) node;
@end