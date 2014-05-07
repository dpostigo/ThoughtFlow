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
        NSString *path = [[self documentsDirectory] stringByAppendingPathComponent: @"ProjectLibrary.plist"];
        sharedLibrary = [ProjectLibrary objectWithContentsOfFile: path];

        if (sharedLibrary == nil) {
            sharedLibrary = [[ProjectLibrary alloc] init];
        }
    }
    return sharedLibrary;
}


- (void) save {
    NSString *path = [[[self class] documentsDirectory] stringByAppendingPathComponent: @"ProjectLibrary.plist"];
    [self writeToFile: path atomically: YES];

    for (int j = 0; j < [self.items count]; j++) {
        id item = [self.items objectAtIndex: j];
        NSLog(@"[item autoDescription] = %@", [item autoDescription]);
    }
}


- (void) setWithCoder: (NSCoder *) aDecoder {
    [super setWithCoder: aDecoder];
    //    NSLog(@"%s, [self.items count] = %u", __PRETTY_FUNCTION__, [self.items count]);
    //
    //    for (Project *project in self.items) {
    //        project.parent = self;
    //    }

    for (id item in self.items) {
        if ([item respondsToSelector: @selector(setParent:)]) {
            [item performSelector: @selector(setParent:) withObject: self];
        }
    }
}


@end