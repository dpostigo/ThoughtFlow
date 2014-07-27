//
// Created by Dani Postigo on 7/26/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFMindmapGridLayout.h"


@implementation TFMindmapGridLayout

- (id) init {
    self = [super init];
    if (self) {
        self.numberOfRows = 3;

    }

    return self;
}





//
//
//- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect {
//    NSArray *array = [super layoutAttributesForElementsInRect: rect];
//
//    CGRect visibleRect;
//    visibleRect.origin = self.collectionView.contentOffset;
//    visibleRect.size = self.collectionView.bounds.size;
//
//    NSArray *visibleCells = self.collectionView.visibleCells;
//
//    for (UICollectionViewLayoutAttributes *attributes in array) {
//
//        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
//            if (CGRectIntersectsRect(attributes.frame, rect)) {
//                [self setLineAttributes: attributes visibleRect: visibleRect];
//            }
//        }
//    }
//    return array;
//}
//
//- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath: (NSIndexPath *) indexPath {
//    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath: indexPath];
//    CGRect visibleRect;
//    visibleRect.origin = self.collectionView.contentOffset;
//    visibleRect.size = self.collectionView.bounds.size;
//    [self setLineAttributes: attributes visibleRect: visibleRect];
//    return attributes;
//}



@end