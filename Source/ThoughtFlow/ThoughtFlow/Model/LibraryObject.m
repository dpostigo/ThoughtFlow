//
// Created by Dani Postigo on 5/5/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "LibraryObject.h"

@implementation LibraryObject

@synthesize parent;

@synthesize items;

- (void) save {
    if (parent) {
        if ([parent respondsToSelector: @selector(save)]) {
            [parent performSelector: @selector(save)];
        }
    }
}

- (id) init {
    self = [super init];
    if (self) {
        items = [[NSMutableArray alloc] init];
    }

    return self;
}


- (void) addItem: (id) item {
    [self.items addObject: item];
    [self save];
}


- (void) addItems: (NSArray *) items {
    [self.items addObjectsFromArray: items];
    [items enumerateObjectsUsingBlock: ^(id item, NSUInteger idx, BOOL *stop) {
        if ([item respondsToSelector: @selector(setParent:)]) {
            [item performSelector: @selector(setParent:) withObject: self];
        }
    }];
    [self save];
}


- (void) removeItem: (id) item {
    if ([self.items containsObject: item]) {
        [self.items removeObject: item];
        [self save];
    }
}
@end