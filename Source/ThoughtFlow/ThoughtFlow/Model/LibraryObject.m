//
// Created by Dani Postigo on 5/5/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <AutoCoding/AutoCoding.h>
#import "LibraryObject.h"

@implementation LibraryObject

@synthesize parent;

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
        [self addObserver: self forKeyPath: @"children" options: 0 context: NULL];
    }

    return self;
}


- (void) observeValueForKeyPath: (NSString *) keyPath ofObject: (id) object change: (NSDictionary *) change context: (void *) context {
    if (object == self && [keyPath isEqualToString: @"children"]) {
        [self setParentForChildren];

    } else {

        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
    }
}


- (void) addItem: (id) item {
    [self.mutableChildren addObject: item];
    [self save];
}


- (void) addItems: (NSArray *) items {
    [self.mutableChildren addObjectsFromArray: items];
    [items enumerateObjectsUsingBlock: ^(id item, NSUInteger idx, BOOL *stop) {
        if ([item respondsToSelector: @selector(setParent:)]) {
            [item performSelector: @selector(setParent:) withObject: self];
        }
    }];
    [self save];
}


- (void) removeItem: (id) item {
    if ([self.children containsObject: item]) {
        [self.mutableChildren removeObject: item];
        [self save];
    }
}


- (NSArray *) children {
    if (_children == nil) {
        _children = [NSArray array];
    }
    return _children;
}


- (NSMutableArray *) mutableChildren {
    return [self mutableArrayValueForKey: @"children"];
}


- (void) setWithCoder: (NSCoder *) aDecoder {
    [super setWithCoder: aDecoder];

    [self setParentForChildren];

}


- (void) setParentForChildren {
    [self.children enumerateObjectsUsingBlock: ^(id obj, NSUInteger index, BOOL *stop) {
        if ([obj isKindOfClass: [LibraryObject class]]) {
            LibraryObject *libraryObject = obj;
            libraryObject.parent = self;
        }
    }];
}
@end