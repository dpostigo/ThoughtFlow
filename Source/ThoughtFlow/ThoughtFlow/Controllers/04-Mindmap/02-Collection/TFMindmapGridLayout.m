//
// Created by Dani Postigo on 7/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFMindmapGridLayout.h"


//CGFloat const TFCollectionViewDynamicFullLayoutRows = 3;

@implementation TFMindmapGridLayout {

}

- (instancetype) initWithCollection: (UICollectionView *) collection {
    self = [super init];
    if (self) {
        _collection = collection;
    }

    return self;
}


- (id) init {
    self = [super init];
    if (self) {
        _numberOfRows = 3;

    }

    return self;
}


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


#pragma mark - CollectionView



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

- (void) _setupFullscreen {

}

#pragma mark - Setup

- (void) prepareLayout {
    [super prepareLayout];

    if (_attributesArray == nil) {
        _attributesArray = [[NSMutableArray alloc] init];
    }

    NSInteger itemCount = [self.collectionView numberOfItemsInSection: 0];

    int currentRow = 0;
    int currentCol = 0;
    for (int j = 0; j < itemCount; j++) {
        UICollectionViewLayoutAttributes *attributes;
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath: [NSIndexPath indexPathForItem: j inSection: 0]];

        CGPoint origin;
        origin.x = (currentCol * _itemSize.width);
        origin.y = (currentRow * _itemSize.height) + (_sectionInset.top);

        currentRow++;

        if (currentRow == _numberOfRows) {
            currentRow = 0;
            currentCol++;
        }

        attributes.frame = CGRectMake(origin.x, origin.y, _itemSize.width, _itemSize.height);
        [_attributesArray addObject: attributes];
    }

    [self _setup];
}


- (void) invalidateLayout {
    [super invalidateLayout];

    _attributesArray = nil;
    [self _setup];
}


- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect {

    CGFloat numColumns = ceilf(rect.size.width / _itemSize.width);
    int numItems = (int) (numColumns * _numberOfRows);

    //    NSLog(@"numColumns = %f", numColumns);
    //    NSLog(@"numItems = %i", numItems);

    if (rect.origin.x == 0) {
        return [_attributesArray subarrayWithRange: NSMakeRange(0, numItems)];

    } else {

        //        NSLog(@"rect = %@", NSStringFromCGRect(rect));
        CGFloat firstColumn = ceilf(rect.origin.x / _itemSize.width);
        //        NSLog(@"firstColumn = %f", firstColumn);


        //        return [_attributesArray subarrayWithRange: NSMakeRange(first, numItems)];


    }

    rect = CGRectInset(rect, -_itemSize.width, -_itemSize.height);

    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (int j = 0; j < [_attributesArray count]; j++) {
        UICollectionViewLayoutAttributes *attributes = _attributesArray[j];

        CGRect frame = attributes.frame;
        if (CGRectContainsRect(rect, frame)) {
            [ret addObject: attributes];
        }

    }
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


- (CGSize) collectionViewContentSize {
    CGSize ret = [super collectionViewContentSize];

    CGRect frame = self.collectionView.frame;
    CGRect bounds = self.collectionView.bounds;

    //    ret = CGSizeMake(fmaxf(ret.width, CGRectGetWidth(frame)), fmaxf(ret.height, CGRectGetHeight(frame));

    NSInteger itemCount = [self.collectionView numberOfItemsInSection: 0];
    CGFloat numColumns = ceilf(itemCount / _numberOfRows);

    if (_isFullscreen) {
        ret.width = numColumns * _itemSize.width;
        ret.height = _itemSize.height * _numberOfRows;
    } else {

        ret.width = numColumns * _itemSize.width;
        ret.height = bounds.size.height;
    }

    //    ret.height += (_sectionInset.top + _sectionInset.bottom);
    //    NSLog(@"ret = %@", NSStringFromCGSize(ret));

    CGFloat boundsHeight = bounds.size.height;
    //    NSLog(@"boundsHeight = %f, ret.height = %f", boundsHeight, ret.height);

    return ret;
}
//
//- (BOOL) shouldInvalidateLayoutForBoundsChange: (CGRect) newBounds {
//    CGRect bounds = self.collectionView.bounds;
//    return ((CGRectGetWidth(newBounds) != CGRectGetWidth(bounds) ||
//            (CGRectGetHeight(newBounds) != CGRectGetHeight(bounds))));
//}

- (BOOL) shouldInvalidateLayoutForBoundsChange: (CGRect) newBounds {
    return YES;
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

            NSLog(@"self.isFullscreen = %d", self.isFullscreen);
            //        DDLogVerbose(@"proposedContentOffset = %@", NSStringFromCGPoint(proposedContentOffset));
            //        DDLogVerbose(@"point = %@", NSStringFromCGPoint(point));
            //        DDLogVerbose(@"newPoint = %@", NSStringFromCGPoint(newPoint));

        }
    }

    return point;
}


@end