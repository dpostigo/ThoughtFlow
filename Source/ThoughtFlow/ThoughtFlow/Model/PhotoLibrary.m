//
// Created by Dani Postigo on 7/3/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <AutoCoding/AutoCoding.h>
#import "PhotoLibrary.h"
#import "TFPhoto.h"
#import "Project.h"


@implementation PhotoLibrary

- (id) init {
    self = [super init];
    if (self) {
        _photos = [NSArray array];
        _photoURLs = [NSArray array];

        _pins = [NSArray array];
        _pinIds = [NSArray array];

        [self _postSetup];
    }

    return self;
}



#pragma mark - Pinning


- (NSMutableArray *) pinsForProject: (Project *) project {
    NSMutableArray *ret = nil;
    NSString *identifier = project.uniqueIdentifier;

    if ([_pinIds containsObject: identifier]) {
        NSUInteger index = [_pinIds indexOfObject: identifier];
        ret = [_pins objectAtIndex: index];
    } else {
        ret = [NSMutableArray array];
        [self.mutablePinIds addObject: identifier];
        [self.mutablePins addObject: ret];
    }

    return ret;
}


- (NSArray *) storePins: (NSArray *) pins forProject: (Project *) project {

    NSLog(@"%s, pins = %@", __PRETTY_FUNCTION__, pins);
    NSMutableArray *currentPins = [self pinsForProject: project];
    NSMutableArray *newPins = [pins mutableCopy];

    if ([newPins count] > [currentPins count]) {
        [newPins removeObjectsInArray: currentPins];
        [currentPins addObjectsFromArray: newPins];
    } else {
        currentPins = [newPins mutableCopy];
    }

    if ([newPins count] == 0) {
        // was removing...
        NSLog(@"Removed....");

    } else {

    }

    NSUInteger index = [_pinIds indexOfObject: project.uniqueIdentifier];
    [self.mutablePins replaceObjectAtIndex: index withObject: currentPins];
    [self save];
    return currentPins;
    //    [pins removeAllObjects];

}

- (TFPhoto *) photoFromDictionary: (NSDictionary *) dictionary {
    TFPhoto *ret = nil;
    NSString *urlString = [dictionary objectForKey: @"url"];
    if ([_photoURLs containsObject: urlString]) {
        NSUInteger index = [_photoURLs indexOfObject: urlString];
        ret = [_photos objectAtIndex: index];

    } else {
        ret = [[TFPhoto alloc] init];
        ret.title = [dictionary objectForKey: @"title"];
        ret.description = [dictionary objectForKey: @"description"];
        ret.URL = [NSURL URLWithString: [dictionary objectForKey: @"url"]];
        ret.tagString = [dictionary objectForKey: @"tags"];

        [self.mutablePhotos addObject: ret];
        [self.mutablePhotoURLs addObject: urlString];

        id description = [dictionary objectForKey: @"description"];
//        NSLog(@"description = %@", description);

    }

    return ret;

}

- (void) addPhoto: (TFPhoto *) image {
    [self.mutablePhotos addObject: image];
}


#pragma mark - Mutable


- (NSMutableArray *) mutablePins {
    return [self mutableArrayValueForKey: @"pins"];
}

- (NSMutableArray *) mutablePinIds {
    return [self mutableArrayValueForKey: @"pinIds"];
}

- (NSMutableArray *) mutablePhotos {
    return [self mutableArrayValueForKey: @"photos"];
}

- (NSMutableArray *) mutablePhotoURLs {
    return [self mutableArrayValueForKey: @"photoURLs"];
}


- (void) observeValueForKeyPath: (NSString *) keyPath ofObject: (id) object change: (NSDictionary *) change context: (void *) context {
    if (object == self && [keyPath isEqualToString: @"pins"]) {

    } else {

        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
    }
}


#pragma mark - Store


static NSString *LibraryName = @"PhotoLibrary.plist";

+ (NSString *) documentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (PhotoLibrary *) sharedLibrary {
    static PhotoLibrary *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            NSString *path = [[self documentsDirectory] stringByAppendingPathComponent: LibraryName];
            _instance = [PhotoLibrary objectWithContentsOfFile: path];

            if (_instance == nil) {
                _instance = [[PhotoLibrary alloc] init];
            }

        }
    }

    return _instance;
}


- (void) save {
    NSString *path = [[[self class] documentsDirectory] stringByAppendingPathComponent: LibraryName];
    [self writeToFile: path atomically: YES];

    NSLog(@"%s", __PRETTY_FUNCTION__);

}


- (void) setWithCoder: (NSCoder *) aDecoder {
    [super setWithCoder: aDecoder];
    [self _postSetup];
}


#pragma mark - Setup

- (void) _postSetup {
    [self addObserver: self forKeyPath: @"pins" options: 0 context: NULL];

}
@end