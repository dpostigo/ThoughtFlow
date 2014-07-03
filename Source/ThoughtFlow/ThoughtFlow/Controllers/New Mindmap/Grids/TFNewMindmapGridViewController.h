//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFImageGridViewController.h"


@class Project;
@class TFImageGridViewController;
@class TFEmptyViewController;
@class TFPhoto;


@interface TFNewMindmapGridViewController : UIViewController <TFImageGridViewControllerDelegate> {

}

@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) TFPhoto *selectedImage;
@property(nonatomic, strong) NSArray *images;
//@property(nonatomic, copy) NSString *imageString;
@property(nonatomic, strong) TFImageGridViewController *imagesController;
- (instancetype) initWithProject: (Project *) project images: (NSArray *) images;


@end