//
// Created by Dani Postigo on 7/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFMindmapLayout.h"


@implementation TFMindmapLayout {

}

- (id) init {
    self = [super init];
    if (self) {
        _numberOfRows = 3;
        _spacing = 0;

    }

    return self;
}

#pragma mark - Setup

- (void) _setup {

    if (self.collectionView != nil) {
        if (_isFullscreen) {
            self.itemSize = self.collectionView.bounds.size;
        } else {
            CGFloat cellHeight = self.collectionView.bounds.size.height / _numberOfRows;
            self.itemSize = CGSizeMake(cellHeight, cellHeight);

        }
    }
}






#pragma mark - Public


- (void) setIsFullscreen: (BOOL) isFullscreen withCollectionView: (UICollectionView *) collectionView {

    if (isFullscreen) {
        collectionView.pagingEnabled = YES;
        self.itemSize = collectionView.bounds.size;

        //        self.sectionInset = UIEdgeInsetsZero;
        //        self.sectionInset = UIEdgeInsetsMake(-200, 0, 0, 0);

    } else {

        collectionView.pagingEnabled = NO;
        collectionView.alwaysBounceVertical = NO;
        CGFloat cellHeight = collectionView.bounds.size.height / _numberOfRows;
        self.itemSize = CGSizeMake(cellHeight, cellHeight);
        //        self.sectionInset = UIEdgeInsetsMake(-22, 0, 0, 0);
        //        self.sectionInset = UIEdgeInsetsZero;

    }

    self.isFullscreen = isFullscreen;

}

- (void) setIsFullscreen: (BOOL) isFullscreen {
    _isFullscreen = isFullscreen;
    [self invalidateLayout];
}

#pragma mark - Setup

- (void) prepareLayout {
    [super prepareLayout];
    [self _setup];

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
        origin.y = (currentRow * itemSize.height) + (_sectionInset.top);

        currentRow++;

        if (currentRow == _numberOfRows) {
            currentRow = 0;
            currentCol++;
        }

        attributes.frame = CGRectMake(origin.x, origin.y, itemSize.width, itemSize.height);
        [_attributesArray addObject: attributes];
    }

    if (_attributesArray && [_attributesArray count] > 0) {
        //        NSLog(@"_attributesArray[0] = %@", _attributesArray[0]);
    }

}


- (void) invalidateLayout {
    [super invalidateLayout];

    _attributesArray = nil;
}


- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect {

    //    NSLog(@"[_attributesArray count] = %u", [_attributesArray count]);
    //    return _attributesArray;
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    CGFloat numColumns = ceilf(rect.size.width / _itemSize.width);
    int numItems = (int) (numColumns * _numberOfRows);

    if (rect.origin.x == 0) {
        ret = [[_attributesArray subarrayWithRange: NSMakeRange(0, numItems)] mutableCopy];
    }

    //    NSLog(@"rect = %@", NSStringFromCGRect(rect));

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

    //    NSLog(@"%s, ret = %@", __PRETTY_FUNCTION__, ret);
    return ret;
}

- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath: (NSIndexPath *) indexPath {
    return _attributesArray[indexPath.item];
}

//
//
//- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect {
//    NSArray *attributes = [super layoutAttributesForElementsInRect: rect];
//    NSMutableArray *newAttributes = [NSMutableArray arrayWithCapacity: attributes.count];
//    for (UICollectionViewLayoutAttributes *attribute in attributes) {
//        if ((attribute.frame.origin.x + attribute.frame.size.width <= self.collectionViewContentSize.width) &&
//                (attribute.frame.origin.y + attribute.frame.size.height <= self.collectionViewContentSize.height)) {
//            [newAttributes addObject: attribute];
//        }
//    }
//    return newAttributes;
//}
//
//- (CGSize) collectionViewContentSize { //Workaround
//    CGSize superSize = [super collectionViewContentSize];
//    CGRect frame = self.collectionView.frame;
//    return CGSizeMake(fmaxf(superSize.width, CGRectGetWidth(frame)), fmaxf(superSize.height, CGRectGetHeight(frame)));
//}



#pragma mark - Bounds

- (CGSize) collectionViewContentSize {
    //    CGSize ret = [super collectionViewContentSize];

    //    CGRect frame = self.collectionView.frame;
    //    CGRect bounds = self.collectionView.bounds;

    //    ret = CGSizeMake(fmaxf(ret.width, CGRectGetWidth(frame)), fmaxf(ret.height, CGRectGetHeight(frame));

    CGSize ret;
    NSInteger itemCount = [self.collectionView numberOfItemsInSection: 0];
    CGFloat numColumns = ceilf(itemCount / _numberOfRows);

    //    if (_isFullscreen) {
    //        ret.width = numColumns * _itemSize.width;
    //        ret.height = _itemSize.height * _numberOfRows;
    //    } else {
    //
    //        ret.width = numColumns * _itemSize.width;
    //        //        ret.height = bounds.size.height;
    //        ret.height = _itemSize.height * _numberOfRows;
    //    }


    ret.width = numColumns * _itemSize.width;
    ret.height = _numberOfRows * _itemSize.height;

    return ret;
}


- (BOOL) shouldInvalidateLayoutForBoundsChange: (CGRect) newBounds {

    CGRect bounds = self.collectionView.bounds;

    return !CGRectEqualToRect(bounds, newBounds);
}



#pragma mark - Offset

- (CGPoint) targetContentOffsetForProposedContentOffset: (CGPoint) proposedContentOffset {
    CGPoint point = [super targetContentOffsetForProposedContentOffset: proposedContentOffset];

    if (self.isFullscreen) {
        NSArray *indexPaths = self.collectionView.indexPathsForSelectedItems;
        if ([indexPaths count] == 1) {
            NSIndexPath *indexPath = indexPaths[0];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath: indexPath];

            CGPoint newPoint = attributes.frame.origin;

            point = newPoint;

        }
    }

    return point;
}


@end