//
// Created by Dani Postigo on 5/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibraryObject.h"

@interface TFImage : LibraryObject {

    NSString *author;
    NSString *description;
    NSString *sourceURL;
    NSArray *tags;

}

@property(nonatomic, copy) NSString *sourceURL;
@property(nonatomic, strong) NSArray *tags;
@property(nonatomic, copy) NSString *description;
@end