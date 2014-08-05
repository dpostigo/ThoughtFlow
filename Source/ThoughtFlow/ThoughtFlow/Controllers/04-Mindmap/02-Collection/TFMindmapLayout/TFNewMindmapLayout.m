//
// Created by Dani Postigo on 7/26/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNewMindmapLayout.h"


@interface TFNewMindmapLayout ()

@property(nonatomic, strong) NSMutableArray *attributesArray;
@end


@implementation TFNewMindmapLayout

- (void) prepareLayout {
    [super prepareLayout];

    if (_attributesArray == nil) {
        _attributesArray = [[NSMutableArray alloc] init];
    }

    CGSize itemSize = _itemSize;
    NSInteger itemCount = [self.collectionView numberOfItemsInSection: 0];

    int currentRow = 0;
    int currentCol = 0;
    for (int j = 0; j < itemCount; j++) {
        UICollectionViewLayoutAttributes *attributes;
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath: [NSIndexPath indexPathForItem: j inSection: 0]];

        CGPoint origin;
        origin.x = (currentCol * itemSize.width);
        origin.y = (currentRow * itemSize.height);

        currentRow++;

        if (currentRow == _numberOfRows) {
            currentRow = 0;
            currentCol++;
        }

        attributes.frame = CGRectMake(origin.x, origin.y, itemSize.width, itemSize.height);
        [_attributesArray addObject: attributes];
    }
}

- (void) invalidateLayout {
    [super invalidateLayout];

    _attributesArray = nil;
}


- (CGSize) collectionViewContentSize {
    CGSize ret;
    NSInteger itemCount = [self.collectionView numberOfItemsInSection: 0];
    CGFloat numColumns = ceilf(itemCount / _numberOfRows);
    ret.width = numColumns * _itemSize.width;
    ret.height = _numberOfRows * _itemSize.height;
    return ret;
}


- (BOOL) shouldInvalidateLayoutForBoundsChange: (CGRect) newBounds {

    CGRect bounds = self.collectionView.bounds;

    return !CGRectEqualToRect(bounds, newBounds);
}


#pragma mark - Layout attributes


- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath: (NSIndexPath *) indexPath {
    return _attributesArray[indexPath.item];
}

- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect {

    NSMutableArray *ret = [[NSMutableArray alloc] init];
    CGFloat numColumns = ceilf(rect.size.width / _itemSize.width);
    int numItems = (int) (numColumns * _numberOfRows);

    if (rect.origin.x == 0) {
        ret = [[_attributesArray subarrayWithRange: NSMakeRange(0, numItems)] mutableCopy];
    }

    CGRect visibleRect;
    //    visibleRect.origin = self.collectionView.contentOffset;
    //    visibleRect.size = self.collectionView.contentSize;
    //    visibleRect = CGRectInset(visibleRect, -_itemSize.width, -_itemSize.height);

    visibleRect = CGRectInset(rect, -_itemSize.width * 2, -_itemSize.height);;

    for (int j = 0; j < [_attributesArray count]; j++) {
        UICollectionViewLayoutAttributes *attributes = _attributesArray[j];
        if (CGRectContainsRect(rect, visibleRect) || CGRectIntersectsRect(rect, visibleRect)) {
            //        if (CGRectIntersectsRect(attributes.frame, visibleRect)) {
            [ret addObject: attributes];
        }

    }

    return ret;
}


- (CGPoint) targetContentOffsetForProposedContentOffset: (CGPoint) proposedContentOffset {
    CGPoint point = [super targetContentOffsetForProposedContentOffset: proposedContentOffset];

    //    if (self.isFullscreen) {
    NSArray *indexPaths = self.collectionView.indexPathsForSelectedItems;
    if ([indexPaths count] == 1) {
        NSIndexPath *indexPath = indexPaths[0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath: indexPath];

        CGPoint newPoint = attributes.frame.origin;


        NSLog(@"proposedContentOffset = %@", NSStringFromCGPoint(proposedContentOffset));
        NSLog(@"point = %@", NSStringFromCGPoint(point));
    }
    //    }

    return point;
}

@end