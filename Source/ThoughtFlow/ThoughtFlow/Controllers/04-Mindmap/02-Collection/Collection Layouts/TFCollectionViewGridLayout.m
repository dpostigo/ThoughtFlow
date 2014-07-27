//
// Created by Dani Postigo on 7/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFCollectionViewGridLayout.h"


@interface TFCollectionViewGridLayout ()

@property(nonatomic, strong) NSMutableArray *attributesArray;
//@property(nonatomic) CGSize itemSize;
//@property(nonatomic) UIEdgeInsets sectionInset;
@end

@implementation TFCollectionViewGridLayout {

}

- (id) init {
    self = [super init];
    if (self) {
        [self _setup];
    }

    return self;
}

//
//- (void) _setup {
//
//    self.numberOfItemsPerLine = 3;
//    self.aspectRatio = 1;
//self.
//sectionInset = UIEdgeInsetsMake(-22, 0, 0, 0);
//    self.interitemSpacing = 0;
//    self.lineSpacing = 0;
//    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//
//}

//
- (void) _setup {

    CGFloat cellHeight = self.collectionView.bounds.size.height / 3;
    self.itemSize = CGSizeMake(cellHeight, cellHeight);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.sectionInset = UIEdgeInsetsMake(-22, 0, 0, 0);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;

}

- (void) prepareLayout {
    [super prepareLayout];
    [self _setup];
    //
    //    if (_attributesArray == nil) {
    //        _attributesArray = [[NSMutableArray alloc] init];
    //    }
    //
    //    CGRect bounds = self.collectionView.bounds;
    //    NSInteger itemCount = [self.collectionView numberOfItemsInSection: 0];
    //
    //    int maxCols = (int) (bounds.size.width / self.itemSize.width);
    //    int maxRows = (int) (bounds.size.height / self.itemSize.height);
    //
    //    int maxIndex = maxCols * maxRows;
    //
    //    int maxWidth = maxCols * self.itemSize.width;
    //    int maxHeight = maxRows * self.itemSize.height;
    //
    //
    //    //    NSArray *points = @[
    //    //            [NSValue valueWithCGPoint: CGPointMake(0, 0), @({1, 0}), @({2, 0}),
    //    //                                       @({0, 1}), @({1, 1}), @({2, 1}),
    //    //                                       @({0, 2}), @({1, 2}), @({2, 2}),
    //    //            ];
    //    //
    //
    //
    //    NSMutableArray *points = [[NSMutableArray alloc] init];
    //    for (int k = 0; k < 3; k++) {
    //        for (int j = 0; j < 3; j++) {
    //            [points addObject: [NSValue valueWithCGPoint: CGPointMake(j, k)]];
    //        }
    //    }
    //
    //    // generate the new attributes array for each photo in the stack
    //    for (NSInteger i = 0; i < itemCount; i++) {
    //
    //        UICollectionViewLayoutAttributes *attributes;
    //        attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath: [NSIndexPath indexPathForItem: i inSection: 0]];
    //
    //        //        attributes.center = center;
    //
    //        CGPoint origin;
    //
    //        int indexValue = i / maxIndex;
    //        int dividedValue = i / maxCols;
    //        int modValueX = i % maxCols;
    //        int modValueY = i % maxRows;
    //        origin.x = (modValueX * self.itemSize.width) + (indexValue * maxWidth);
    //        //        origin.y = ((int) (i / maxRows)) * bounds.size.height;
    //        origin.y = ((int) (i % maxRows)) * maxHeight;
    //        //        origin.y = ((i % 9) % 3) * self.itemSize.height;
    //
    //
    //        int indexMod = i % maxIndex;
    //        int valueX = i / maxIndex;
    //        CGPoint matrixPoint = [points[indexMod] CGPointValue];
    //
    //        CGPoint point;
    //        point.x = (valueX * maxWidth) + (matrixPoint.x * self.itemSize.width);
    //        point.y = (matrixPoint.y * self.itemSize.height) + (self.sectionInset.top);
    //
    //        attributes.size = self.itemSize;
    //        attributes.frame = CGRectMake(point.x, point.y, self.itemSize.width, self.itemSize.height);
    //
    //        //        NSLog(@"attributes = %@", attributes);
    //
    //        [_attributesArray addObject: attributes];
    //    }
    //
    //    //    NSLog(@"_attributesArray = %@", _attributesArray);

}
//
//
//- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath: (NSIndexPath *) indexPath {
//    return _attributesArray[indexPath.item];
//}
//
//
//- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect {
//    return _attributesArray;
//}


- (void) prepareForTransitionToLayout: (UICollectionViewLayout *) newLayout {
    [super prepareForTransitionToLayout: newLayout];

    NSLog(@"%s, newLayout = %@", __PRETTY_FUNCTION__, newLayout);
}

- (void) prepareForTransitionFromLayout: (UICollectionViewLayout *) oldLayout {
    [super prepareForTransitionFromLayout: oldLayout];

    NSLog(@"%s, oldLayout = %@", __PRETTY_FUNCTION__, oldLayout);
}


- (void) invalidateLayout {
    [super invalidateLayout];
    _attributesArray = nil;
    [self _setup];

}


#pragma mark -

- (CGPoint) targetContentOffsetForProposedContentOffset: (CGPoint) proposedContentOffset {
    CGPoint point = [super targetContentOffsetForProposedContentOffset: proposedContentOffset];

    DDLogVerbose(@"%s, proposedContentOffset = %@", __PRETTY_FUNCTION__, NSStringFromCGPoint(proposedContentOffset));
    DDLogVerbose(@"%s, point = %@", __PRETTY_FUNCTION__, NSStringFromCGPoint(point));
    return point;
}

//
//- (void) invalidateLayoutWithContext: (UICollectionViewLayoutInvalidationContext *) context {
//    [super invalidateLayoutWithContext: context];
//
//}
//
- (BOOL) shouldInvalidateLayoutForBoundsChange: (CGRect) newBounds {
    CGRect bounds = self.collectionView.bounds;
    return ((CGRectGetWidth(newBounds) != CGRectGetWidth(bounds) ||
            (CGRectGetHeight(newBounds) != CGRectGetHeight(bounds))));
}




//- (void) prepareForAnimatedBoundsChange: (CGRect) oldBounds {
//    [super prepareForAnimatedBoundsChange: oldBounds];
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}
//
//- (void) prepareForCollectionViewUpdates: (NSArray *) updateItems {
//    [super prepareForCollectionViewUpdates: updateItems];
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}
//
//- (void) prepareForTransitionToLayout: (UICollectionViewLayout *) newLayout {
//    [super prepareForTransitionToLayout: newLayout];
//}
//
//- (void) prepareForTransitionFromLayout: (UICollectionViewLayout *) oldLayout {
//    [super prepareForTransitionFromLayout: oldLayout];
//}
//
//- (void) finalizeLayoutTransition {
//    [super finalizeLayoutTransition];
//}


//
//- (CGSize) collectionViewContentSize {
//    CGRect bounds = self.collectionView.bounds;
//
//    int maxCols = (int) (bounds.size.width / self.itemSize.width);
//    int maxRows = (int) (bounds.size.height / self.itemSize.height);
//
//    int maxItemsPerPage = maxCols * maxRows;
//
//    NSInteger itemCount = [self.collectionView numberOfItemsInSection: 0];
//
//
//    int numPages = (int) ceilf(itemCount / maxItemsPerPage);
//
//    CGSize ret = self.collectionView.bounds.size;
//    ret.width = numPages * bounds.size.width;
//
//    return ret;
//}

@end