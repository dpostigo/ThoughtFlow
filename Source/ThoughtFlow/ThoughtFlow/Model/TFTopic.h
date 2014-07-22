//
// Created by Dani Postigo on 7/21/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TFTopic : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *urlString;
@property(nonatomic, copy) NSString *description;
- (instancetype) initWithDictionary: (NSDictionary *) dictionary;

@end