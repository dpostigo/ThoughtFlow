//
// Created by Dani Postigo on 5/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"

@interface MindmapBackgroundController : TFViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate> {

    NSArray *images;

}

@property(weak) IBOutlet UIImageView *imageView;
@property(weak) IBOutlet UICollectionView *collection;
@property(nonatomic, strong) NSArray *images;
@end