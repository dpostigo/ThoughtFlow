//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "Project.h"
#import "TFNode.h"



@implementation Project

- (instancetype) initWithWord: (NSString *) aWord {
    self = [super init];
    if (self) {

        _creationDate = [NSDate date];
        _word = aWord;

        _pinnedImages = [[NSMutableArray alloc] init];

        [self.mutableChildren addObject: [[TFNode alloc] initWithTitle: _word]];
    }

    return self;
}

+ (instancetype) projectWithWord: (NSString *) aWord {
    return [[self alloc] initWithWord: aWord];
}

- (NSUInteger) numNodes {
    return 0;
}



#pragma mark Nodes

- (void) addNode: (id) node {
    [self.mutableChildren addObject: node];
    [self save];
}

//- (void) removeNode: (id) node {
//    [self removeItem: node];
//}


#pragma mark Setters with save

- (void) setNotes: (NSString *) notes1 {
    if (![_notes isEqualToString: notes1]) {
        _notes = [notes1 mutableCopy];
        [self save];
    }
}


#pragma mark Getters




- (NSArray *) nodes {
    return self.children;
}


- (TFNode *) firstNode {
    return [self.children objectAtIndex: 0];
}

- (NSArray *) flattenedChildren {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    [ret addObject: self.firstNode];
    [ret addObjectsFromArray: [self.firstNode allChildren]];
    return ret;
}
@end