//
// Created by Dani Postigo on 5/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"

@interface MoodboardController : TFViewController <UICollectionViewDelegate, UICollectionViewDataSource> {

}

@property (weak) IBOutlet UICollectionView *collection;
- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath: (NSIndexPath *) indexPath;
@end