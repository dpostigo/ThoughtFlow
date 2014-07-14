//
// Created by Dani Postigo on 5/5/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <AutoCoding/AutoCoding.h>
#import <NSObject+AutoDescription/NSObject+AutoDescription.h>
#import "LibraryObject.h"
#import "TFNode.h"


@implementation LibraryObject

- (void) save {
    if (self.parent) {
        if ([self.parent respondsToSelector: @selector(save)]) {
            [self.parent performSelector: @selector(save)];
        }
    }
}

- (id) init {
    self = [super init];
    if (self) {
        _uniqueIdentifier = [[self class] uuid];
        [self _postSetup];
    }

    return self;
}


+ (NSString *) uuid {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge NSString *) uuidStringRef;
}

- (void) observeValueForKeyPath: (NSString *) keyPath ofObject: (id) object change: (NSDictionary *) change context: (void *) context {
    if (object == self && [keyPath isEqualToString: @"children"]) {
        [self setParentForChildren];
    } else {
        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
    }
}


- (void) addChild: (id) item {
    [self.mutableChildren addObject: item];
    [self save];
}


- (void) addChildren: (NSArray *) items {
    [self.mutableChildren addObjectsFromArray: items];
    [items enumerateObjectsUsingBlock: ^(id item, NSUInteger idx, BOOL *stop) {
        if ([item respondsToSelector: @selector(setParent:)]) {
            [item performSelector: @selector(setParent:) withObject: self];
        }
    }];
    [self save];
}


- (void) removeChild: (id) item {
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

    [self _postSetup];
    [self setParentForChildren];

}


- (void) _postSetup {
    [self addObserver: self forKeyPath: @"children" options: 0 context: NULL];

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