//
// Created by Dani Postigo on 6/14/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFPhoto : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *tagString;
@property(nonatomic, strong) NSURL *URL;

- (instancetype) initWithDictionary: (NSDictionary *) aDictionary;


@end