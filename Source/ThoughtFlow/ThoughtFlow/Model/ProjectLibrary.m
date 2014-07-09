//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "ProjectLibrary.h"
#import "AutoCoding.h"
#import "Project.h"
#import "NSObject+AutoDescription.h"


@implementation ProjectLibrary

+ (NSString *) documentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (ProjectLibrary *) sharedLibrary {
    static ProjectLibrary *sharedLibrary = nil;
    if (sharedLibrary == nil) {
        NSString *path = [[self documentsDirectory] stringByAppendingPathComponent: @"PhotoLibrary.plist"];
        sharedLibrary = [ProjectLibrary objectWithContentsOfFile: path];

        if (sharedLibrary == nil) {
            sharedLibrary = [[ProjectLibrary alloc] init];
        }
    }
    return sharedLibrary;
}

- (id) init {
    self = [super init];
    if (self) {

        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(save:) name: @"TFNodeDidUpdatePosition" object: nil];
    }

    return self;
}


- (void) save: (id) sender {
    [self save];
}


- (void) setWithCoder: (NSCoder *) aDecoder {
    [super setWithCoder: aDecoder];
    //    NSLog(@"%s, [self.children count] = %u", __PRETTY_FUNCTION__, [self.children count]);
    //
    //    for (Project *project in self.children) {
    //        project.parent = self;
    //    }

    for (id item in self.children) {
        if ([item respondsToSelector: @selector(setParent:)]) {
            [item performSelector: @selector(setParent:) withObject: self];
        }
    }
}


@end