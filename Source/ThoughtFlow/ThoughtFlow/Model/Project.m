//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "Project.h"
#import "TFNode.h"

@implementation Project

@synthesize word;
@synthesize creationDate;
@synthesize notes;

- (instancetype) initWithWord: (NSString *) aWord {
    self = [super init];
    if (self) {
        word = aWord;
        [self.items addObject: [[TFNode alloc] initWithTitle: word]];
        creationDate = [NSDate date];
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
    [self.items addObject: node];
    [self save];
}

//- (void) removeNode: (id) node {
//    [self removeItem: node];
//}


#pragma mark Setters with save

- (void) setNotes: (NSString *) notes1 {
    if (![notes isEqualToString: notes1]) {
        notes = [notes1 mutableCopy];
        [self save];
    }
}


#pragma mark Getters

- (NSMutableArray *) items {
    if (items == nil) {
        items = [[NSMutableArray alloc] init];
    }
    return items;
}


- (NSArray *) nodes {
    return self.items;
}

@end