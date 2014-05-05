//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Project : NSObject {

    NSString *word;
    NSString *notes;
    NSDate *creationDate;

    NSMutableArray *items;
    NSUInteger numNodes;

    __unsafe_unretained id parent;


}

@property(nonatomic, copy) NSString *word;
@property(nonatomic, copy) NSString *notes;
@property(nonatomic, strong) NSDate *creationDate;
@property(nonatomic, assign) id parent;

@property(nonatomic, strong) NSMutableArray *items;
- (instancetype) initWithWord: (NSString *) aWord;
+ (instancetype) projectWithWord: (NSString *) aWord;
- (NSArray *) nodes;

- (NSUInteger) numNodes;
- (void) addNode: (id) node;
@end