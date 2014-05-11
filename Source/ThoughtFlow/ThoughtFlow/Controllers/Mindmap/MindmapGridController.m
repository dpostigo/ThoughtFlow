//
// Created by Dani Postigo on 5/11/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "MindmapGridController.h"
#import "TFMoodboardCollectionViewCell.h"

@implementation MindmapGridController

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    UICollectionViewCell *ret = [super collectionView: collectionView cellForItemAtIndexPath: indexPath];

    if ([ret isKindOfClass: [TFMoodboardCollectionViewCell class]]) {
        TFMoodboardCollectionViewCell *cell = (TFMoodboardCollectionViewCell *) ret;
        //             cell.butt
    }
    return ret;
}

@end