//
// Created by Dani Postigo on 6/20/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CollectionViewSelectionDelegate <NSObject>


- (void)collectionView:(UICollectionView *)collectionView selectedItemAtIndexPath: (NSIndexPath *) indexPath;
@end