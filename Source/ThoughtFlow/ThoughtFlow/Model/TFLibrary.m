//
// Created by Dani Postigo on 7/3/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <AutoCoding/AutoCoding.h>
#import "TFLibrary.h"
#import "PhotoLibrary.h"
#import "ProjectLibrary.h"


@implementation TFLibrary

- (id) init {
    self = [super init];
    if (self) {
        _photoLibrary = [PhotoLibrary sharedLibrary];
        _projectsLibrary = [ProjectLibrary sharedLibrary];
        [self _postSetup];
    }

    return self;
}


static NSString *LibraryName = @"TFLibrary.plist";

+ (NSString *) documentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (TFLibrary *) sharedLibrary {
    static TFLibrary *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            NSString *path = [[self documentsDirectory] stringByAppendingPathComponent: LibraryName];
            _instance = [TFLibrary objectWithContentsOfFile: path];

            if (_instance == nil) {
                _instance = [[TFLibrary alloc] init];
            }

        }
    }

    return _instance;
}


- (void) save {
    NSString *path = [[[self class] documentsDirectory] stringByAppendingPathComponent: LibraryName];
    [self writeToFile: path atomically: YES];
}


- (void) setWithCoder: (NSCoder *) aDecoder {
    [super setWithCoder: aDecoder];
    [self _postSetup];
}

#pragma mark - Setup


- (void) _postSetup {
    _projectsLibrary.parent = self;
}
@end