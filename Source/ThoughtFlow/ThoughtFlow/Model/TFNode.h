//
// Created by Dani Postigo on 5/4/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const TFNodeUpdate;


@interface TFNode : NSObject {
    NSString *title;

    NSNumber *positionX;
    NSNumber *positionY;


}

@property(nonatomic) CGPoint position;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSNumber *positionX;
@property(nonatomic, strong) NSNumber *positionY;

- (instancetype) initWithTitle: (NSString *) aTitle;
+ (instancetype) nodeWithTitle: (NSString *) aTitle;

@end