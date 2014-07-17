//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <AutoCoding/AutoCoding.h>
#import "Project.h"
#import "TFNode.h"
#import "PhotoLibrary.h"
#import "TFPhoto.h"


@interface Project ()

@property(nonatomic, strong) NSArray *pins;
@end

@implementation Project

- (instancetype) initWithWord: (NSString *) word {
    self = [super init];
    if (self) {

        _creationDate = [NSDate date];

        [self.mutableChildren addObject: [[TFNode alloc] initWithTitle: word]];

        _pins = [[PhotoLibrary sharedLibrary] pinsForProject: self];

        [self _postSetup];

    }

    return self;
}

- (NSUInteger) numNodes {
    return 0;
}




#pragma mark - Public

- (void) addPin: (TFPhoto *) image {
    if (![self.pinnedImages containsObject: image]) {
        [[self mutableArrayValueForKey: @"pins"] addObject: image];
    }
}

- (void) removePin: (TFPhoto *) image {
    if ([self.pinnedImages containsObject: image]) {
        [[self mutableArrayValueForKey: @"pins"] removeObject: image];
    }
}


- (void) setNotes: (NSString *) notes1 {
    if (![_notes isEqualToString: notes1]) {
        _notes = [notes1 mutableCopy];
        [self save];
    }
}


#pragma mark Getters

- (NSString *) word {
    return self.firstNode.title;
}

- (NSArray *) nodes {
    return self.children;
}


- (TFNode *) firstNode {
    return [self.children objectAtIndex: 0];
}

- (NSArray *) flattenedChildren {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    [ret addObjectsFromArray: [self.firstNode allChildren]];
    [ret addObject: self.firstNode];
    return ret;
}



#pragma mark - Setup

- (void) setWithCoder: (NSCoder *) aDecoder {
    [super setWithCoder: aDecoder];

    [self _postSetup];
}


- (void) _postSetup {
    _pins = [[PhotoLibrary sharedLibrary] pinsForProject: self];
    [self addObserver: self forKeyPath: @"pins" options: 0 context: NULL];
}


#pragma mark - Private


- (NSArray *) pinnedImages {
    return [self mutableArrayValueForKey: @"pins"];
}


- (void) observeValueForKeyPath: (NSString *) keyPath ofObject: (id) object change: (NSDictionary *) change context: (void *) context {
    if (object == self && [keyPath isEqualToString: @"pins"]) {

        //        NSLog(@"%s", __PRETTY_FUNCTION__);
        //        NSLog(@"[_pins count] = %u", [_pins count]);
        //        [[PhotoLibrary sharedLibrary] storePins: self.pinnedImages forProject: self];
        //        NSArray *array = [[PhotoLibrary sharedLibrary] pinsForProject: self];
        //        NSLog(@"[array count] = %u", [array count]);
        //        _pins = array;

        //        NSLog(@"[_pins count] = %u", [_pins count]);
        //        NSLog(@"[self.pinnedImages count] = %u", [self.pinnedImages count]);
        //        NSLog(@"self.pinnedImages = %@", self.pinnedImages);

        _pins = [[PhotoLibrary sharedLibrary] storePins: self.pinnedImages forProject: self];
        //        NSLog(@"[_pins count] = %u", [_pins count]);

    } else {
        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
    }
}


@end