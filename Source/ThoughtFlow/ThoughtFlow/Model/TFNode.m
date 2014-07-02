//
// Created by Dani Postigo on 5/4/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNode.h"
#import "TFNodeView.h"

@implementation TFNode

NSString *const TFNodeUpdate = @"TFNodeUpdate";

- (instancetype) initWithTitle: (NSString *) aTitle position: (CGPoint) position {
    self = [super init];
    if (self) {
        _title = aTitle;
        _position = position;
    }

    return self;
}

+ (instancetype) nodeWithTitle: (NSString *) aTitle position: (CGPoint) position {
    return [[self alloc] initWithTitle: aTitle position: position];
}

- (instancetype) initWithTitle: (NSString *) aTitle {
    self = [super init];
    if (self) {
        _title = aTitle;
    }

    return self;
}

+ (instancetype) nodeWithTitle: (NSString *) aTitle {
    return [[self alloc] initWithTitle: aTitle];
}


- (void) setTitle: (NSString *) title1 {
    if (![_title isEqualToString: title1]) {
        _title = [title1 mutableCopy];
        [[NSNotificationCenter defaultCenter] postNotificationName: TFNodeUpdate object: self];

    }
}

//
//- (void) setPosition: (CGPoint) position {
//    self.positionX = [NSNumber numberWithFloat: position.x];
//    self.positionY = [NSNumber numberWithFloat: position.y];
//}
//
//


- (void) setPosition: (CGPoint) position1 {
    if (!CGPointEqualToPoint(_position, position1)) {
        _position = position1;
        [[NSNotificationCenter defaultCenter] postNotificationName: @"TFNodeDidUpdatePosition" object: nil];
    }
}


- (CGPoint) center {
    return CGPointMake(_position.x + (TFNodeViewWidth / 2), _position.y + (TFNodeViewHeight / 2));
}


- (NSArray *) allChildren {
    return [self getNodeChildren: self];
}


- (NSArray *) getNodeChildren: (TFNode *) node {
    NSMutableArray *ret = [[NSMutableArray alloc] init];

    NSArray *children = [node children];
    [ret addObjectsFromArray: children];

    for (int j = 0; j < [children count]; j++) {
        [ret addObjectsFromArray: [self getNodeChildren: [children objectAtIndex: j]]];
    }

    return ret;
}


- (TFNode *) parentNode {
    return self.parent != nil ? ([self.parent isKindOfClass: [TFNode class]] ? self.parent : nil) : nil;
}

@end