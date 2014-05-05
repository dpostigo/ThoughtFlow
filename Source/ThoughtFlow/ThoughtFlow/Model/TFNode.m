//
// Created by Dani Postigo on 5/4/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNode.h"

@implementation TFNode

@synthesize title;

@synthesize positionX;
@synthesize positionY;
NSString *const TFNodeUpdate = @"TFNodeUpdate";

- (instancetype) initWithTitle: (NSString *) aTitle {
    self = [super init];
    if (self) {
        title = aTitle;
    }

    return self;
}

+ (instancetype) nodeWithTitle: (NSString *) aTitle {
    return [[self alloc] initWithTitle: aTitle];
}


- (void) setTitle: (NSString *) title1 {
    if (![title isEqualToString: title1]) {
        title = [title1 mutableCopy];
        [[NSNotificationCenter defaultCenter] postNotificationName: TFNodeUpdate object: self];

    }
}

- (void) setPosition: (CGPoint) position {
    self.positionX = [NSNumber numberWithFloat: position.x];
    self.positionY = [NSNumber numberWithFloat: position.y];
}


- (CGPoint) position {
    return CGPointMake([self.positionX floatValue], [self.positionY floatValue]);
}


@end