//
// Created by Dani Postigo on 7/3/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PhotoLibrary;
@class ProjectLibrary;


@interface TFLibrary : NSObject {

}

@property(nonatomic, strong) PhotoLibrary *photoLibrary;
@property(nonatomic, strong) ProjectLibrary *projectsLibrary;

+ (TFLibrary *) sharedLibrary;
@end