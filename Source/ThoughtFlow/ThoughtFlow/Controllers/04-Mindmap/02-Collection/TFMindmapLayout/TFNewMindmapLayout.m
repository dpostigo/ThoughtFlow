//
// Created by Dani Postigo on 7/26/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNewMindmapLayout.h"


@interface TFNewMindmapLayout ()

@property(nonatomic) CGSize previousItemSize;

@property(nonatomic, strong) NSIndexPath *selectedIndexPath;
@property(nonatomic, strong) UICollectionViewLayoutAttributes *selectedLayoutAttributes;
@property(nonatomic, strong) NSMutableArray *attributesArray;
@end


@implementation TFNewMindmapLayout


#pragma mark - Public

- (void) startDynamicTransition {
    _previousItemSize = _itemSize;
}



#pragma mark - UICollectionViewLayout

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

    if (_updatesContentOffset) {
        [self _refreshContentOffset];
    }

}


- (void) invalidateLayout {
    [super invalidateLayout];

    NSArray *indexPaths = self.collectionView.indexPathsForSelectedItems;
    if ([indexPaths count] == 1) {
        _selectedIndexPath = indexPaths[0];
    } else {
        _selectedIndexPath = nil;
    }
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
    //    NSLog(@"%s, newBounds = %@", __PRETTY_FUNCTION__, NSStringFromCGRect(newBounds));
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
    visibleRect = CGRectInset(rect, -_itemSize.width, -_itemSize.height);

    for (int j = 0; j < [_attributesArray count]; j++) {
        UICollectionViewLayoutAttributes *attributes = _attributesArray[j];
        if (CGRectIntersectsRect(visibleRect, attributes.frame)) {
            [ret addObject: attributes];
        }
    }

    return ret;
}





#pragma mark - Private


- (void) _refreshContentOffset {
    if (_selectedIndexPath) {
        self.collectionView.contentOffset = [self _calculatedContentOffset];
    }
}


- (CGPoint) _calculatedContentOffset {
    UICollectionViewLayoutAttributes *attributes = _attributesArray[_selectedIndexPath.item];
    CGRect bounds = self.collectionView.bounds;

    CGSize contentSize = [self collectionViewContentSize];
    contentSize.width -= bounds.size.width;
    contentSize.height -= bounds.size.height;

    CGSize offsetSize = CGSizeMake((bounds.size.width - _itemSize.width) / 2, (bounds.size.height - _itemSize.height) / 2);
    CGFloat offsetX = fminf(fmaxf(attributes.frame.origin.x - offsetSize.width, 0), contentSize.width);
    CGFloat offsetY = fminf(fmaxf(attributes.frame.origin.y - offsetSize.height, 0), contentSize.height);

    return CGPointMake(offsetX, offsetY);

}

- (NSIndexPath *) selectedIndexPath {
    NSIndexPath *ret = nil;

    NSArray *indexPaths = self.collectionView.indexPathsForSelectedItems;
    if ([indexPaths count] == 1) {
        ret = indexPaths[0];
    }
    return ret;
}
//
//- (CGPoint) targetContentOffsetForProposedContentOffset: (CGPoint) proposedContentOffset {
//    CGPoint point = [super targetContentOffsetForProposedContentOffset: proposedContentOffset];
//
//    if (self.updatesTargetedOffset) {
//        NSArray *indexPaths = self.collectionView.indexPathsForSelectedItems;
//        if ([indexPaths count] == 1) {
//            NSIndexPath *indexPath = indexPaths[0];
//            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath: indexPath];
//
//            CGPoint newPoint = attributes.frame.origin;
//            point = newPoint;
//
//        }
//    }
//
//    return point;
//}


@end