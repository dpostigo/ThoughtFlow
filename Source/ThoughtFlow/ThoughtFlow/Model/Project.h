//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibraryObject.h"

@interface Project : LibraryObject {

    NSString *word;
    NSString *notes;
    NSDate *creationDate;

    NSUInteger numNodes;


}

@property(nonatomic, copy) NSString *word;
@property(nonatomic, copy) NSString *notes;
@property(nonatomic, strong) NSDate *creationDate;

- (instancetype) initWithWord: (NSString *) aWord;
+ (instancetype) projectWithWord: (NSString *) aWord;
- (NSArray *) nodes;

- (NSUInteger) numNodes;
- (void) addNode: (id) node;
@end